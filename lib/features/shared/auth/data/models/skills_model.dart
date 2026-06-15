class SkillsModel {
  final String label;
  final int value;

  SkillsModel({required this.label, required this.value});

  factory SkillsModel.fromJson(Map<String, dynamic> json) {
    return SkillsModel(label: json['label'] ?? '', value: json['value'] ?? 0);
  }
}

class SkillsResponse {
  final int maxPages;
  final int count;
  final String? next;
  final String? previous;
  final List<SkillsModel> results;

  SkillsResponse({
    required this.maxPages,
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory SkillsResponse.fromJson(Map<String, dynamic> json) {
    return SkillsResponse(
      maxPages: json['max_pages'] ?? 0,
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((e) => SkillsModel.fromJson(e))
          .toList(),
    );
  }
}
