class EventReportModel {
  final int id;
  final int event;
  final DateTime created;
  final DateTime modified;
  final String? reason;

  EventReportModel({
    required this.id,
    required this.event,
    required this.created,
    required this.modified,
    this.reason,
  });

  factory EventReportModel.fromJson(Map<String, dynamic> json) {
    return EventReportModel(
      id: json['id'] ?? 0,
      event: json['event'] ?? 0,
      created: DateTime.tryParse(json['created'] ?? '') ?? DateTime.now(),
      modified: DateTime.tryParse(json['modified'] ?? '') ?? DateTime.now(),
      reason: json['reason'],
    );
  }
}