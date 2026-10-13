part of 'rewards_cubit.dart';

abstract class RewardsState {}

class Initial extends RewardsState {}

class Loading extends RewardsState {}

class Error extends RewardsState {
  final String errMessage;

  Error(this.errMessage);
}

class Success extends RewardsState {
  final List<XpActivityModel> activities;
  final List<LeaderboardModel> leaderboard;
  final String? activitiesError;
  final String? leaderboardError;

  Success({
    required this.activities,
    required this.leaderboard,
    this.activitiesError,
    this.leaderboardError,
  });
}
