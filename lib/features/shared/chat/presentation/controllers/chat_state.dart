part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatModel> messages;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isSyncing; // true = البيانات لسه من الكاش وبتتحدث فعليًا

  ChatLoaded({
    required this.messages,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
    this.isSyncing = false,
  });

  ChatLoaded copyWith({
    List<ChatModel>? messages,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isSyncing,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
