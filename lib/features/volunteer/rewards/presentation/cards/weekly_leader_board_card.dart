import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/leader_board_model.dart';

class WeeklyLeaderboardCard extends StatelessWidget {
  final List<LeaderboardModel> entries;
  final String? period;

  const WeeklyLeaderboardCard({
    super.key,
    required this.entries,
    this.period,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: textColor.withValues(alpha: .12),
          width: .7,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? .2 : .05,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.cup,
                color: AppColors.gold,
                width: AppSize.getSize(20),
                height: AppSize.getSize(20),
              ),
              SizedBox(width: AppSize.getWidth(6)),
              Text(
                'shared.rewards.weekly_leaderboard'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(16),
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                period ?? 'shared.rewards.this_week'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(13),
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(14)),
          ...entries.map(
                (e) => _LeaderboardRow(entry: e),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardModel entry;

  const _LeaderboardRow({
    required this.entry,
  });

  Color get _rankBgColor {
    switch (entry.rank) {
      case 1:
        return const Color(0xFFFFD700).withValues(alpha: .15);
      case 2:
        return const Color(0xFFB0B0B0).withValues(alpha: .15);
      case 3:
        return const Color(0xFFCD7F32).withValues(alpha: .15);
      default:
        return AppColors.grey.withValues(alpha: .1);
    }
  }

  Color get _rankTextColor {
    switch (entry.rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFB0B0B0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Padding(
      padding: AppSize.padding(vertical: 5),
      child: Container(
        padding: AppSize.padding(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: entry.isCurrentUser
              ? AppColors.primary.withValues(alpha: .08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: entry.isCurrentUser
              ? Border.all(
            color: AppColors.primary.withValues(alpha: .25),
            width: 1,
          )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: AppSize.getSize(32),
              height: AppSize.getSize(32),
              decoration: BoxDecoration(
                color: _rankBgColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${entry.rank}',
                style: TextStyle(
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w700,
                  color: _rankTextColor,
                ),
              ),
            ),
            SizedBox(width: AppSize.getWidth(10)),
            Container(
              width: AppSize.getSize(38),
              height: AppSize.getSize(38),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2ECFA0),
                    Color(0xFF1BB88A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                entry.initials,
                style: TextStyle(
                  fontSize: AppSize.font(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(width: AppSize.getWidth(10)),
            Expanded(
              child: Text(
                entry.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppSize.font(14),
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            Container(
              padding: AppSize.padding(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_formatXp(entry.xp)} XP',
                style: TextStyle(
                  fontSize: AppSize.font(12),
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatXp(int xp) {
    if (xp >= 1000) {
      final formatted = (xp / 1000)
          .toStringAsFixed(xp % 1000 == 0 ? 0 : 3);

      return '${formatted.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')}K'
          .replaceAll(RegExp(r'(\.\d*?)0+K'), r'$1K');
    }

    return '$xp';
  }
}
