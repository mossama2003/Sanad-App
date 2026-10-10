import 'package:hive/hive.dart';

import '../../../events/data/models/volunteer_event_details_model.dart';

part 'volunteer_home_model.g.dart';

@HiveType(typeId: 3)
class VolunteerHomeModel extends HiveObject {
  @HiveField(0)
  final int xp;

  @HiveField(1)
  final int streak;

  @HiveField(2)
  final int badgeCount;

  @HiveField(3)
  final List<VolunteerEventDetailsModel> activeEvents;

  VolunteerHomeModel({
    required this.xp,
    required this.streak,
    required this.badgeCount,
    required this.activeEvents,
  });

  factory VolunteerHomeModel.fromJson(Map<String, dynamic> json) {
    return VolunteerHomeModel(
      xp: json['xp'] ?? 0,
      streak: json['streak'] ?? 0,
      badgeCount: json['badge_count'] ?? 0,
      activeEvents: (json['active_events'] as List<dynamic>? ?? [])
          .map((e) => VolunteerEventDetailsModel.fromJson(e))
          .toList(),
    );
  }
}
