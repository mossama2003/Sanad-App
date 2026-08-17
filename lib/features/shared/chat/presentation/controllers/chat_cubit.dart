import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../../core/storage/hive/hive_boxes.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../volunteer/community/data/cache/community_cache_service.dart';
import '../../../../volunteer/events/data/models/volunteer_event_details_model.dart';
import '../../../../volunteer/events/presentation/dialogs/volunteer_event_details_bottom_sheet.dart';
import '../../data/cache/chat_cache_service.dart';
import '../../data/enums/member_role_enum.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/member_model.dart';
import '../../data/models/search_messages.dart';
import '../../data/repos/chat_repo.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  final int eventId;
  final int currentUserId;
  String currentUserName;
  List<SearchResultMessageModel> searchResults = [];
  bool isSearching = false;
  bool searchHasMore = false;
  int _searchPage = 1;
  String _lastSearchQuery = '';
  int _pendingOnlineCount = 0;
  Set<int> _pendingOnlineUserIds = {};
  bool _pendingPresenceReady = false;

  ably.Realtime? _realtime;
  ably.RealtimeChannel? _channel;
  StreamSubscription<ably.Message>? _messageSubscription;
  StreamSubscription<ably.PresenceMessage>? _presenceSubscription;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final ValueNotifier<int> searchResultsNotifier = ValueNotifier(0);

  final ValueNotifier<bool> membersReadyNotifier = ValueNotifier(false);
  final Map<int, Timer> _typingClearTimers = {};
  Timer? _typingSendThrottle;

  ChatCubit({
    required this.chatRepo,
    required this.eventId,
    required this.currentUserId,
    this.currentUserName = 'You',
  }) : super(ChatInitial());

  void updateCurrentUserName(String name) {
    if (name.trim().isEmpty) return;
    currentUserName = name;
  }

  int? _extractUserIdFromClientId(String? clientId) {
    if (clientId == null) return null;
    final parts = clientId.split(':');
    if (parts.length != 2) return null;
    return int.tryParse(parts[1]);
  }

  void _handlePresenceMessage(ably.PresenceMessage msg) {
    final userId = _extractUserIdFromClientId(msg.clientId);
    if (userId == null) return;

    final updated = Set<int>.from(_pendingOnlineUserIds);

    switch (msg.action) {
      case ably.PresenceAction.enter:
      case ably.PresenceAction.update:
      case ably.PresenceAction.present:
        updated.add(userId);
        break;
      case ably.PresenceAction.leave:
      case ably.PresenceAction.absent:
        updated.remove(userId);
        break;
      default:
        break;
    }

    _pendingOnlineUserIds = updated;
    _pendingOnlineCount = updated.length;
    _pendingPresenceReady = true;

    debugPrint("Presence event: ${msg.action} → ids: $updated");

    _emitPendingPresenceIfLoaded();
  }

  void _emitPendingPresenceIfLoaded() {
    final current = state;
    if (current is! ChatLoaded) return;

    emit(
      current.copyWith(
        onlineCount: _pendingOnlineCount,
        isPresenceReady: true,
        onlineUserIds: _pendingOnlineUserIds,
      ),
    );
  }

  Future<void> initChat() async {
    final cached = await ChatCacheService.getCachedMessages(eventId);
    final hasCache = cached.isNotEmpty;

    if (hasCache) {
      emit(
        ChatLoaded(
          messages: cached
              .map((e) => e.toUiModel(currentUserId: currentUserId))
              .toList(),
          page: 1,
          hasMore: true,
          isSyncing: true,
        ),
      );
    } else {
      emit(ChatLoading());
    }

    final results = await Future.wait([
      chatRepo.getChatToken(eventId),
      chatRepo.getChatHistory(eventId: eventId, page: 1),
      chatRepo.getEventMembers(eventId: eventId, page: 1),
    ]);

    final tokenResult = results[0] as Either<Failure, ChatTokenModel>;
    final historyResult =
        results[1] as Either<Failure, PaginatedEventChatModel>;
    final membersResult = results[2] as Either<Failure, PaginatedMemberModel>;

    tokenResult.fold((_) {}, (token) {
      _connectToAbly(token);
    });

    final totalMembersCount = membersResult.fold(
      (failure) {
        debugPrint('⚠️ getEventMembers FAILED: ${failure.errMessage}');
        return 0;
      },
      (data) {
        debugPrint('✅ getEventMembers SUCCESS: count = ${data.count}');
        return data.count;
      },
    );
    
    membersReadyNotifier.value = true;

    await historyResult.fold(
      (failure) async {
        if (!hasCache) {
          emit(ChatError(failure.errMessage));
        } else {
          final current = state;
          if (current is ChatLoaded) {
            emit(
              current.copyWith(
                isSyncing: false,
                totalMembersCount: totalMembersCount,
                onlineCount: _pendingPresenceReady
                    ? _pendingOnlineCount
                    : current.onlineCount,
                isPresenceReady: _pendingPresenceReady
                    ? true
                    : current.isPresenceReady,
                onlineUserIds: _pendingPresenceReady
                    ? _pendingOnlineUserIds
                    : current.onlineUserIds,
              ),
            );
          }
        }
      },
      (data) async {
        final existingCached = await ChatCacheService.getCachedMessages(
          eventId,
        );
        final editedStatusMap = {
          for (final m in existingCached) m.id: m.isEdited,
        };

        final mergedResults = data.results.map((m) {
          final wasEdited = editedStatusMap[m.id] ?? false;
          if (!wasEdited) return m;

          return EventChatDetailModel(
            id: m.id,
            creator: m.creator,
            role: m.role,
            created: m.created,
            modified: m.modified,
            message: m.message,
            isEdited: true,
          );
        }).toList();

        await ChatCacheService.cacheMessages(eventId, mergedResults);

        final serverMessages = mergedResults
            .map((e) => e.toUiModel(currentUserId: currentUserId))
            .toList();

        final current = state;

        if (current is ChatLoaded && hasCache) {
          emit(
            current.copyWith(
              messages: serverMessages,
              page: 1,
              hasMore: data.hasMore,
              isSyncing: false,
              totalMembersCount: totalMembersCount,
              onlineCount: _pendingPresenceReady
                  ? _pendingOnlineCount
                  : current.onlineCount,
              isPresenceReady: _pendingPresenceReady
                  ? true
                  : current.isPresenceReady,
              onlineUserIds: _pendingPresenceReady
                  ? _pendingOnlineUserIds
                  : current.onlineUserIds,
            ),
          );
        } else {
          emit(
            ChatLoaded(
              messages: serverMessages,
              page: 1,
              hasMore: data.hasMore,
              isSyncing: false,
              totalMembersCount: totalMembersCount,
              onlineCount: _pendingOnlineCount,
              isPresenceReady: _pendingPresenceReady,
              onlineUserIds: _pendingOnlineUserIds,
            ),
          );
        }
      },
    );
  }

  Future<void> _connectToAbly(ChatTokenModel token) async {
    _realtime = ably.Realtime(
      options: ably.ClientOptions(
        clientId: token.clientId,
        authCallback: (params) async {
          return ably.TokenRequest(
            keyName: token.keyName,
            clientId: token.clientId,
            timestamp: DateTime.fromMillisecondsSinceEpoch(token.timestamp),
            nonce: token.nonce,
            mac: token.mac,
            ttl: token.ttl,
            capability: token.capability,
          );
        },
      ),
    );

    _channel = _realtime!.channels.get('events:$eventId');

    _realtime!.connection.on().listen((stateChange) {
      debugPrint('🔌 Ably connection state: ${stateChange.current}');
    });

    await _channel!.attach();
    debugPrint(
      '📡 Channel attached: events:$eventId | state: ${_channel!.state}',
    );

    // نبني الـ set بشكل تراكمي من كل presence message بدل ما نعمل get() كل مرة
    _presenceSubscription = _channel!.presence.subscribe().listen((msg) {
      _handlePresenceMessage(msg);
    });

    // نضيف نفسنا فورًا (optimistic) من غير ما نستنى تأكيد enter()
    _pendingOnlineUserIds = {..._pendingOnlineUserIds, currentUserId};
    _pendingOnlineCount = _pendingOnlineUserIds.length;
    _pendingPresenceReady = true;
    _emitPendingPresenceIfLoaded();

    // 👈 التعديل الأهم: نجيب لستة الأونلاين الحالية فورًا وبالتوازي مع enter()
    // بدل ما نستنى enter() يخلص الأول وبعدين نجيب اللستة - ده كان سبب التأخير
    unawaited(_updateOnlineCount());

    unawaited(
      _channel!.presence.enter().catchError((e) {
        debugPrint('⚠️ Failed to enter presence: $e');
      }),
    );

    _messageSubscription = _channel!.subscribe().listen((message) {
      debugPrint(
        '📩 Realtime event received: name=${message.name}, data=${message.data}',
      );

      switch (message.name) {
        case 'typing':
          _onTypingEvent(message);
          return;
        default:
          _onRealtimeMessage(message);
      }
    });
  }

  Future<void> _updateOnlineCount() async {
    if (_channel == null) return;

    try {
      final members = await _channel!.presence.get();

      final ids = members
          .map((m) => m.clientId)
          .map(_extractUserIdFromClientId)
          .whereType<int>()
          .toSet();

      debugPrint("Presence get(): ${members.length}, ids: $ids");

      _pendingOnlineUserIds = ids;
      _pendingOnlineCount = ids.length;
      _pendingPresenceReady = true;

      _emitPendingPresenceIfLoaded();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ── Typing indicator: sending ──────────────────────────────────────────
  void notifyTyping() {
    if (_channel == null) return;

    if (_typingSendThrottle?.isActive ?? false) return;

    _typingSendThrottle = Timer(const Duration(milliseconds: 1500), () {});

    _channel!
        .publish(
          name: 'typing',
          data: {'userId': currentUserId, 'name': currentUserName},
        )
        .catchError((e) {
          debugPrint('⚠️ Failed to publish typing event: $e');
        });
  }

  // ── Typing indicator: receiving ──────────────────────────────────────────
  void _onTypingEvent(ably.Message message) {
    final data = message.data;
    if (data is! Map) return;

    final converted = _deepConvertMap(data);
    final userId = converted['userId'];
    final name = converted['name'];

    if (userId is! int || name is! String) return;
    if (userId == currentUserId) return;

    final current = state;
    if (current is! ChatLoaded) return;

    final updatedTyping = Map<int, String>.from(current.typingUsers);
    updatedTyping[userId] = name;
    emit(current.copyWith(typingUsers: updatedTyping));

    _typingClearTimers[userId]?.cancel();
    _typingClearTimers[userId] = Timer(const Duration(seconds: 3), () {
      final latest = state;
      if (latest is! ChatLoaded) return;

      final cleared = Map<int, String>.from(latest.typingUsers)..remove(userId);
      emit(latest.copyWith(typingUsers: cleared));
    });
  }

  String _pythonReprToJson(String input) {
    final buffer = StringBuffer();
    bool inString = false;
    int i = 0;
    final length = input.length;

    while (i < length) {
      final char = input[i];

      if (!inString) {
        if (char == "'") {
          inString = true;
          buffer.write('"');
          i++;
          continue;
        }
        if (_matchesKeyword(input, i, 'True')) {
          buffer.write('true');
          i += 4;
          continue;
        }
        if (_matchesKeyword(input, i, 'False')) {
          buffer.write('false');
          i += 5;
          continue;
        }
        if (_matchesKeyword(input, i, 'None')) {
          buffer.write('null');
          i += 4;
          continue;
        }
        buffer.write(char);
        i++;
      } else {
        if (char == '\\' && i + 1 < length && input[i + 1] == "'") {
          buffer.write("'");
          i += 2;
          continue;
        }
        if (char == '\\' && i + 1 < length) {
          buffer.write(char);
          buffer.write(input[i + 1]);
          i += 2;
          continue;
        }
        if (char == '"') {
          buffer.write('\\"');
          i++;
          continue;
        }
        if (char == "'") {
          inString = false;
          buffer.write('"');
          i++;
          continue;
        }
        buffer.write(char);
        i++;
      }
    }

    return buffer.toString();
  }

  bool _matchesKeyword(String input, int index, String keyword) {
    if (index + keyword.length > input.length) return false;
    if (input.substring(index, index + keyword.length) != keyword) return false;

    final nextIndex = index + keyword.length;
    if (nextIndex < input.length) {
      final nextChar = input[nextIndex];
      if (RegExp(r'[A-Za-z0-9_]').hasMatch(nextChar)) return false;
    }
    return true;
  }

  Map<String, dynamic> _deepConvertMap(dynamic input) {
    if (input is Map) {
      return input.map(
        (key, value) => MapEntry(key.toString(), _deepConvertValue(value)),
      );
    }
    return {};
  }

  dynamic _deepConvertValue(dynamic value) {
    if (value is Map) {
      return _deepConvertMap(value);
    }
    if (value is List) {
      return value.map(_deepConvertValue).toList();
    }
    return value;
  }

  Future<void> _playSound(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (_) {
      // تجاهل أي خطأ تشغيل صوت
    }
  }

  // ── Realtime incoming message (مع Dedupe + Optimistic Replace) ──────────────
  Future<void> _onRealtimeMessage(ably.Message message) async {
    final current = state;
    if (current is! ChatLoaded) return;

    Map<String, dynamic> data;
    final rawData = message.data;

    if (rawData is Map) {
      data = _deepConvertMap(rawData);
    } else if (rawData is String) {
      try {
        data = Map<String, dynamic>.from(jsonDecode(rawData));
      } catch (_) {
        try {
          final fixed = _pythonReprToJson(rawData);
          data = Map<String, dynamic>.from(jsonDecode(fixed));
        } catch (e) {
          debugPrint('⚠️ Failed to parse realtime message: $e');
          return;
        }
      }
    } else {
      return;
    }

    final rawMessage = data['message'];
    final rawCreator = data['creator'];
    if (rawMessage == null ||
        (rawMessage is String && rawMessage.trim().isEmpty) ||
        rawCreator == null) {
      debugPrint('⚠️ Ignored non-chat realtime payload: $data');
      return;
    }

    final chatMsg = EventChatDetailModel.fromJson(data);
    final incomingMessage = chatMsg.toUiModel(currentUserId: currentUserId);

    final alreadyExists = current.messages.any((m) => m.id == chatMsg.id);
    if (alreadyExists) return;

    final optimisticIndex = current.messages.indexWhere(
      (m) =>
          m.localId != null &&
          m.text.trim() == chatMsg.message.trim() &&
          m.senderName == 'You',
    );

    if (optimisticIndex != -1) {
      final updatedMessages = [...current.messages];
      updatedMessages[optimisticIndex] = incomingMessage;

      await ChatCacheService.cacheMessage(eventId, chatMsg);
      emit(current.copyWith(messages: updatedMessages));
      return;
    }

    final isFromOtherUser = chatMsg.creator.id != currentUserId;
    if (isFromOtherUser) {
      _playSound('sounds/message_received.mp3');
    }

    await ChatCacheService.cacheMessage(eventId, chatMsg);
    emit(current.copyWith(messages: [...current.messages, incomingMessage]));
  }

  // ── Pagination on scroll up ────────────────────────────────────────────
  Future<void> loadMoreHistory() async {
    final current = state;
    if (current is! ChatLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    if (current.highlightedMessageId != null) {
      final oldestId = current.messages.firstOrNull?.id;

      if (oldestId == null) {
        emit(current.copyWith(isLoadingMore: false));
        return;
      }

      final result = await chatRepo.getMessageContext(
        eventId: eventId,
        messageId: oldestId,
      );

      result.fold(
        (failure) {
          emit(current.copyWith(isLoadingMore: false));
          AppToast.error(failure.errMessage);
        },
        (context) async {
          final existingCached = await ChatCacheService.getCachedMessages(
            eventId,
          );

          final editedStatusMap = {
            for (final m in existingCached) m.id: m.isEdited,
          };

          final mergedOlder = context.older.map((m) {
            final wasEdited = editedStatusMap[m.id] ?? false;

            if (!wasEdited) return m;

            return EventChatDetailModel(
              id: m.id,
              creator: m.creator,
              role: m.role,
              created: m.created,
              modified: m.modified,
              message: m.message,
              isEdited: true,
            );
          }).toList();

          await ChatCacheService.cacheMessages(eventId, mergedOlder);

          final existingIds = current.messages
              .map((e) => e.id)
              .whereType<int>()
              .toSet();

          final olderMessages = mergedOlder
              .map((e) => e.toUiModel(currentUserId: currentUserId))
              .where((e) => e.id == null || !existingIds.contains(e.id))
              .toList();

          emit(
            current.copyWith(
              messages: [...olderMessages, ...current.messages],
              hasMore: context.hasMoreBefore,
              isLoadingMore: false,
            ),
          );
        },
      );

      return;
    }

    final nextPage = current.page + 1;

    final result = await chatRepo.getChatHistory(
      eventId: eventId,
      page: nextPage,
    );

    result.fold(
      (failure) {
        emit(current.copyWith(isLoadingMore: false));
        AppToast.error(failure.errMessage);
      },
      (data) async {
        final existingCached = await ChatCacheService.getCachedMessages(
          eventId,
        );

        final editedStatusMap = {
          for (final m in existingCached) m.id: m.isEdited,
        };

        final mergedResults = data.results.map((m) {
          final wasEdited = editedStatusMap[m.id] ?? false;

          if (!wasEdited) return m;

          return EventChatDetailModel(
            id: m.id,
            creator: m.creator,
            role: m.role,
            created: m.created,
            modified: m.modified,
            message: m.message,
            isEdited: true,
          );
        }).toList();

        await ChatCacheService.cacheMessages(eventId, mergedResults);

        final olderMessages = mergedResults
            .map((e) => e.toUiModel(currentUserId: currentUserId))
            .toList();

        emit(
          current.copyWith(
            messages: [...olderMessages, ...current.messages],
            page: nextPage,
            hasMore: data.hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  // ── Send message (REST API + optimistic UI) ────────────────────────────
  Future<void> sendMessage(String text, {int? parentId}) async {
    final current = state;
    if (text.trim().isEmpty || current is! ChatLoaded) return;

    final localId = DateTime.now().microsecondsSinceEpoch.toString();

    final optimisticMsg = ChatModel(
      localId: localId,
      senderName: 'You',
      text: text,
      time: DateFormat('h:mm a').format(DateTime.now()),
      createdAt: DateTime.now(),
      avatarColor: AppColors.primary,
      avatarLetter: 'Y',
      status: ChatMessageStatus.sending,
      parentId: parentId,
    );

    emit(current.copyWith(messages: [...current.messages, optimisticMsg]));

    _playSound('sounds/message_send.mp3');

    final result = await chatRepo.sendMessage(
      eventId: eventId,
      message: text,
      parentId: parentId,
    );

    result.fold((failure) {
      _updateMessageStatus(localId, ChatMessageStatus.failed);
      AppToast.error(failure.errMessage);
    }, (sent) => _updateMessageId(localId, sent.id));
  }

  // ── Retry a failed message ───────────────────────────────────────────
  Future<void> retryMessage(String localId) async {
    final current = state;
    if (current is! ChatLoaded) return;

    final index = current.messages.indexWhere((m) => m.localId == localId);
    if (index == -1) return;

    final msg = current.messages[index];

    _updateMessageStatus(localId, ChatMessageStatus.sending);

    final result = await chatRepo.sendMessage(
      eventId: eventId,
      message: msg.text,
      parentId: msg.parentId,
    );

    result.fold((failure) {
      _updateMessageStatus(localId, ChatMessageStatus.failed);
      AppToast.error(failure.errMessage);
    }, (sent) => _updateMessageId(localId, sent.id));
  }

  void _updateMessageStatus(String localId, ChatMessageStatus status) {
    final current = state;
    if (current is! ChatLoaded) return;

    final updated = current.messages
        .map((m) => m.localId == localId ? m.copyWith(status: status) : m)
        .toList();

    emit(current.copyWith(messages: updated));
  }

  void _updateMessageId(String localId, int serverId) {
    final current = state;
    if (current is! ChatLoaded) return;

    final updated = current.messages
        .map(
          (m) => m.localId == localId
              ? m.copyWith(id: serverId, status: ChatMessageStatus.sent)
              : m,
        )
        .toList();

    emit(current.copyWith(messages: updated));
  }

  // ── Edit message (optimistic + rollback on failure) ────────────────────
  Future<void> editMessage({
    required int messageId,
    required String newText,
  }) async {
    final current = state;
    if (current is! ChatLoaded) return;

    final index = current.messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final backup = current.messages;
    final updatedMessages = [...current.messages];
    updatedMessages[index] = updatedMessages[index].copyWith(
      text: newText,
      isEdited: true,
    );

    emit(current.copyWith(messages: updatedMessages));

    final result = await chatRepo.editMessage(
      messageId: messageId,
      message: newText,
    );

    result.fold(
      (failure) {
        emit(current.copyWith(messages: backup));
        AppToast.error(failure.errMessage);
      },
      (_) async {
        await ChatCacheService.updateCachedMessageText(
          eventId: eventId,
          messageId: messageId,
          newText: newText,
          modified: DateTime.now(),
        );
      },
    );
  }

  // ── Delete single message (from Action Sheet) ───────────────────────────
  Future<void> deleteSingleMessage(int messageId) async {
    final current = state;
    if (current is! ChatLoaded) return;

    final backup = current.messages;
    final updatedMessages = current.messages
        .where((m) => m.id != messageId)
        .toList();

    emit(current.copyWith(messages: updatedMessages));

    final result = await chatRepo.deleteMessages([messageId]);

    result.fold(
      (failure) {
        final rolledBack = state;
        if (rolledBack is ChatLoaded) {
          emit(rolledBack.copyWith(messages: backup));
        }
        AppToast.error(failure.errMessage);
      },
      (_) async {
        await ChatCacheService.deleteCachedMessages(eventId, [messageId]);
      },
    );
  }

  // ── Selection mode ───────────────────────────────────────────────────
  void enterSelectionMode(int messageId) {
    final current = state;
    if (current is! ChatLoaded) return;

    emit(
      current.copyWith(isSelectionMode: true, selectedMessageIds: {messageId}),
    );
  }

  void toggleMessageSelection(int messageId, {required bool isOwnMessage}) {
    if (!isOwnMessage) return;

    final current = state;
    if (current is! ChatLoaded) return;

    final updated = Set<int>.from(current.selectedMessageIds);
    if (updated.contains(messageId)) {
      updated.remove(messageId);
    } else {
      updated.add(messageId);
    }

    if (updated.isEmpty) {
      emit(current.copyWith(isSelectionMode: false, selectedMessageIds: {}));
      return;
    }

    emit(current.copyWith(selectedMessageIds: updated));
  }

  void exitSelectionMode() {
    final current = state;
    if (current is! ChatLoaded) return;

    emit(current.copyWith(isSelectionMode: false, selectedMessageIds: {}));
  }

  Future<void> deleteSelectedMessages() async {
    final current = state;
    if (current is! ChatLoaded || current.selectedMessageIds.isEmpty) return;

    final ids = current.selectedMessageIds.toList();
    final backup = current.messages;

    final updatedMessages = current.messages
        .where((m) => m.id == null || !ids.contains(m.id))
        .toList();

    emit(
      current.copyWith(
        messages: updatedMessages,
        isSelectionMode: false,
        selectedMessageIds: {},
      ),
    );

    final result = await chatRepo.deleteMessages(ids);

    result.fold(
      (failure) {
        final rolledBack = state;
        if (rolledBack is ChatLoaded) {
          emit(rolledBack.copyWith(messages: backup));
        }
        AppToast.error(failure.errMessage);
      },
      (deletedIds) async {
        await ChatCacheService.deleteCachedMessages(eventId, deletedIds);
      },
    );
  }

  Future showEventDetails(BuildContext context, int eventId) async {
    final cachedEvent = _getEventFromCache(eventId);

    if (cachedEvent != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => VolunteerEventDetailsBottomSheet(
          event: cachedEvent,
          showJoinButton: false,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await DioHelper.get(url: EVENT_QR(eventId));

      final eventDetails = VolunteerEventDetailsModel.fromJson(response.data);

      if (!context.mounted) return;

      Navigator.pop(context);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => VolunteerEventDetailsBottomSheet(
          event: eventDetails,
          showJoinButton: false,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;

      Navigator.pop(context);

      AppToast.error('shared.chat.event_details_failed'.tr());
    }
  }

  VolunteerEventDetailsModel? _getEventFromCache(int eventId) {
    final box = HiveBoxes.volunteerEventsBox;
    try {
      return box.values.firstWhere((e) => e.id == eventId);
    } catch (_) {
      return null;
    }
  }

  Future<bool> leaveEvent() async {
    final result = await chatRepo.leaveEvent(eventId);

    return await result.fold(
      (failure) async {
        AppToast.error(failure.errMessage);
        return false;
      },
      (_) async {
        await CommunityCacheService.removeCommunity(eventId);

        AppToast.success('shared.chat.left_event_success'.tr());

        return true;
      },
    );
  }

  Future<void> reportEvent(String? reason) async {
    final result = await chatRepo.reportEvent(eventId: eventId, reason: reason);

    result.fold(
      (failure) => AppToast.error(failure.errMessage),
      (_) => AppToast.success('shared.chat.report_submitted'.tr()),
    );
  }

  // ── Search ────────────────────────────────────────────────────────────
  Future<void> searchMessages(String query) async {
    if (query.trim().isEmpty) {
      searchResults = [];
      _searchPage = 1;
      searchHasMore = false;
      searchResultsNotifier.value++;
      return;
    }

    _lastSearchQuery = query.trim();
    isSearching = true;
    _searchPage = 1;
    searchResultsNotifier.value++;

    final result = await chatRepo.searchMessages(
      eventId: eventId,
      query: _lastSearchQuery,
      page: 1,
    );

    isSearching = false;

    result.fold(
      (failure) {
        searchResults = [];
        searchHasMore = false;
        AppToast.error(failure.errMessage);
        searchResultsNotifier.value++;
      },
      (data) {
        searchResults = data.results;
        searchHasMore = data.hasMore;
        searchResultsNotifier.value++;
      },
    );
  }

  Future<void> loadMoreSearchResults() async {
    if (!searchHasMore || isSearching || _lastSearchQuery.isEmpty) return;

    isSearching = true;
    final nextPage = _searchPage + 1;

    final result = await chatRepo.searchMessages(
      eventId: eventId,
      query: _lastSearchQuery,
      page: nextPage,
    );

    isSearching = false;

    result.fold((failure) => AppToast.error(failure.errMessage), (data) {
      _searchPage = nextPage;
      searchResults = [...searchResults, ...data.results];
      searchHasMore = data.hasMore;
      searchResultsNotifier.value++;
    });
  }

  // ── Jump to a specific message from search ─────────────────────────────
  Future<void> jumpToMessage(int messageId) async {
    final current = state;
    if (current is! ChatLoaded) return;

    emit(current.copyWith(isLoadingMore: true));

    final result = await chatRepo.getMessageContext(
      eventId: eventId,
      messageId: messageId,
    );

    await result.fold(
      (failure) async {
        emit(current.copyWith(isLoadingMore: false));
        AppToast.error(failure.errMessage);
      },
      (context) async {
        final contextMessages = context.allMessages
            .map((e) => e.toUiModel(currentUserId: currentUserId))
            .toList();

        await ChatCacheService.cacheMessages(eventId, context.allMessages);

        emit(
          ChatLoaded(
            messages: contextMessages,
            page: 1,
            hasMore: context.hasMoreBefore || context.hasMoreAfter,
            isSyncing: false,
            highlightedMessageId: messageId,
          ),
        );
      },
    );
  }

  void clearHighlight() {
    final current = state;
    if (current is! ChatLoaded) return;
    emit(current.copyWith(clearHighlight: true));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _presenceSubscription?.cancel();
    _typingSendThrottle?.cancel();
    for (final t in _typingClearTimers.values) {
      t.cancel();
    }
    membersReadyNotifier.dispose(); // 👈 جديد
    _channel?.presence.leave();
    _channel?.detach();
    _realtime?.close();
    _audioPlayer.dispose();
    return super.close();
  }
}
