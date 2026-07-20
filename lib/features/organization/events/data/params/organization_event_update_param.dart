import 'dart:io';
import 'package:dio/dio.dart';

class OrganizationEventUpdateParam {
  final int id;

  final String? locationUrl;
  final String? locationCity;
  final String? locationState;
  final String? locationDescription;

  final String? status;

  final DateTime? date;

  final File? cover;

  final String? name;
  final String? description;
  final String? category;

  final List<String>? skills;

  final int? spots;

  OrganizationEventUpdateParam({
    required this.id,
    this.locationUrl,
    this.locationCity,
    this.locationState,
    this.locationDescription,
    this.status,
    this.date,
    this.cover,
    this.name,
    this.description,
    this.category,
    this.skills,
    this.spots,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      if (locationUrl != null) "location_url": locationUrl,

      if (locationCity != null) "location_city": locationCity,

      if (locationState != null) "location_state": locationState,

      if (locationDescription != null)
        "location_description": locationDescription,

      if (status != null) "status": status,

      if (date != null) "date": date!.toIso8601String(),

      if (name != null) "name": name,

      if (description != null) "description": description,

      if (category != null) "category": category,

      if (spots != null) "spots": spots,

      if (skills != null) "skills": skills,

      if (cover != null)
        "cover": await MultipartFile.fromFile(
          cover!.path,
          filename: cover!.path.split('/').last,
        ),
    });
  }
}
