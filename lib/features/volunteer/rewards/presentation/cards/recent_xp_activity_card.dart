import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/xp_activity_model.dart' show XpActivityModel;

class RecentXpActivityCard extends StatelessWidget {
  final List<XpActivityModel> activities;
  final VoidCallback? onViewAll;

  const RecentXpActivityCard({
    super.key,
    required this.activities,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.2),
          width: 0.7,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.voltage,
                color: AppColors.sportyViolet,
                width: AppSize.getSize(20),
                height: AppSize.getSize(20),
              ),
              SizedBox(width: AppSize.getWidth(6)),
              Text(
                'shared.rewards.recent_xp_activity'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(16),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onViewAll,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'shared.rewards.all'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(12),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(14)),

          // Activity rows
          ...activities.map((a) => _XpActivityRow(activity: a)),
        ],
      ),
    );
  }
}

class _XpActivityRow extends StatelessWidget {
  final XpActivityModel activity;

  const _XpActivityRow({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSize.padding(vertical: 8),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: AppSize.getSize(42),
            height: AppSize.getSize(42),
            decoration: BoxDecoration(
              color: activity.iconBgColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: CustomIcon(
              icon: activity.icon,
              color: activity.iconColor,
              width: AppSize.getSize(20),
              height: AppSize.getSize(20),
            ),
          ),
          SizedBox(width: AppSize.getWidth(12)),

          // Title + time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppSize.font(14),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(2)),
                Text(
                  activity.time,
                  style: TextStyle(
                    fontSize: AppSize.font(12),
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),

          // XP pill
          Container(
            padding: AppSize.padding(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+${activity.xp} XP',
              style: TextStyle(
                fontSize: AppSize.font(12),
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
