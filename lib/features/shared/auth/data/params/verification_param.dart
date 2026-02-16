import 'package:flutter_intl_phone_field/phone_number.dart';

class VerifyPhoneParam {
  final PhoneNumber phone;
  final Function() onSuccess;

  VerifyPhoneParam({
    required this.phone,
    required this.onSuccess,
  });
}

class VerifyPhoneOtpParam {
  final String code;
  final PhoneNumber phone;

  VerifyPhoneOtpParam({required this.code, required this.phone});

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "phone_country_code": phone.countryISOCode,
      "phone": phone.number,
    };
  }
}

class ResendPhoneOtpParam {
  final PhoneNumber phone;

  ResendPhoneOtpParam({required this.phone});

  Map<String, dynamic> toJson() {
    return {
      "phone_country_code": phone.countryISOCode,
      "phone": phone.number,
    };
  }
}
