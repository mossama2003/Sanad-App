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

      return left(_parseDjangoError(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  ServerFailure _parseDjangoError(Response response) {
    final data = response.data;
    if (data is Map) {
      final List<String> errorMessages = [];

      // Check top-level 'detail'
      if (data['detail'] != null &&
          data['detail'].toString().trim().isNotEmpty) {
        errorMessages.add(data['detail'].toString().trim());
      }

      // Check Django field-specific error dictionaries
      const priorityKeys = [
        'old_password',
        'new_password1',
        'new_password2',
        'non_field_errors',
        'error',
        'message',
      ];

      for (final key in priorityKeys) {
        if (data[key] != null) {
          final value = data[key];
          if (value is List && value.isNotEmpty) {
            for (final item in value) {
              if (item != null && item.toString().trim().isNotEmpty) {
                errorMessages.add(item.toString().trim());
              }
            }
          } else if (value is String && value.trim().isNotEmpty) {
            errorMessages.add(value.trim());
          }
        }
      }

      if (errorMessages.isNotEmpty) {
        final uniqueErrors = errorMessages.toSet().toList();
        return ServerFailure(uniqueErrors.join('\n'));
      }
    }

    return ServerFailure.fromResponse(response);
  }
}
