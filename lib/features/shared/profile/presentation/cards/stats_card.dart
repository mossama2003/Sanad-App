import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/style/app_colors.dart';

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
    return Container(
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
              fontSize: smallValue ? AppSize.font(19) : AppSize.font(22),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),

          Text(
            label,
            style: TextStyle(
              fontSize: AppSize.font(12),
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
