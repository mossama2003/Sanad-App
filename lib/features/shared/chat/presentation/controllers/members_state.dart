part of 'members_cubit.dart';

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
  final int totalCount;

  const MembersLoaded({
    required this.members,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
    this.searchQuery = '',
    required this.totalCount,
  });

  MembersLoaded copyWith({
    List<MemberModel>? members,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? searchQuery,
    int? totalCount,
  }) {
    return MembersLoaded(
      members: members ?? this.members,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      totalCount: totalCount ?? this.totalCount,
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
    totalCount,
  ];
}
