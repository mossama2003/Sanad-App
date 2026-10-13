import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/xp_activity_model.dart';
import '../../data/repos/rewards_repo.dart';

part 'rewards_state.dart';

class RewardsCubit extends Cubit<RewardsState> {
  RewardsCubit(this.repo) : super(Initial());

  final RewardsRepo repo;

  static RewardsCubit get(BuildContext context) =>
      BlocProvider.of<RewardsCubit>(context);

  List<XpActivityModel> activities = [];
  List<LeaderboardModel> leaderboard = [];

  String? activitiesError;
  String? leaderboardError;

  Future<void> getRewards({
    required int volunteerId,
    int page = 1,
    int size = 10,
  }) async {
    emit(Loading());

    final activitiesResult = await repo.getXpActivities(
      volunteerId: volunteerId,
      page: page,
      size: size,
    );

    final leaderboardResult = await repo.getLeaderboard(page: 1, size: 10);

    activitiesError = null;
    leaderboardError = null;

    activitiesResult.fold(
      (failure) => activitiesError = failure.errMessage,
      (data) => activities = data,
    );

    leaderboardResult.fold(
      (failure) => leaderboardError = failure.errMessage,
      (data) => leaderboard = data,
    );

    if (activitiesError != null && leaderboardError != null) {
      emit(Error(activitiesError!));
      return;
    }

    emit(
      Success(
        activities: activities,
        leaderboard: leaderboard,
        activitiesError: activitiesError,
        leaderboardError: leaderboardError,
      ),
    );
  }

  Future<void> refreshRewards({required int volunteerId}) async {
    await getRewards(volunteerId: volunteerId);
  }
}
