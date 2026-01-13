class SignUpParam {
  final String phoneCode;
  final String phoneNumber;

  SignUpParam({
    required this.phoneCode,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "phone_country_code": phoneCode,
      'phone': phoneNumber,
    };
  }
}
