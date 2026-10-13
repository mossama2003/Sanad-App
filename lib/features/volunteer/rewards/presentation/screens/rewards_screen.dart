import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/features/volunteer/rewards/presentation/cards/level_rewards_card.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/auth/data/models/user_profile_model.dart';
import '../../data/models/leader_board_model.dart';
import '../../data/models/xp_activity_model.dart' as rewards_api;
import '../../data/repos/rewards_repo.dart';
import '../cards/level_card.dart';
import '../cards/recent_xp_activity_card.dart';
import '../cards/stat_mini_card.dart';
import '../cards/weekly_leader_board_card.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/rewards_cubit.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RewardsCubit(RewardsRepoImpel()),
      child: const _RewardsView(),
    );
  }
}

class _RewardsView extends StatefulWidget {
  const _RewardsView();

  @override
  State<_RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<_RewardsView> {
  late final RewardsCubit _cubit;

  bool _hasLoadedRewards = false;
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasLoadedRewards) return;

    _hasLoadedRewards = true;
    _cubit = RewardsCubit.get(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadRewards();
    });
  }

  Future<void> _loadRewards() async {
    final user = AppCubit.get(context).user;
    final volunteerId = user?.id;

    if (volunteerId == null) {
      if (mounted && _isFirstLoad) {
        setState(() => _isFirstLoad = false);
      }
      return;
    }

    try {
      await _cubit.getRewards(volunteerId: volunteerId);
    } catch (_) {
      // حالة الخطأ يتم التعامل معها من خلال RewardsCubit.
    } finally {
      if (mounted && _isFirstLoad) {
        setState(() => _isFirstLoad = false);
      }
    }
  }

  Future<void> _refresh() async {
    await _loadRewards();
  }

  String _formatActivityTime(String value) {
    if (value.isEmpty) return '';

    final date = DateTime.tryParse(value);
    if (date == null) return value;

    final localDate = date.toLocal();
    final now = DateTime.now();

    final isToday =
        localDate.year == now.year &&
        localDate.month == now.month &&
        localDate.day == now.day;

    final yesterday = now.subtract(const Duration(days: 1));

    final isYesterday =
        localDate.year == yesterday.year &&
        localDate.month == yesterday.month &&
        localDate.day == yesterday.day;

    if (isToday) {
      return '${'shared.rewards.today'.tr()}, '
          '${DateFormat('h:mm a').format(localDate)}';
    }

    if (isYesterday) {
      return 'shared.rewards.yesterday'.tr();
    }

    return DateFormat('d MMM, h:mm a').format(localDate);
  }

  Color _activityColor(rewards_api.XpActivityModel activity) {
    final text = '${activity.title} ${activity.description}'.toLowerCase();

    if (text.contains('streak')) {
      return const Color(0xFFFF6B35);
    }

    if (text.contains('badge')) {
      return const Color(0xFFFFB800);
    }

    if (text.contains('donat')) {
      return const Color(0xFFE05C5C);
    }

    if (text.contains('qr') || text.contains('check-in')) {
      return const Color(0xFF4A90D9);
    }

    if (text.contains('friend') || text.contains('invite')) {
      return const Color(0xFF7B2FBE);
    }

    return AppColors.primary;
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Container(
      width: double.infinity,
      padding: AppSize.padding(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: textColor.withValues(alpha: 0.10)),
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 27, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: AppSize.font(15),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.60),
              fontSize: AppSize.font(12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: 0.60);
    final backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: BlocBuilder<RewardsCubit, RewardsState>(
        bloc: _cubit,
        builder: (context, state) {
          final activities = _cubit.activities;
          final leaderboard = _cubit.leaderboard;

          // أول تحميل فقط يعرض Loading على الشاشة بالكامل.
          if (_isFirstLoad) {
            return const Center(child: CircularProgressIndicator());
          }

          final appCubit = AppCubit.get(context);
          final profile = appCubit.user?.profile;

          final volunteerProfile = profile is VolunteerProfileModel
              ? profile
              : null;

          final int currentXp = volunteerProfile?.xp ?? 0;
          final int dayStreak = volunteerProfile?.streak ?? 0;

          final level = appCubit.volunteerLevel ?? volunteerProfile?.level;

          final int currentLevel = level?.rank ?? 1;
          final int nextLevelXp = level?.maxXp ?? 100;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: AppSize.padding(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'shared.rewards.rewards'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(22),
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),

                  Text(
                    'shared.rewards.track_your_progress'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(13),
                      color: secondaryColor,
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(20)),

                  LevelCard(
                    currentXp: currentXp,
                    nextLevelXp: nextLevelXp,
                    level: currentLevel,
                  ),

                  SizedBox(height: AppSize.getHeight(16)),

                  StatsRow(totalXp: currentXp, dayStreak: dayStreak),

                  SizedBox(height: AppSize.getHeight(16)),

                  // Recent XP Activities
                  if (activities.isNotEmpty)
                    RecentXpActivityCard(
                      onViewAll: () {
                        // اربطها بشاشة جميع الأنشطة عند إضافتها.
                      },
                      activities: activities.map((activity) {
                        final color = _activityColor(activity);

                        return rewards_api.XpActivityModel(
                          id: activity.id,
                          title: activity.title,
                          description: activity.description,
                          xp: activity.xp,
                          createdAt: _formatActivityTime(activity.createdAt),
                          icon: activity.icon,
                          iconColor: color,
                          iconBgColor: color.withValues(alpha: 0.12),
                        );
                      }).toList(),
                    )
                  else
                    _buildEmptyState(
                      context,
                      icon: Icons.bolt_rounded,
                      title: 'No XP activity yet',
                      subtitle: 'Your earned XP activities will appear here.',
                    ),

                  SizedBox(height: AppSize.getHeight(16)),

                  // Weekly Leaderboard
                  if (leaderboard.isNotEmpty)
                    WeeklyLeaderboardCard(
                      entries: leaderboard.map((entry) {
                        return LeaderboardModel(
                          rank: entry.rank,
                          name: entry.name,
                          xp: entry.xp,
                        );
                      }).toList(),
                    )
                  else
                    _buildEmptyState(
                      context,
                      icon: Icons.leaderboard_rounded,
                      title: 'No leaderboard data',
                      subtitle: 'Volunteer rankings will appear here.',
                    ),

                  SizedBox(height: AppSize.getHeight(24)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
