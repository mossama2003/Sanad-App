import 'package:hive/hive.dart';

import '../../../features/organization/events/data/models/organization_event_details_model.dart';
import '../../../features/volunteer/events/data/models/volunteer_event_details_model.dart';

class HiveAdapters {
  static void register() {
    /// ORGANIZATION EVENTS ADAPTER
    Hive.registerAdapter(OrganizationEventDetailsModelAdapter());

    /// VOLUNTEER EVENTS ADAPTER
    Hive.registerAdapter(VolunteerEventDetailsModelAdapter());
  }
}
