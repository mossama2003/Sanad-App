import 'package:dartz/dartz.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../models/xp_activity_model.dart';

import '../../../../../core/network/remote/api/dio_helper.dart';

part 'rewards_repo_impel.dart';

abstract class RewardsRepo {
  Future<Either<Failure, List<XpActivityModel>>> getXpActivities({
    required int volunteerId,
    int page = 1,
    int size = 10,
    String? ordering,
  });

  Future<Either<Failure, List<LeaderboardModel>>> getLeaderboard({
    int page = 1,
    int size = 10,
  });
}
