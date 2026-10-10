int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is List) return value.length;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

class EmergencyModel {
  final int id;

  final EmergencyCreator? creator;
  final EmergencyLocation? location;

  final DateTime? created;
  final DateTime? modified;

  final String name;
  final String description;
  final String category;
  final String urgency;
  final String contactPhone;

  /// Required volunteers.
  final int volunteers;

  /// Volunteers who already joined.
  final int joiners;
  final bool joined;
  final bool active;

  final List<String> skills;
  final List<String> certifications;

  final dynamic info;
  final dynamic coordinates;

  final List<EmergencyAttachment> attachments;

  EmergencyModel({
    required this.id,
    this.creator,
    this.location,
    this.created,
    this.modified,
    required this.name,
    required this.description,
    required this.category,
    required this.urgency,
    required this.contactPhone,
    required this.volunteers,
    this.joiners = 0,
    this.joined = false,
    this.active = true,
    required this.skills,
    required this.certifications,
    this.info,
    this.coordinates,
    required this.attachments,
  });

  factory EmergencyModel.fromJson(Map<String, dynamic> json) {
    return EmergencyModel(
      id: _toInt(json['id']),

      creator: json['creator'] is Map
          ? EmergencyCreator.fromJson(
              Map<String, dynamic>.from(json['creator']),
            )
          : null,

      location: json['location'] is Map
          ? EmergencyLocation.fromJson(
              Map<String, dynamic>.from(json['location']),
            )
          : null,

      created: json['created'] != null
          ? DateTime.tryParse(json['created'].toString())
          : null,

      modified: json['modified'] != null
          ? DateTime.tryParse(json['modified'].toString())
          : null,

      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      urgency: json['urgency']?.toString() ?? 'medium',
      contactPhone: json['contact_phone']?.toString() ?? '',

      volunteers: _toInt(json['volunteers']),
      joiners: _toInt(json['joiners']),
      joined: json['joined'] == true,
      active: json['active'] ?? true,

      skills: (json['skills'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),

      certifications: (json['certifications'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),

      info: json['info'],
      coordinates: json['coordinates'],

      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map(
            (e) => EmergencyAttachment.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
    );
  }

  // ============================================================
  // Helpers
  // ============================================================

  String? get bloodType {
    final data = info;

    if (data is Map) {
      final value = data['blood_type']?.toString().trim();

      if (value != null && value.isNotEmpty) return value;
    }

    return null;
  }

  List<String> get imageUrls => attachments
      .where((a) => a.isImage && a.url.isNotEmpty)
      .map((a) => a.url)
      .toList();

  String? get coverUrl {
    final urls = imageUrls;

    return urls.isEmpty ? null : urls.first;
  }

  /// 0.0 → 1.0
  double get progress =>
      volunteers <= 0 ? 0.0 : (joiners / volunteers).clamp(0.0, 1.0);

  bool get isFull => volunteers > 0 && joiners >= volunteers;

  String get locationText {
    final loc = location;

    if (loc == null) return '';

    return [
      loc.description,
      loc.city,
    ].where((e) => e.trim().isNotEmpty).join(', ');
  }

  EmergencyModel copyWith({
    EmergencyCreator? creator,
    EmergencyLocation? location,
    DateTime? created,
    DateTime? modified,
    String? name,
    String? description,
    String? category,
    String? urgency,
    String? contactPhone,
    int? volunteers,
    int? joiners,
    bool? joined,
    bool? active,
    List<String>? skills,
    List<String>? certifications,
    dynamic info,
    dynamic coordinates,
    List<EmergencyAttachment>? attachments,
  }) {
    return EmergencyModel(
      id: id,
      creator: creator ?? this.creator,
      location: location ?? this.location,
      created: created ?? this.created,
      modified: modified ?? this.modified,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      urgency: urgency ?? this.urgency,
      contactPhone: contactPhone ?? this.contactPhone,
      volunteers: volunteers ?? this.volunteers,
      joiners: joiners ?? this.joiners,
      joined: joined ?? this.joined,
      active: active ?? this.active,
      skills: skills ?? this.skills,
      certifications: certifications ?? this.certifications,
      info: info ?? this.info,
      coordinates: coordinates ?? this.coordinates,
      attachments: attachments ?? this.attachments,
    );
  }
}

class EmergencyCreator {
  final int id;
  final String name;
  final String? avatar;

  EmergencyCreator({required this.id, required this.name, this.avatar});

  factory EmergencyCreator.fromJson(Map<String, dynamic> json) {
    return EmergencyCreator(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
    );
  }
}

class EmergencyLocation {
  final String city;
  final String state;
  final String description;
  final String url;

  EmergencyLocation({
    required this.city,
    required this.state,
    required this.description,
    required this.url,
  });

  factory EmergencyLocation.fromJson(Map<String, dynamic> json) {
    return EmergencyLocation(
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      url: json['url']?.toString().trim() ?? '',
    );
  }
}

class EmergencyAttachment {
  static const _imageExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  final int? id;
  final String url;
  final String name;
  final String? contentType;

  EmergencyAttachment({
    this.id,
    required this.url,
    required this.name,
    this.contentType,
  });

  /// الـ API بيرجّع الملف متداخل جوه `attachment`.
  factory EmergencyAttachment.fromJson(Map<String, dynamic> json) {
    final file = json['attachment'] is Map
        ? Map<String, dynamic>.from(json['attachment'])
        : json;

    return EmergencyAttachment(
      id: json['id'] is int ? json['id'] : null,
      url: file['url']?.toString() ?? '',
      name: file['name']?.toString() ?? '',
      contentType: (file['content-type'] ?? file['content_type'])?.toString(),
    );
  }

  bool get isImage {
    final type = (contentType ?? '').toLowerCase();

    if (_imageExtensions.contains(type) || type.startsWith('image/')) {
      return true;
    }

    final extension = name.split('.').last.toLowerCase();

    return _imageExtensions.contains(extension);
  }
}
