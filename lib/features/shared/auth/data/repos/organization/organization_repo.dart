import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/network/end_points.dart';
import '../../../../../../core/network/error/failures.dart';
import '../../../../../../core/network/remote/api/dio_helper.dart';
import '../../models/user_model.dart';
import '../../params/organization_sign_up_param.dart';

part 'organization_repo_impel.dart';

abstract class OrganizationRepo {
  Future<Either<Failure, bool>> signUpOrganization(OrganizationParam param);
}
