import 'dart:io';

class CreateOrganizationEventParam {
  final String name;
  final String description;
  final String category;
  final String locationUrl;
  final String locationCity;
  final String locationState;
  final String locationDescription;
  final DateTime date;
  final List<String> skills;
  final int spots;
  final String status;
  final File? cover;

  CreateOrganizationEventParam({
    required this.name,
    required this.description,
    required this.category,
    required this.locationUrl,
    required this.locationCity,
    required this.locationState,
    required this.locationDescription,
    required this.date,
    required this.skills,
    required this.spots,
    required this.status,
    this.cover,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "category": category,
      "location_url": locationUrl,
      "location_city": locationCity,
      "location_state": locationState,
      "location_description": locationDescription,
      "date": date.toIso8601String(),
      "skills": skills,
      "spots": spots,
      "status": status,
    };
  }
}
