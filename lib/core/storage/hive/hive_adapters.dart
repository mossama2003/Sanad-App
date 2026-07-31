import 'package:hive/hive.dart';

import '../../../features/organization/events/data/models/organization_event_details_model.dart';
import '../../../features/organization/home/data/models/organization_home_model.dart';
import '../../../features/shared/chat/data/models/chat_model.dart';
import '../../../features/volunteer/community/data/model/volunteer_communities_cache.dart';
import '../../../features/volunteer/events/data/models/volunteer_event_details_model.dart';
import '../../../features/volunteer/home/data/models/volunteer_home_model.dart';

class HiveAdapters {
  static void register() {
    /// ORGANIZATION EVENTS
    Hive.registerAdapter(OrganizationEventDetailsModelAdapter());

    /// VOLUNTEER EVENTS
    Hive.registerAdapter(VolunteerEventDetailsModelAdapter());

    /// VOLUNTEER HOME
    Hive.registerAdapter(VolunteerHomeModelAdapter());

    /// ORGANIZATION HOME
    Hive.registerAdapter(OrganizationHomeModelAdapter());

    /// VOLUNTEER COMMUNITIES CACHE
    Hive.registerAdapter(VolunteerCommunitiesCacheAdapter());

    /// EVENT CHAT
    Hive.registerAdapter(EventChatCreatorModelAdapter());
    Hive.registerAdapter(EventChatDetailModelAdapter());
  }
}
