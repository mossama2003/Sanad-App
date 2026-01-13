import '../../../../core/network/local/cache/cache_helper.dart';

class SignInPhoneParam {
  final String phoneCode;
  final String phoneNumber;

  SignInPhoneParam({
    required this.phoneCode,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    final String? fcmToken = CacheHelper.get(CacheKeys.fcmToken);
    return {
      "phone_country_code": phoneCode,
      'phone': phoneNumber,
      if (fcmToken != null) "fcmToken": fcmToken,
    };
  }
}
