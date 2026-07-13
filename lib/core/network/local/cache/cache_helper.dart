import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

part 'cache_keys.dart';

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  CacheHelper._();

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    if (get(CacheKeys.lang) == null) {
      save(CacheKeys.lang, CacheKeys.langAr);
    }

    if (get(CacheKeys.theme) == null) {
      save(CacheKeys.theme, CacheKeys.light);
    }

    if (get(CacheKeys.firstUse) == null) {
      save(CacheKeys.firstUse, true);
    }
  }

  static Future<bool> save(String key, dynamic value) async {
    switch (value.runtimeType) {
      case const (String):
        return await _sharedPreferences.setString(key, value);
      case const (int):
        return await _sharedPreferences.setInt(key, value);
      case const (bool):
        return await _sharedPreferences.setBool(key, value);
      case const (double):
        return await _sharedPreferences.setDouble(key, value);
      default:
        return false;
    }
  }

  static dynamic get(String key) {
    return _sharedPreferences.get(key);
  }

  static Future<bool> remove(String key) async {
    return await _sharedPreferences.remove(key);
  }

  static Future<void> removeList(List<String> keys) async {
    await Future.wait(keys.map((key) => _sharedPreferences.remove(key)));
  }

  static Future<bool> saveMap(Map<String, dynamic> data) async {
    try {
      await Future.wait(data.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;

        switch (value.runtimeType) {
          case const (String):
            return _sharedPreferences.setString(key, value);

          case const (int):
            return _sharedPreferences.setInt(key, value);

          case const (bool):
            return _sharedPreferences.setBool(key, value);

          case const (double):
            return _sharedPreferences.setDouble(key, value);

          default:
            return Future.value(false);
        }
      }));

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}


