import 'package:dio/dio.dart';

class ResetPasswordConfirmParam {
  final String otp;
  final String newPassword;
  final String reNewPassword;

  const ResetPasswordConfirmParam({
    required this.otp,
    required this.newPassword,
    required this.reNewPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'otp': otp.trim(),
      'new_password': newPassword,
      're_new_password': reNewPassword,
    };
  }

  FormData toFormData() {
    return FormData.fromMap(toJson());
  }
}
