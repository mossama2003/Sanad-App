import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
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

  ChatCubit({
    required this.chatRepo,
    required this.eventId,
    required this.currentUserId,
  }) : super(ChatInitial());

  // ── Init: cache فورًا → توكن + history بالتوازي → Ably في الخلفية ─────
  Future<void> initChat() async {
    // 1) اعرض الكاش المحلي فورًا لو موجود
    final cached = await ChatCacheService.getCachedMessages(eventId);

    if (cached.isNotEmpty) {
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

    // 2) التوكن + الـ history بالتوازي بدل التسلسل
    final results = await Future.wait([
      chatRepo.getChatToken(eventId),
      chatRepo.getChatHistory(eventId: eventId, page: 1),
    ]);

    final tokenResult = results[0] as Either<String, ChatTokenModel>;
    final historyResult = results[1] as Either<String, PaginatedEventChatModel>;

    // الرسايل الحقيقية أولوية أعلى
    await historyResult.fold(
      (error) async {
        if (cached.isEmpty) emit(ChatError(error));
        // لو فيه كاش ظاهر، سيبه زي ما هو وما توقفش اليوزر بـ error شاشة كاملة
      },
      (data) async {
        await ChatCacheService.cacheMessages(eventId, data.results);
        emit(
          ChatLoaded(
            messages: data.results
                .map((e) => e.toUiModel(currentUserId: currentUserId))
                .toList(),
            page: 1,
            hasMore: data.hasMore,
            isSyncing: false,
          ),
        );
      },
    );

    // 3) الاتصال بـ Ably مستقل تمامًا، بيحصل في الخلفية
    tokenResult.fold(
      (_) {}, // فشل التوكن = الريل تايم مش هيشتغل، بس التاريخ ظاهر أصلاً
      (token) => _connectToAbly(token),
    );
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
    await _channel!.attach();

    _messageSubscription = _channel!.subscribe().listen((message) {
      _onRealtimeMessage(message);
    });
  }

  void _onRealtimeMessage(ably.Message message) {
    final current = state;
    if (current is! ChatLoaded) return;

    final data = Map<String, dynamic>.from(message.data as Map);
    final chatMsg = EventChatDetailModel.fromJson(data);

    ChatCacheService.cacheMessage(eventId, chatMsg);

    emit(
      current.copyWith(
        messages: [
          ...current.messages,
          chatMsg.toUiModel(currentUserId: currentUserId),
        ],
      ),
    );
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

  // ── Send message (optimistic, via Ably publish) ────────────────────────
  Future<void> sendMessage(String text) async {
    final current = state;
    if (text.trim().isEmpty || current is! ChatLoaded || _channel == null) {
      return;
    }

    final optimisticMsg = ChatModel(
      senderName: 'You',
      text: text,
      time: DateFormat('h:mm a').format(DateTime.now()),
      createdAt: DateTime.now(),
      avatarColor: AppColors.primary,
      avatarLetter: 'Y',
    );

    emit(current.copyWith(messages: [...current.messages, optimisticMsg]));

    try {
      await _channel!.publish(name: 'message', data: {'message': text});
    } catch (_) {
      // TODO: تعليم الرسالة دي كـ failed في الـ UI + زرار retry
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _channel?.detach();
    _realtime?.close();
    return super.close();
  }
}
