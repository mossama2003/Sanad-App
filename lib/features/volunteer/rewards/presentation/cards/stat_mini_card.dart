import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_count_up_text.dart';
import '../../../../../core/style/app_colors.dart';

class StatMiniCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool isCountUp;

  const StatMiniCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.isCountUp = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .6);

    final numericValue =
        int.tryParse(value.replaceAll(',', '').replaceAll('+', '')) ?? 0;

    return Container(
      padding: AppSize.padding(all: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: textColor.withValues(alpha: .12), width: .7),
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
          if (isCountUp)
            AppCountUpText(
              value: numericValue,
              style: TextStyle(
                fontSize: AppSize.font(18),
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            )
          else
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
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: AppSize.font(11), color: secondaryColor),
          ),
        ],
      ),
    );
  }
}

class StatsRow extends StatelessWidget {
  final int totalXp;
  final int dayStreak;

  const StatsRow({super.key, required this.totalXp, required this.dayStreak});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatMiniCard(
            icon: AppIcons.voltage,
            iconColor: AppColors.sportyViolet,
            value: totalXp.toString(),
            label: 'Total XP',
            isCountUp: true,
          ),
        ),
        SizedBox(width: AppSize.getWidth(10)),
        Expanded(
          child: StatMiniCard(
            icon: AppIcons.fire,
            iconColor: const Color(0xFFFF6B35),
            value: dayStreak.toString(),
            label: 'Day Streak',
          ),
        ),
      ],
    );
  }
}
