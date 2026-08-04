import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/cache/chat_cache_service.dart';
import '../../data/enums/member_role_enum.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/members_model.dart';
import '../../data/repos/chat_repo.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  final int eventId;
  final int currentUserId;

  ably.Realtime? _realtime;
  ably.RealtimeChannel? _channel;
  StreamSubscription<ably.Message>? _messageSubscription;
  StreamSubscription<ably.PresenceMessage>? _presenceSubscription;

  final AudioPlayer _audioPlayer = AudioPlayer();

  ChatCubit({
    required this.chatRepo,
    required this.eventId,
    required this.currentUserId,
  }) : super(ChatInitial());

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
    final membersResult = results[2] as Either<Failure, PaginatedMembersModel>;

    // final totalMembersCount = membersResult.fold(
    //   (_) => 0,
    //   (data) => data.count,
    // );

    final totalMembersCount = membersResult.fold(
          (failure) {
        debugPrint('⚠️ getEventMembers FAILED: ${failure.errMessage}'); // 👈 جديد
        return 0;
      },
          (data) {
        debugPrint('✅ getEventMembers SUCCESS: count = ${data.count}'); // 👈 جديد
        return data.count;
      },
    );

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
            ),
          );
        }
      },
    );

    tokenResult.fold((_) {}, (token) {
      _connectToAbly(token);
    });
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

    try {
      await _channel!.presence.enter();
      await _updateOnlineCount();
    } catch (e) {
      debugPrint('⚠️ Failed to enter presence: $e');
    }

    _presenceSubscription = _channel!.presence.subscribe().listen((_) {
      _updateOnlineCount();
    });

    _messageSubscription = _channel!.subscribe().listen((message) {
      debugPrint('📩 Realtime message received: ${message.data}');
      _onRealtimeMessage(message);
    });
  }

  Future<void> _updateOnlineCount() async {
    if (_channel == null) return;

    try {
      final members = await _channel!.presence.get();

      debugPrint("Presence members: ${members.length}");

      final current = state;
      if (current is ChatLoaded) {
        final newState = current.copyWith(
          onlineCount: members.length,
        );

        debugPrint(
          "Emit -> online=${newState.onlineCount}, total=${newState.totalMembersCount}",
        );

        emit(newState);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
        // 👈 جديد - نفس منطق الـ merge
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

        await ChatCacheService.cacheMessages(eventId, mergedResults); // ✅

        final olderMessages =
            mergedResults // ✅
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
  Future<void> sendMessage(String text) async {
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
    );

    emit(current.copyWith(messages: [...current.messages, optimisticMsg]));

    _playSound('sounds/message_send.mp3');

    final result = await chatRepo.sendMessage(eventId: eventId, message: text);

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

    final text = current.messages[index].text;

    _updateMessageStatus(localId, ChatMessageStatus.sending);

    final result = await chatRepo.sendMessage(eventId: eventId, message: text);

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
        // 👈 جديد
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

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _presenceSubscription?.cancel();
    _channel?.presence.leave();
    _channel?.detach();
    _realtime?.close();
    _audioPlayer.dispose();
    return super.close();
  }
}
