class BadgeModel {
  final int id;
  final String name;
  final String description;
  final String? image;
  final bool isEarned;
  final bool isActive;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.isEarned,
    required this.isActive,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString(),
      isEarned: json['is_earned'] == true,
      isActive: json['active'] == true,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
