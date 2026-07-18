import 'package:hive/hive.dart';

import '../../../features/organization/events/data/models/organization_event_details_model.dart';
import '../../../features/volunteer/events/data/models/volunteer_event_details_model.dart';

class HiveBoxes {
  static const String organizationEvents = 'organization_events_box';
  static const String volunteerEvents = 'volunteer_events_box';

  static const String cacheInfo = 'cache_info_box';

  static Future<void> init() async {
    /// ORGANIZATION EVENTS
    await Hive.openBox<OrganizationEventDetailsModel>(organizationEvents);

    /// VOLUNTEER EVENTS
    await Hive.openBox<VolunteerEventDetailsModel>(volunteerEvents);

    /// OPEN CACHE INFO BOX
    await Hive.openBox(cacheInfo);
  }

  static Box<OrganizationEventDetailsModel> get organizationEventsBox {
    return Hive.box<OrganizationEventDetailsModel>(organizationEvents);
  }

  static Box<VolunteerEventDetailsModel> get volunteerEventsBox {
    return Hive.box<VolunteerEventDetailsModel>(volunteerEvents);
  }

  static Box get cacheInfoBox {
    return Hive.box(cacheInfo);
  }
}
