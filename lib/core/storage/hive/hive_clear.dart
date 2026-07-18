import 'hive_boxes.dart';

class HiveClear {
  static Future<void> clear() async {
    await HiveBoxes.organizationEventsBox.clear();

    await HiveBoxes.cacheInfoBox.clear();
  }
}