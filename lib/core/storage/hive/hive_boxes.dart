import 'package:hive/hive.dart';

import '../../../features/organization/events/data/models/organization_event_details_model.dart';
import '../../../features/organization/home/data/models/organization_home_model.dart';
import '../../../features/volunteer/events/data/models/volunteer_event_details_model.dart';

class HiveBoxes {
  static const String organizationEvents = 'organization_events_box';
  static const String volunteerEvents = 'volunteer_events_box';

  static const String volunteerHome = 'volunteer_home_box';
  static const String organizationHome = 'organization_home_box';

  static const String cacheInfo = 'cache_info_box';

  static Future<void> init() async {
    /// ORGANIZATION EVENTS
    await Hive.openBox<OrganizationEventDetailsModel>(organizationEvents);

    /// VOLUNTEER EVENTS
    await Hive.openBox<VolunteerEventDetailsModel>(volunteerEvents);

    /// VOLUNTEER HOME
    // await Hive.openBox<VolunteerHomeModel>(volunteerHome);

    /// ORGANIZATION HOME
    await Hive.openBox<OrganizationHomeModel>(organizationHome);

    /// OPEN CACHE INFO BOX
    await Hive.openBox(cacheInfo);
  }

  static Box<OrganizationEventDetailsModel> get organizationEventsBox {
    return Hive.box<OrganizationEventDetailsModel>(organizationEvents);
  }

  static Box<VolunteerEventDetailsModel> get volunteerEventsBox {
    return Hive.box<VolunteerEventDetailsModel>(volunteerEvents);
  }

  // static Box<VolunteerHomeModel> get volunteerHomeBox {
  //   return Hive.box<VolunteerHomeModel>(volunteerHome);
  // }

  static Box<OrganizationHomeModel> get organizationHomeBox {
    return Hive.box<OrganizationHomeModel>(organizationHome);
  }

  static Box get cacheInfoBox {
    return Hive.box(cacheInfo);
  }
}
