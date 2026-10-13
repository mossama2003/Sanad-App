import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/badges_model.dart';
import '../../data/repos/badges_repo.dart';

part 'badges_state.dart';

class BadgesCubit extends Cubit<BadgesState> {
  BadgesCubit(this.repo) : super(Initial());

  final BadgesRepo repo;

  List<BadgeModel> badges = [];

  int totalCount = 0;
  int currentPage = 1;
  int pageSize = 20;

  String? searchQuery;
  String? ordering;

  List<BadgeModel> get earnedBadges =>
      badges.where((badge) => badge.isEarned).toList();

  List<BadgeModel> get lockedBadges =>
      badges.where((badge) => !badge.isEarned).toList();

  Future<void> getAllBadges({
    int page = 1,
    int size = 20,
    String? search,
    String? ordering,
  }) async {
    emit(Loading());

    currentPage = page;
    pageSize = size;
    searchQuery = search;
    this.ordering = ordering;

    final result = await repo.getAllBadges(
      page: page,
      size: size,
      search: search,
      ordering: ordering,
    );

    result.fold(
      (failure) {
        emit(Error(failure.errMessage));
      },
      (data) {
        badges = data;
        totalCount = data.length;

        emit(Success(badges));
      },
    );
  }

  Future<void> refreshBadges() async {
    await getAllBadges(
      page: 1,
      size: pageSize,
      search: searchQuery,
      ordering: ordering,
    );
  }
}
