import 'package:dartz/dartz.dart';
import 'package:sanad_app/core/network/end_points.dart';

import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../models/volunteer_home_model.dart';

part 'volunteer_home_repo_impel.dart';

abstract class VolunteerHomeRepo {
  Future<Either<Failure, VolunteerHomeModel>> getVolunteerHome();

  Future<Either<Failure, Unit>> joinEvent(int eventId);

  Future<Either<Failure, dynamic>> leaveEvent(int eventId);
}
