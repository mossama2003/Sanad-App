import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

part 'hive_keys.dart';

class HiveService {
  HiveService._();

  static final HiveService _instance = HiveService._();

  static HiveService get instance => _instance;

  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(HiveKeys.appBox);
  }

  Future<void> save<T>(String key, T value) async {
    await _box.put(key, value);
  }

  T get<T>(String key, {T? defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }

  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  Future<void> clearBox() async {
    await _box.clear();
  }
}
