import 'package:hive/hive.dart';

import '../../../features/organization/events/data/models/organization_event_details_model.dart';
import '../../../features/organization/home/data/models/organization_home_model.dart';
import '../../../features/volunteer/events/data/models/volunteer_event_details_model.dart';
import '../../../features/volunteer/home/data/models/volunteer_home_model.dart';

class HiveAdapters {
  static void register() {
    /// ORGANIZATION EVENTS ADAPTER
    Hive.registerAdapter(OrganizationEventDetailsModelAdapter());

    /// VOLUNTEER EVENTS ADAPTER
    Hive.registerAdapter(VolunteerEventDetailsModelAdapter());

    /// VOLUNTEER HOME ADAPTER
    Hive.registerAdapter(VolunteerHomeModelAdapter());

    /// ORGANIZATION HOME ADAPTER
    Hive.registerAdapter(OrganizationHomeModelAdapter());
  }
}
