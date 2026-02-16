class ResetCheckParam {
  final String email;

  ResetCheckParam({required this.email});

  Map<String, dynamic> toJson() {
    return {"email": email};
  }
}

class ResetOtpParam {
  final String code;
  final String email;

  ResetOtpParam({required this.code, required this.email});

  Map<String, dynamic> toJson() {
    return {"code": code, "email": email};
  }
}

class ResetPasswordParam {
  final String code;
  final String email;
  final String password;
  final String passwordConfirmation;

  ResetPasswordParam({
    required this.code,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
  }
}
