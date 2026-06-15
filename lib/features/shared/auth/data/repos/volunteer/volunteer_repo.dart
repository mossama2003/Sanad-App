import 'package:sanad_app/core/network/end_points.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sanad_app/features/shared/auth/data/models/skills_model.dart';

import '../../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../../../core/network/error/failures.dart';
import '../../params/volunteer_sign_up_param.dart';

part 'volunteer_repo_impel.dart';

abstract class VolunteerRepo {
  Future<Either<Failure, bool>> volunteerSignUp(VolunteerParam param);

  Future<Either<Failure, List<SkillsModel>>> getVolunteerSkills();
}
