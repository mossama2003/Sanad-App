class VolunteerLevelModel {
  final int? id;
  final String? created;
  final String? modified;
  final String? name;
  final int? rank;
  final int? minXp;
  final int? maxXp;

  const VolunteerLevelModel({
    this.id,
    this.created,
    this.modified,
    this.name,
    this.rank,
    this.minXp,
    this.maxXp,
  });

  factory VolunteerLevelModel.fromJson(Map<String, dynamic> json) {
    return VolunteerLevelModel(
      id: json['id'] as int?,
      created: json['created'] as String?,
      modified: json['modified'] as String?,
      name: json['name'] as String?,
      rank: json['rank'] as int?,
      minXp: json['min_xp'] as int?,
      maxXp: json['max_xp'] as int?,
    );
  }
}