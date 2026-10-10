import '../enums/rewards_enum.dart';

class RewardsModel {
  final int level;
  final String title;
  final String subtitle;
  final RewardStatus status;

  const RewardsModel({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.status,
  });
}