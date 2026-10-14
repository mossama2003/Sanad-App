import 'package:easy_localization/easy_localization.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/end_points.dart';
import '../params/forgot_password_param.dart';
import '../params/reset_password_confirm_param.dart';

part 'forgot_password_repo_impel.dart';

abstract class ForgotPasswordRepo {
  Future<Either<Failure, String>> requestPasswordReset(
    ForgotPasswordParam param,
  );

  Future<Either<Failure, String>> confirmPasswordReset(
    ResetPasswordConfirmParam param,
  );
}
