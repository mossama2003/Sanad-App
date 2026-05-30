import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../badges/presentation/screens/badges_screen.dart';

class BadgesCard extends StatelessWidget {
  static const _badges = ['🌱', '🩸', '🌳', '⭐', '📚', '🏥'];

  const BadgesCard({super.key});

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
        children: [
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.badge,
                color: AppColors.secondary400,
                width: AppSize.getSize(20),
                height: AppSize.getSize(20),
              ),
              SizedBox(width: AppSize.getWidth(5)),
              Text(
                'shared.profile.badges'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(15),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => AppNavigator.push(BadgesScreen()),
                style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'shared.profile.view_all'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _badges
                .map(
                  (b) => Container(
                    width: AppSize.getWidth(40),
                    height: AppSize.getWidth(40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      b,
                      style: TextStyle(fontSize: AppSize.font(22)),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
