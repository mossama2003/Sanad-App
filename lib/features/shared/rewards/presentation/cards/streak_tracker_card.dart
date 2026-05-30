import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class StreakTrackerCard extends StatelessWidget {
  const StreakTrackerCard({super.key});

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

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
        children: [
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.fire,
                color: Color(0xFFFF6B35),
                width: AppSize.getWidth(20),
                height: AppSize.getHeight(20),
              ),

              SizedBox(width: AppSize.getWidth(6)),
              Text(
                'shared.rewards.streak_tracker'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(16),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                'shared.rewards.longest'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(12),
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _days
                .map(
                  (d) => Column(
                    children: [
                      Container(
                        width: AppSize.getSize(38),
                        height: AppSize.getSize(38),

                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: CustomIcon(
                            icon: AppIcons.fire,
                            color: AppColors.white,
                            width: AppSize.getWidth(20),
                            height: AppSize.getHeight(20),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSize.getHeight(6)),
                      Text(
                        d,
                        style: TextStyle(
                          fontSize: AppSize.font(11),
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          SizedBox(height: AppSize.getHeight(12)),
          Text(
            'shared.rewards.volunteer_today'.tr(),
            style: TextStyle(fontSize: AppSize.font(12), color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
