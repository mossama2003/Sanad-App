import 'package:hive/hive.dart';

import '../../../events/data/models/organization_event_details_model.dart';

part 'organization_home_model.g.dart';

@HiveType(typeId: 4)
class OrganizationHomeModel extends HiveObject {
  @HiveField(0)
  final int activeEventsCount;

  @HiveField(1)
  final int completedEventsCount;

  @HiveField(2)
  final int attendanceCount;

  @HiveField(3)
  final List<OrganizationEventDetailsModel> activeEvents;

  @HiveField(4)
  final List<OrganizationEventDetailsModel> recentCompletedEvents;

  @HiveField(5)
  final String? organizationName;

  OrganizationHomeModel({
    required this.activeEventsCount,
    required this.completedEventsCount,
    required this.attendanceCount,
    required this.activeEvents,
    required this.recentCompletedEvents,
    this.organizationName,
  });


  OrganizationHomeModel copyWith({
    int? activeEventsCount,
    int? completedEventsCount,
    int? attendanceCount,
    List<OrganizationEventDetailsModel>? activeEvents,
    List<OrganizationEventDetailsModel>? recentCompletedEvents,
    String? organizationName,
  }) {
    return OrganizationHomeModel(
      activeEventsCount:
      activeEventsCount ?? this.activeEventsCount,

      completedEventsCount:
      completedEventsCount ?? this.completedEventsCount,

      attendanceCount:
      attendanceCount ?? this.attendanceCount,

      activeEvents:
      activeEvents ?? this.activeEvents,

      recentCompletedEvents:
      recentCompletedEvents ?? this.recentCompletedEvents,

      organizationName:
      organizationName ?? this.organizationName,
    );
  }


  factory OrganizationHomeModel.fromJson(
      Map<String, dynamic> json,
      ) {

    final activeEvents =
    (json['active_events'] as List<dynamic>? ?? [])
        .map(
          (e) => OrganizationEventDetailsModel.fromJson(e),
    )
        .toList();


    final recentCompletedEvents =
    (json['recent_completed_events'] as List<dynamic>? ?? [])
        .map(
          (e) => OrganizationEventDetailsModel.fromJson(e),
    )
        .toList();


    String? organizationName;


    if (activeEvents.isNotEmpty) {
      organizationName =
      activeEvents.first.creator?['name'];
    }
    else if (recentCompletedEvents.isNotEmpty) {
      organizationName =
      recentCompletedEvents.first.creator?['name'];
    }


    return OrganizationHomeModel(
      activeEventsCount:
      json['active_events_count'] ?? 0,

      completedEventsCount:
      json['completed_events_count'] ?? 0,

      attendanceCount:
      json['attendance_count'] ?? 0,

      activeEvents:
      activeEvents,

      recentCompletedEvents:
      recentCompletedEvents,

      organizationName:
      organizationName,
    );
  }
}
