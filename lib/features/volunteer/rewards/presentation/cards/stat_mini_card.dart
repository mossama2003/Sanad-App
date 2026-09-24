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
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .6);

    return Container(
      padding: AppSize.padding(all: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
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
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSize.font(11),
              color: secondaryColor,
            ),
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
            iconColor: const Color(0xFFFF6B35),
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
