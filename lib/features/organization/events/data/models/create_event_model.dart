class CreateEventModel {
  final int id;
  final String status;
  final String locationUrl;
  final String locationCity;
  final String locationState;
  final String locationDescription;
  final String? cover;
  final String name;
  final String description;
  final String category;
  final DateTime date;
  final DateTime? created;
  final DateTime? modified;
  final DateTime? due;
  final List<String> skills;
  final int spots;
  final int? spotTotal;
  final String? qr;

  CreateEventModel({
    required this.id,
    required this.status,
    required this.locationUrl,
    required this.locationCity,
    required this.locationState,
    required this.locationDescription,
    this.cover,
    required this.name,
    required this.description,
    required this.category,
    required this.date,
    this.created,
    this.modified,
    this.due,
    required this.skills,
    required this.spots,
    this.spotTotal,
    this.qr,
  });

  factory CreateEventModel.fromJson(Map<String, dynamic> json) {
    return CreateEventModel(
      id: json['id'],
      status: json['status'],
      locationUrl: json['location_url'],
      locationCity: json['location_city'],
      locationState: json['location_state'],
      locationDescription: json['location_description'],
      cover: json['cover'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      modified: json['modified'] != null
          ? DateTime.parse(json['modified'])
          : null,
      due: json['due'] != null ? DateTime.parse(json['due']) : null,
      skills: List<String>.from(json['skills'] ?? []),
      spots: json['spots'],
      spotTotal: json['spot_total'],
      qr: json['qr'],
    );
  }
}
