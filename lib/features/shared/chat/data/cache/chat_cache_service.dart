import '../../../../../core/storage/hive/hive_boxes.dart';
import '../models/chat_model.dart';

class ChatCacheService {
  static Future<List<EventChatDetailModel>> getCachedMessages(
    int eventId,
  ) async {
    final box = await HiveBoxes.openEventChatBox(eventId);
    final list = box.values.toList()
      ..sort((a, b) => a.created.compareTo(b.created));
    return list;
  }

  static Future<void> cacheMessages(
    int eventId,
    List<EventChatDetailModel> messages,
  ) async {
    final box = await HiveBoxes.openEventChatBox(eventId);
    await box.putAll({for (final m in messages) m.id: m});
  }

  static Future<void> cacheMessage(
    int eventId,
    EventChatDetailModel message,
  ) async {
    final box = await HiveBoxes.openEventChatBox(eventId);
    await box.put(message.id, message);
  }
}
