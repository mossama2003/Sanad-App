import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/enums/badges_enum.dart';
import '../../data/models/badges_model.dart';

class BadgeCard extends StatelessWidget {
  final BadgeModel badge;

  const BadgeCard({super.key, required this.badge});

  Color get _tierColor {
    switch (badge.tier) {
      case BadgeTier.gold:
        return AppColors.gold;
      case BadgeTier.silver:
        return AppColors.silver;
      case BadgeTier.bronze:
        return AppColors.bronze;
    }
  }

  String get _tierLabel {
    switch (badge.tier) {
      case BadgeTier.gold:
        return 'shared.badges.gold'.tr();
      case BadgeTier.silver:
        return 'shared.badges.silver'.tr();
      case BadgeTier.bronze:
        return 'shared.badges.bronze'.tr();
    }
  }

  bool get _isEarned => badge.status == BadgeStatus.earned;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: AppSize.padding(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sparkle icon (top-right)
          Align(
            alignment: Alignment.topRight,
            child: CustomIcon(
              icon: AppIcons.sparkle,
              color: _isEarned ? _tierColor : const Color(0xFFDDDDDD),
              width: AppSize.getSize(15),
              height: AppSize.getSize(15),
            ),
          ),

          // Emoji circle
          Container(
            width: AppSize.getWidth(54),
            height: AppSize.getWidth(54),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isEarned
                  ? _tierColor.withValues(alpha: 0.15)
                  : const Color(0xFFF0F0F0),
            ),
            alignment: Alignment.center,
            child: Text(
              badge.emoji,
              style: TextStyle(
                fontSize: AppSize.font(26),
                color: _isEarned ? null : const Color(0xFFCCCCCC),
              ),
            ),
          ),

          // Name
          Text(
            badge.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSize.font(11),
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),

          // Tier pill OR progress bar
          if (badge.progress == null)
            Container(
              padding: AppSize.padding(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _tierColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _tierLabel,
                style: TextStyle(
                  fontSize: AppSize.font(10),
                  fontWeight: FontWeight.w600,
                  color: _tierColor,
                ),
              ),
            )
          else
            Column(
              children: [
                Container(
                  padding: AppSize.padding(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _tierColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _tierLabel,
                    style: TextStyle(
                      fontSize: AppSize.font(10),
                      fontWeight: FontWeight.w600,
                      color: _tierColor,
                    ),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(6)),

                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: badge.progress! / badge.total!,
                    backgroundColor: const Color(0xFFEEEEEE),
                    valueColor: AlwaysStoppedAnimation<Color>(_tierColor),
                    minHeight: 5,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(2)),
                Text(
                  '${badge.progress}/${badge.total}',
                  style: TextStyle(
                    fontSize: AppSize.font(9),
                    color: Color(0xFFAAAAAA),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
