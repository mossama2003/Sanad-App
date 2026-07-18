class OrganizationEventDetailsModel {
  final int id;
  final dynamic creator;
  final dynamic location;

  final int joiners;
  final int attendees;

  final int spots;
  final bool joined;
  final double avgRating;
  final int unreadChatMessages;
  final dynamic latestMessage;

  final String? cover;
  final String name;
  final String description;
  final String category;

  final DateTime date;
  final DateTime? due;

  final List<String> skills;

  final String status;
  final String? qr;

  final DateTime? created;
  final DateTime? modified;

  OrganizationEventDetailsModel({
    required this.id,
    this.creator,
    this.location,
    required this.joiners,
    required this.attendees,
    required this.spots,
    required this.joined,
    required this.avgRating,
    required this.unreadChatMessages,
    this.latestMessage,
    this.cover,
    required this.name,
    required this.description,
    required this.category,
    required this.date,
    this.due,
    required this.skills,
    required this.status,
    this.qr,
    this.created,
    this.modified,
  });

  factory OrganizationEventDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrganizationEventDetailsModel(
      id: json['id'] ?? 0,
      creator: json['creator'],
      location: json['location'],

      joiners: json['joiners'] is int
          ? json['joiners']
          : (json['joiners'] as List?)?.length ?? 0,

      attendees: json['attendees'] is int
          ? json['attendees']
          : (json['attendees'] as List?)?.length ?? 0,

      spots: json['spots'] ?? 0,
      joined: json['joined'] ?? false,
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      unreadChatMessages: json['unread_chat_messages'] ?? 0,
      latestMessage: json['latest_message'],
      cover: json['cover'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      date: DateTime.parse(json['date']),
      due: json['due'] != null ? DateTime.parse(json['due']) : null,
      skills: List<String>.from(json['skills'] ?? []),
      status: json['status'] ?? '',
      qr: json['qr'],
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      modified: json['modified'] != null
          ? DateTime.parse(json['modified'])
          : null,
    );
  }
}
