import '../../../../../core/storage/hive/hive_boxes.dart';
import '../model/volunteer_communities_cache.dart';

class CommunityCacheService {
  static const String _cacheKey = 'communities';

  static Future<void> removeCommunity(int eventId) async {
    final box = HiveBoxes.volunteerCommunitiesBox;

    final cache = box.get(_cacheKey);

    if (cache == null) {
      return;
    }

    final updated = cache.communities
        .where((community) => community.id != eventId)
        .toList();

    await box.put(_cacheKey, VolunteerCommunitiesCache(communities: updated));
  }
}
