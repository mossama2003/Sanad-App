import 'package:sanad_app/features/shared/auth/data/params/sign_in_param.dart';
import 'package:sanad_app/core/network/end_points.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/network/local/cache/auth_cache.dart';
import '../../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../../../core/network/error/failures.dart';
import '../../models/auth_response_model.dart';

part 'sign_in_repo_impel.dart';

abstract class SignInRepo {
  Future<Either<Failure, AuthResponseModel>> signIn(SignInParam param);
}
