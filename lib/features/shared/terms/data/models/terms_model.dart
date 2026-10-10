class TermsModel {
  final int id;
  final DateTime? created;
  final DateTime? modified;
  final String title;
  final String description;
  final String termType;
  final bool active;

  const TermsModel({
    required this.id,
    this.created,
    this.modified,
    required this.title,
    required this.description,
    required this.termType,
    required this.active,
  });

  factory TermsModel.fromJson(Map<String, dynamic> json) {
    return TermsModel(
      id: json['id'] as int,
      created: DateTime.tryParse(json['created']?.toString() ?? ''),
      modified: DateTime.tryParse(json['modified']?.toString() ?? ''),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      termType: json['term_type']?.toString() ?? 'general',
      active: json['active'] == true,
    );
  }
}

class TermsResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<TermsModel> results;

  const TermsResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory TermsResponseModel.fromJson(Map<String, dynamic> json) {
    return TermsResponseModel(
      count: json['count'] as int? ?? 0,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: (json['results'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(TermsModel.fromJson)
          .toList(),
    );
  }
}
