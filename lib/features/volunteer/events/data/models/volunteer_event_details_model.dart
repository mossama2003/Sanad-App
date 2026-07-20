import 'package:hive/hive.dart';

part 'volunteer_event_details_model.g.dart';

@HiveType(typeId: 2)
class VolunteerEventDetailsModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final Map<String, dynamic>? creator;

  @HiveField(2)
  final Map<String, dynamic>? location;

  @HiveField(3)
  final int joiners;

  @HiveField(4)
  final int attendees;

  @HiveField(5)
  final int spots;

  @HiveField(6)
  final bool joined;

  @HiveField(7)
  final double avgRating;

  @HiveField(8)
  final int unreadChatMessages;

  @HiveField(9)
  final Map<String, dynamic>? latestMessage;

  @HiveField(10)
  final String? cover;

  @HiveField(11)
  final String name;

  @HiveField(12)
  final String description;

  @HiveField(13)
  final String category;

  @HiveField(14)
  final DateTime date;

  @HiveField(15)
  final DateTime? due;

  @HiveField(16)
  final List<String> skills;

  @HiveField(17)
  final String status;

  @HiveField(18)
  final String? qr;

  @HiveField(19)
  final DateTime? created;

  @HiveField(20)
  final DateTime? modified;

  VolunteerEventDetailsModel({
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

  VolunteerEventDetailsModel copyWith({
    int? joiners,
    int? attendees,
    int? spots,
    bool? joined,
  }) {
    return VolunteerEventDetailsModel(
      id: id,
      creator: creator,
      location: location,
      joiners: joiners ?? this.joiners,
      attendees: attendees ?? this.attendees,
      spots: spots ?? this.spots,
      joined: joined ?? this.joined,
      avgRating: avgRating,
      unreadChatMessages: unreadChatMessages,
      latestMessage: latestMessage,
      cover: cover,
      name: name,
      description: description,
      category: category,
      date: date,
      due: due,
      skills: skills,
      status: status,
      qr: qr,
      created: created,
      modified: modified,
    );
  }

  factory VolunteerEventDetailsModel.fromJson(Map<String, dynamic> json) {
    return VolunteerEventDetailsModel(
      id: json['id'] ?? 0,

      creator: json['creator'] is Map
          ? Map<String, dynamic>.from(json['creator'])
          : null,

      location: json['location'] is Map
          ? Map<String, dynamic>.from(json['location'])
          : null,

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

      latestMessage: json['latest_message'] is Map
          ? Map<String, dynamic>.from(json['latest_message'])
          : null,

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
