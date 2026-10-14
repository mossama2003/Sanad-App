part of 'forgot_password_repo.dart';

class ForgotPasswordRepoImpel implements ForgotPasswordRepo {
  @override
  Future<Either<Failure, String>> requestPasswordReset(
    ForgotPasswordParam param,
  ) async {
    try {
      final response = await DioHelper.post(
        url: PASSWORD_RESET,
        data: param.toFormData(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final String detail;
        if (data is Map && data['detail'] != null) {
          detail = data['detail'].toString();
        } else if (data is Map && data['message'] != null) {
          detail = data['message'].toString();
        } else {
          detail = 'shared.forgot_password.otp_sent_success'.tr();
        }
        return right(detail);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, String>> confirmPasswordReset(
    ResetPasswordConfirmParam param,
  ) async {
    try {
      final response = await DioHelper.post(
        url: PASSWORD_RESET_CONFIRM,
        data: param.toFormData(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final String detail;
        if (data is Map && data['detail'] != null) {
          detail = data['detail'].toString();
        } else if (data is Map && data['message'] != null) {
          detail = data['message'].toString();
        } else {
          detail = 'shared.forgot_password.reset_success'.tr();
        }
        return right(detail);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}
