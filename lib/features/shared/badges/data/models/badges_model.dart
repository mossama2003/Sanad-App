import '../enums/badges_enum.dart';

class BadgeModel {
  final String emoji;
  final String name;
  final BadgeTier tier;
  final BadgeStatus status;
  final int? progress;
  final int? total;

  const BadgeModel({
    required this.emoji,
    required this.name,
    required this.tier,
    required this.status,
    this.progress,
    this.total,
  });
}
