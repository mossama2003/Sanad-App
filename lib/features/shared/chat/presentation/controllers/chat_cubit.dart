import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/cache/chat_cache_service.dart';
import '../../data/models/chat_model.dart';
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

  final AudioPlayer _audioPlayer = AudioPlayer();

  ChatCubit({
    required this.chatRepo,
    required this.eventId,
    required this.currentUserId,
  }) : super(ChatInitial());

  Future<void> initChat() async {
    // 1) Load local cache first
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

    // 2) Get token + history parallel
    final results = await Future.wait([
      chatRepo.getChatToken(eventId),
      chatRepo.getChatHistory(eventId: eventId, page: 1),
    ]);

    final tokenResult = results[0] as Either<String, ChatTokenModel>;

    final historyResult = results[1] as Either<String, PaginatedEventChatModel>;

    // 3) Update from server
    await historyResult.fold(
      (error) async {
        if (!hasCache) {
          emit(ChatError(error));
        } else {
          final current = state;

          if (current is ChatLoaded) {
            emit(current.copyWith(isSyncing: false));
          }
        }
      },

      (data) async {
        await ChatCacheService.cacheMessages(eventId, data.results);

        final serverMessages = data.results
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
            ),
          );
        } else {
          emit(
            ChatLoaded(
              messages: serverMessages,
              page: 1,
              hasMore: data.hasMore,
              isSyncing: false,
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

    _messageSubscription = _channel!.subscribe().listen((message) {
      debugPrint('📩 Realtime message received: ${message.data}');
      _onRealtimeMessage(message);
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
      debugPrint('🔊 sound played: $assetPath');
    } catch (e) {
      debugPrint('🔇 sound error: $e');
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

    if (alreadyExists) {
      return;
    }

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
      (error) {
        emit(current.copyWith(isLoadingMore: false));
        AppToast.error(error);
      },
      (data) async {
        await ChatCacheService.cacheMessages(eventId, data.results);

        final olderMessages = data.results
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

    result.fold((error) {
      _updateMessageStatus(localId, ChatMessageStatus.failed);
      AppToast.error(error);
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

    result.fold((error) {
      _updateMessageStatus(localId, ChatMessageStatus.failed);
      AppToast.error(error);
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

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _channel?.detach();
    _realtime?.close();
    _audioPlayer.dispose();
    return super.close();
  }
}
