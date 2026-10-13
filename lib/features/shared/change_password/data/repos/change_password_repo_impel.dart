part of 'change_password_repo.dart';

class ChangePasswordRepoImpel implements ChangePasswordRepo {
  @override
  Future<Either<Failure, String>> changePassword(
    ChangePasswordParam param,
  ) async {
    try {
      final response = await DioHelper.post(
        url: CHANGE_PASSWORD,
        data: param.toFormData(),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final String detail;
        if (data is Map && data['detail'] != null) {
          detail = data['detail'].toString();
        } else {
          detail = 'shared.change_password.success'.tr();
        }

        return right(detail);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}
