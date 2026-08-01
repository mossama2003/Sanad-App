import 'package:hive/hive.dart';

import '../../../features/organization/events/data/models/organization_event_details_model.dart';
import '../../../features/organization/home/data/models/organization_home_model.dart';
import '../../../features/shared/chat/data/models/chat_model.dart';
import '../../../features/volunteer/community/data/model/volunteer_communities_cache.dart';
import '../../../features/volunteer/events/data/models/volunteer_event_details_model.dart';
import '../../../features/volunteer/home/data/models/volunteer_home_model.dart';

class HiveBoxes {
  static const String organizationEvents = 'organization_events_box';

  static const String volunteerEvents = 'volunteer_events_box';

  static const String volunteerCommunities = 'volunteer_communities_box';

  static const String volunteerHome = 'volunteer_home_box';

  static const String organizationHome = 'organization_home_box';

  static const String cacheInfo = 'cache_info_box';


  // ================= EVENT CHAT =================

  static String eventChatBox(int eventId) =>
      'chat_messages_${eventId}_box';


  // نخزن الـ IDs اللي اتفتح لها Chat Box
  static final Set<int> openedChatEventIds = {};


  static Future<void> init() async {
    await Hive.openBox<OrganizationEventDetailsModel>(
      organizationEvents,
    );

    await Hive.openBox<VolunteerEventDetailsModel>(
      volunteerEvents,
    );

    await Hive.openBox<VolunteerCommunitiesCache>(
      volunteerCommunities,
    );

    await Hive.openBox<VolunteerHomeModel>(
      volunteerHome,
    );

    await Hive.openBox<OrganizationHomeModel>(
      organizationHome,
    );

    await Hive.openBox(cacheInfo);
  }


  static Box<OrganizationEventDetailsModel> get organizationEventsBox =>
      Hive.box<OrganizationEventDetailsModel>(organizationEvents);


  static Box<VolunteerEventDetailsModel> get volunteerEventsBox =>
      Hive.box<VolunteerEventDetailsModel>(volunteerEvents);


  static Box<VolunteerCommunitiesCache> get volunteerCommunitiesBox =>
      Hive.box<VolunteerCommunitiesCache>(volunteerCommunities);


  static Box<VolunteerHomeModel> get volunteerHomeBox =>
      Hive.box<VolunteerHomeModel>(volunteerHome);


  static Box<OrganizationHomeModel> get organizationHomeBox =>
      Hive.box<OrganizationHomeModel>(organizationHome);


  static Box get cacheInfoBox =>
      Hive.box(cacheInfo);


  static Future<Box<EventChatDetailModel>> openEventChatBox(
      int eventId,
      ) async {
    openedChatEventIds.add(eventId);

    return Hive.openBox<EventChatDetailModel>(
      eventChatBox(eventId),
    );
  }
}
