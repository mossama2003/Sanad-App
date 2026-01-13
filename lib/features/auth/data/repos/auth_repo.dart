import 'package:dartz/dartz.dart';

import '../../../../core/network/end_points.dart';
import '../../../../core/network/error/failures.dart';
import '../../../../core/network/local/cache/cache_helper.dart';
import '../../../../core/network/remote/api/dio_helper.dart';
import '../models/user_model.dart';
import '../params/complete_auth_param.dart';
import '../params/reset_param.dart';
import '../params/sign_in_param.dart';
import '../params/sign_up_param.dart';
import '../params/verification_param.dart';

part 'auth_repo_impel.dart';

abstract class AuthRepo {
  Future<Either<Failure, bool>> signUp(SignUpParam param);

  Future<Either<Failure, bool>> completeProfile(CompleteAuthParam param);

  Future<Either<Failure, bool>> verifyPhoneOtp(VerifyPhoneOtpParam param);

  Future<Either<Failure, bool>> signInPhone(SignInPhoneParam param);

  Future<Either<Failure, bool>> resetCheck(ResetCheckParam param);

  Future<Either<Failure, bool>> resetOtp(ResetOtpParam param);

  Future<Either<Failure, bool>> resetPassword(ResetPasswordParam param);

  Future<Either<Failure, UserModel>> getAuth();
}
