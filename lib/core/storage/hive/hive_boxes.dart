import 'package:hive/hive.dart';

import '../../../features/organization/events/data/models/organization_event_details_model.dart';

class HiveBoxes {
  static const String organizationEvents = 'organization_events_box';
  static const String cacheInfo = 'cache_info_box';

  static Future<void> init() async {
    /// OPEN ORGANIZATION EVENTS BOX
    await Hive.openBox<OrganizationEventDetailsModel>(organizationEvents);

    /// OPEN CACHE INFO BOX
    await Hive.openBox(cacheInfo);
  }

  static Box<OrganizationEventDetailsModel> get organizationEventsBox {
    return Hive.box<OrganizationEventDetailsModel>(organizationEvents);
  }

  static Box get cacheInfoBox {
    return Hive.box(cacheInfo);
  }
}
