class FAQModel {
  final int id;
  final DateTime? created;
  final DateTime? modified;
  final String question;
  final String answer;
  final bool active;

  FAQModel({
    required this.id,
    this.created,
    this.modified,
    required this.question,
    required this.answer,
    required this.active,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(
      id: json['id'] ?? 0,
      created: json['created'] != null
          ? DateTime.tryParse(
        json['created'].toString(),
      )
          : null,
      modified: json['modified'] != null
          ? DateTime.tryParse(
        json['modified'].toString(),
      )
          : null,
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      active: json['active'] ?? true,
    );
  }
}

class FaqPaginationModel {
  final int maxPages;
  final int count;
  final String? next;
  final String? previous;
  final List<FAQModel> results;

  FaqPaginationModel({
    required this.maxPages,
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory FaqPaginationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return FaqPaginationModel(
      maxPages: json['max_pages'] ?? 1,
      count: json['count'] ?? 0,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: (json['results'] as List? ?? [])
          .map(
            (e) => FAQModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .where((faq) => faq.active)
          .toList(),
    );
  }
}