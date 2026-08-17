import 'package:hive/hive.dart';

import '../../../../../core/storage/hive/hive_boxes.dart';
import '../models/chat_model.dart';

class ChatCacheService {

  static Future<Box<EventChatDetailModel>> _openBox(int eventId) {
    return HiveBoxes.openEventChatBox(eventId);
  }

  static Future<List<EventChatDetailModel>> getCachedMessages(
    int eventId,
  ) async {
    final box = await _openBox(eventId);
    final list = box.values.toList()
      ..sort((a, b) => a.created.compareTo(b.created));
    return list;
  }

  static Future<void> cacheMessages(
    int eventId,
    List<EventChatDetailModel> messages,
  ) async {
    final box = await _openBox(eventId);
    await box.putAll({for (final m in messages) m.id: m});
  }

  static Future<void> cacheMessage(
    int eventId,
    EventChatDetailModel message,
  ) async {
    final box = await _openBox(eventId);
    await box.put(message.id, message);
  }

  static Future<void> updateCachedMessageText({
    required int eventId,
    required int messageId,
    required String newText,
    required DateTime modified,
  }) async {
    final box = await _openBox(eventId);
    final existing = box.get(messageId);
    if (existing == null) return;

    final updated = EventChatDetailModel(
      id: existing.id,
      creator: existing.creator,
      role: existing.role,
      created: existing.created,
      modified: modified,
      message: newText,
      isEdited: true,
    );

    await box.put(messageId, updated);
  }

  static Future<void> deleteCachedMessages(int eventId, List<int> ids) async {
    final box = await _openBox(eventId);
    await box.deleteAll(ids);
  }
}
