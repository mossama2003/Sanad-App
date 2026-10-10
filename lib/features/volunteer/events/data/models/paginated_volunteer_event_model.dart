import 'volunteer_event_details_model.dart';

class PaginatedVolunteerEventModel {
  final int count;

  final String? next;

  final String? previous;

  final List<VolunteerEventDetailsModel> results;

  PaginatedVolunteerEventModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedVolunteerEventModel.fromJson(Map<String, dynamic> json) {
    return PaginatedVolunteerEventModel(
      count: json['count'] ?? 0,

      next: json['next'],

      previous: json['previous'],

      results: (json['results'] as List? ?? [])
          .map((e) => VolunteerEventDetailsModel.fromJson(e))
          .toList(),
    );
  }
}
