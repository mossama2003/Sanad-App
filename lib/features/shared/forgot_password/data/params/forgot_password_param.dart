import 'package:dio/dio.dart';

class ForgotPasswordParam {
  final String email;

  const ForgotPasswordParam({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
    };
  }

  FormData toFormData() {
    return FormData.fromMap(toJson());
  }
}
