import 'cache_helper.dart';

class AuthCache {
  static const String _tokenKey = "access_token";

  static Future<void> saveToken(String token) async {
    await CacheHelper.save(_tokenKey, token);
  }

  static String? getToken() {
    return CacheHelper.get(_tokenKey);
  }

  static Future<void> clearToken() async {
    await CacheHelper.remove(_tokenKey);
  }
}