import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

class StatCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool smallValue;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.smallValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: textColor.withValues(alpha: .15), width: .7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .3 : .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: AppSize.padding(all: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIcon(
            icon: icon,
            color: iconColor,
            width: AppSize.getWidth(26),
            height: AppSize.getHeight(26),
          ),

          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: smallValue ? AppSize.font(19) : AppSize.font(22),
              fontWeight: FontWeight.w800,
              letterSpacing: -.5,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: .5),
              fontSize: AppSize.font(12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
