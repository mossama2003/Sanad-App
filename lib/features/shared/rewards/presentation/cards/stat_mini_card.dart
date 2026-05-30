import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class StatMiniCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String value, label;

  const StatMiniCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSize.padding(all: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomIcon(
            icon: icon,
            color: iconColor,
            width: AppSize.getWidth(22),
            height: AppSize.getHeight(22),
          ),
          SizedBox(height: AppSize.getHeight(8)),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSize.font(18),
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: AppSize.font(11), color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatMiniCard(
            icon: AppIcons.voltage,
            iconColor: AppColors.sportyViolet,
            value: '2,450',
            label: 'Total XP',
          ),
        ),
        SizedBox(width: AppSize.getWidth(10)),
        Expanded(
          child: StatMiniCard(
            icon: AppIcons.fire,
            iconColor: Color(0xFFFF6B35),
            value: '7',
            label: 'Day Streak',
          ),
        ),
        SizedBox(width: AppSize.getWidth(10)),
        Expanded(
          child: StatMiniCard(
            icon: AppIcons.growthArrow,
            iconColor: AppColors.gold,
            value: '+500',
            label: 'This Week',
          ),
        ),
      ],
    );
  }
}
