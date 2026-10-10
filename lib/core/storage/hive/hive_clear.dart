import 'package:hive/hive.dart';

import '../../../features/shared/chat/data/models/chat_model.dart';
import 'hive_boxes.dart';

class HiveClear {
  static Future<void> clear() async {
    // ================= GENERAL CACHE =================

    await HiveBoxes.organizationEventsBox.clear();

    await HiveBoxes.volunteerEventsBox.clear();

    await HiveBoxes.volunteerCommunitiesBox.clear();

    await HiveBoxes.volunteerHomeBox.clear();

    await HiveBoxes.organizationHomeBox.clear();

    await HiveBoxes.cacheInfoBox.clear();

    // ================= EVENT CHAT =================

    for (final eventId in HiveBoxes.openedChatEventIds) {
      final boxName = HiveBoxes.eventChatBox(eventId);

      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box<EventChatDetailModel>(boxName);

        await box.clear();

        await box.close();
      }

      await Hive.deleteBoxFromDisk(boxName);
    }

    HiveBoxes.openedChatEventIds.clear();
  }
}
