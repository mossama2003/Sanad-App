import 'package:hive_flutter/hive_flutter.dart';

import 'hive_adapters.dart';
import 'hive_boxes.dart';

class HiveInit {
  static Future<void> init() async {
    /// INITIALIZE HIVE
    await Hive.initFlutter();

    /// REGISTER HIVE ADAPTERS
    HiveAdapters.register();

    /// OPEN HIVE BOXES
    await HiveBoxes.init();
  }
}
