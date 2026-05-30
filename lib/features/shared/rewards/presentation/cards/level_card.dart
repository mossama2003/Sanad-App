import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class LevelCard extends StatelessWidget {
  final int currentXp, nextLevelXp, level;

  const LevelCard({
    super.key,
    required this.currentXp,
    required this.nextLevelXp,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentXp / nextLevelXp;
    final remaining = nextLevelXp - currentXp;

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FBE), Color(0xFF4A90D9), Color(0xFF2ECFA0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Crown icon
              Container(
                width: AppSize.getSize(44),
                height: AppSize.getSize(44),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIcon(
                    icon: AppIcons.crown,
                    color: AppColors.white,
                    width: AppSize.getSize(30),
                    height: AppSize.getSize(30),
                  ),
                ),
              ),
              SizedBox(width: AppSize.getWidth(12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'shared.rewards.current_level'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(12),
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    '${'shared.rewards.level'.tr()} $level',
                    style: TextStyle(
                      fontSize: AppSize.font(22),
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: AppSize.padding(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'shared.rewards.active_hero'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(11),
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentXp XP',
                style: TextStyle(
                  fontSize: AppSize.font(12),
                  color: AppColors.white,
                ),
              ),
              Text(
                '$nextLevelXp XP',
                style: TextStyle(
                  fontSize: AppSize.font(12),
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(8)),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              minHeight: 8,
            ),
          ),
          SizedBox(height: AppSize.getHeight(8)),
          Center(
            child: Text(
              '$remaining XP to Level ${level + 1}',
              style: TextStyle(
                fontSize: AppSize.font(12),
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
