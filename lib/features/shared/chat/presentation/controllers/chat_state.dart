part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatModel> messages;
  final int page;
  final bool hasMore;
  final bool isSyncing;
  final bool isLoadingMore;
  final bool isSelectionMode;
  final Set<int> selectedMessageIds;
  final int onlineCount;
  final int totalMembersCount;

  const ChatLoaded({
    required this.messages,
    required this.page,
    required this.hasMore,
    this.isSyncing = false,
    this.isLoadingMore = false,
    this.isSelectionMode = false,
    this.selectedMessageIds = const {},
    this.onlineCount = 0,
    this.totalMembersCount = 0,
  });

  ChatLoaded copyWith({
    List<ChatModel>? messages,
    int? page,
    bool? hasMore,
    bool? isSyncing,
    bool? isLoadingMore,
    bool? isSelectionMode,
    Set<int>? selectedMessageIds,
    int? onlineCount,
    int? totalMembersCount,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isSyncing: isSyncing ?? this.isSyncing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedMessageIds: selectedMessageIds ?? this.selectedMessageIds,
      onlineCount: onlineCount ?? this.onlineCount,
      totalMembersCount: totalMembersCount ?? this.totalMembersCount,
    );
  }
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

abstract class MembersState extends Equatable {
  const MembersState();

  @override
  List<Object?> get props => [];
}

class MembersInitial extends MembersState {}

class MembersLoading extends MembersState {}

class MembersError extends MembersState {
  final String message;

  const MembersError(this.message);

  @override
  List<Object?> get props => [message];
}

class MembersLoaded extends MembersState {
  final List<MemberModel> members;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String searchQuery;

  const MembersLoaded({
    required this.members,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
    this.searchQuery = '',
  });

  MembersLoaded copyWith({
    List<MemberModel>? members,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? searchQuery,
  }) {
    return MembersLoaded(
      members: members ?? this.members,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<MemberModel> get admins =>
      members.where((m) => m.roleEnum == MemberRoleEnum.admin).toList();

  List<MemberModel> get organizers =>
      members.where((m) => m.roleEnum == MemberRoleEnum.organizer).toList();

  List<MemberModel> get volunteers =>
      members.where((m) => m.roleEnum == MemberRoleEnum.volunteer).toList();

  @override
  List<Object?> get props => [
    members,
    page,
    hasMore,
    isLoadingMore,
    searchQuery,
  ];
}
