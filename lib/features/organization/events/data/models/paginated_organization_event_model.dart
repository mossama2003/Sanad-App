import 'organization_event_details_model.dart';

class PaginatedOrganizationEventModel {
  final int count;

  final String? next;

  final String? previous;

  final List<OrganizationEventDetailsModel> results;

  PaginatedOrganizationEventModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedOrganizationEventModel.fromJson(Map<String, dynamic> json) {
    return PaginatedOrganizationEventModel(
      count: json['count'] ?? 0,

      next: json['next'],

      previous: json['previous'],

      results: (json['results'] as List? ?? [])
          .map((e) => OrganizationEventDetailsModel.fromJson(e))
          .toList(),
    );
  }
}
