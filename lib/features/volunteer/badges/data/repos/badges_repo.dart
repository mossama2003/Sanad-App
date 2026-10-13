import 'package:dartz/dartz.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../models/badges_model.dart';

part 'badges_repo_impel.dart';

abstract class BadgesRepo {
  Future<Either<Failure, List<BadgeModel>>> getAllBadges({
    int page = 1,
    int size = 20,
    String? search,
    String? ordering,
  });
}
