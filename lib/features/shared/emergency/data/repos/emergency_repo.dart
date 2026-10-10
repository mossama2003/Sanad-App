import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sanad_app/core/network/end_points.dart';

import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../models/emergency_model.dart';
import '../params/emergency_param.dart';

part 'emergency_repo_impel.dart';

abstract class EmergencyRepo {
  Future<Either<Failure, EmergencyModel>> createEmergency(
      CreateEmergencyParam param,
      );

  Future<Either<Failure, List<EmergencyModel>>> getEmergencies({
    bool me = false,
  });

  Future<Either<Failure, EmergencyModel>> updateEmergency(
      int id,
      UpdateEmergencyParam param,
      );

  Future<Either<Failure, bool>> joinEmergency(int caseId);

  Future<Either<Failure, bool>> deleteEmergency(int id);
}