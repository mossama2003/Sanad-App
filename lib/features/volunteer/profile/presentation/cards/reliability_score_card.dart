import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/shared/widgets/custom_progress_bar.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';

class ReliabilityScoreCard extends StatelessWidget {
  const ReliabilityScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.grey900.withValues(alpha: 0.2),
          width: 0.7,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey900.withValues(alpha: 0.05),
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
                icon: AppIcons.starOutlined,
                color: AppColors.white,
                width: AppSize.getSize(18),
                height: AppSize.getSize(18),
              ),
              SizedBox(width: AppSize.getWidth(5)),
              Text(
                'volunteer.profile.reliability_score'.tr(),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppSize.font(15),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '94',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    TextSpan(
                      text: '/100',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: AppSize.getHeight(16)),
          CustomProgressBar(
            height: AppSize.getSize(6),
            percent: 90,
            color: AppColors.white,
            bgColor: AppColors.white.withValues(alpha: 0.2),
          ),
          SizedBox(height: AppSize.getHeight(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'volunteer.profile.attendance_rate'.tr(),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'volunteer.profile.completion_rate'.tr(),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(12)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'volunteer.profile.emergency_response'.tr(),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'volunteer.profile.org_ratings'.tr(),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(16)),
          Text(
            'volunteer.profile.priority_access'.tr(),
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSize.font(13),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
