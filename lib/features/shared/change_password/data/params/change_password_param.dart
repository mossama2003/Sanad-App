import 'package:dio/dio.dart';

class ChangePasswordParam {
  final String oldPassword;
  final String newPassword1;
  final String newPassword2;

  const ChangePasswordParam({
    required this.oldPassword,
    required this.newPassword1,
    required this.newPassword2,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password1': newPassword1,
      'new_password2': newPassword2,
    };
  }

  FormData toFormData() {
    return FormData.fromMap(toJson());
  }
}
