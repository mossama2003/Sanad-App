import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/features/shared/rewards/data/models/leader_board_model.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/enums/rewards_enum.dart';
import '../../data/models/rewards_model.dart';
import '../../data/models/xp_activity_model.dart';
import '../cards/level_card.dart';
import '../cards/level_rewards_card.dart';
import '../cards/recent_xp_activity_card.dart';
import '../cards/stat_mini_card.dart';
import '../cards/streak_tracker_card.dart';
import '../cards/weekly_leader_board_card.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  static const _rewards = [
    RewardsModel(
      level: 10,
      title: 'Verified Volunteer Badge',
      subtitle: 'Unlocked',
      status: RewardStatus.unlocked,
    ),
    RewardsModel(
      level: 12,
      title: 'Priority Event Booking',
      subtitle: 'Unlocked',
      status: RewardStatus.unlocked,
    ),
    RewardsModel(
      level: 15,
      title: 'Exclusive Community Access',
      subtitle: '1,050 XP needed',
      status: RewardStatus.locked,
    ),
    RewardsModel(
      level: 20,
      title: 'Custom Profile Frame',
      subtitle: '3,550 XP needed',
      status: RewardStatus.locked,
    ),
    RewardsModel(
      level: 25,
      title: 'Sanad Legend Status',
      subtitle: '6,050 XP needed',
      status: RewardStatus.locked,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSize.padding(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'shared.rewards.rewards'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(22),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'shared.rewards.track_your_progress'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(13),
                  color: AppColors.grey,
                ),
              ),
              SizedBox(height: AppSize.getHeight(20)),

              // Level Card
              const LevelCard(currentXp: 2450, nextLevelXp: 3000, level: 12),
              SizedBox(height: AppSize.getHeight(16)),

              // Stats Row
              const StatsRow(),
              SizedBox(height: AppSize.getHeight(16)),

              // Streak Tracker
              const StreakTrackerCard(),
              SizedBox(height: AppSize.getHeight(16)),

              // Level Rewards
              LevelRewardsCard(rewards: _rewards),
              SizedBox(height: AppSize.getHeight(16)),

              RecentXpActivityCard(
                onViewAll: () {},
                activities: [
                  XpActivityModel(
                    icon: AppIcons.calendar,
                    iconColor: AppColors.primary,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.12),
                    title: 'Attended Beach Cleanup',
                    time: 'Today, 10:32 AM',
                    xp: 150,
                  ),
                  XpActivityModel(
                    icon: AppIcons.fire,
                    iconColor: const Color(0xFFFF6B35),
                    iconBgColor: const Color(
                      0xFFFF6B35,
                    ).withValues(alpha: 0.12),
                    title: 'Daily streak bonus',
                    time: 'Today, 9:00 AM',
                    xp: 25,
                  ),
                  XpActivityModel(
                    icon: AppIcons.badge,
                    iconColor: const Color(0xFFFFD700),
                    iconBgColor: const Color(
                      0xFFFFD700,
                    ).withValues(alpha: 0.12),
                    title: "Earned 'Tree Hugger' badge",
                    time: 'Yesterday',
                    xp: 150,
                  ),
                  XpActivityModel(
                    icon: AppIcons.star,
                    iconColor: const Color(0xFFE05C5C),
                    iconBgColor: const Color(
                      0xFFE05C5C,
                    ).withValues(alpha: 0.12),
                    title: 'Donated to Hope Foundation',
                    time: 'Yesterday',
                    xp: 100,
                  ),
                  XpActivityModel(
                    icon: AppIcons.qr,
                    iconColor: const Color(0xFF4A90D9),
                    iconBgColor: const Color(
                      0xFF4A90D9,
                    ).withValues(alpha: 0.12),
                    title: 'QR Check-in completed',
                    time: '2 days ago',
                    xp: 50,
                  ),
                  XpActivityModel(
                    icon: AppIcons.community,
                    iconColor: const Color(0xFF7B2FBE),
                    iconBgColor: const Color(
                      0xFF7B2FBE,
                    ).withValues(alpha: 0.12),
                    title: 'Invited a friend',
                    time: '3 days ago',
                    xp: 75,
                  ),
                ],
              ),
              SizedBox(height: AppSize.getHeight(16)),

              WeeklyLeaderboardCard(
                entries: [
                  LeaderboardModel(rank: 1, name: 'Sara Hassan', xp: 5820),
                  LeaderboardModel(rank: 2, name: 'Omar Khaled', xp: 4210),
                  LeaderboardModel(
                    rank: 3,
                    name: 'Ahmed Mohamed',
                    xp: 2450,
                    isCurrentUser: true,
                  ),
                  LeaderboardModel(rank: 4, name: 'Nour Ali', xp: 2100),
                  LeaderboardModel(rank: 5, name: 'Yara Saad', xp: 1875),
                ],
              ),
              SizedBox(height: AppSize.getHeight(24)),
            ],
          ),
        ),
      ),
    );
  }
}
