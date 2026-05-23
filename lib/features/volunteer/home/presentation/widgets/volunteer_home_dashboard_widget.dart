import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class VolunteerHomeDashboardWidget extends StatelessWidget {
  const VolunteerHomeDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSize.getHeight(230),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: AppColors.grey.withValues(alpha: 0.8),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// Background Image + Blur
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 2,
                // sigmaY: 10,
              ),
              child: Image.asset(
                AppImages.dashboardBackground,
                fit: BoxFit.cover,
              ),
            ),

            /// Color Overlay
            Container(
              color: AppColors.black.withValues(alpha: 0.2),
            ),

            /// Content
            Padding(
              padding: AppSize.padding(all: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'volunteer.home.dashboard.title'.tr()}Ahmed Hassan!',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppSize.font(20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(10)),

                  Text(
                    'volunteer.home.dashboard.desc'.tr(),
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppSize.font(15),
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(20)),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard(
                        icon: AppIcons.achievement,
                        value: '1,250',
                        title:
                        'volunteer.home.dashboard.xp_points'
                            .tr(),
                      ),

                      _buildStatCard(
                        icon: AppIcons.fire,
                        value: '7',
                        title:
                        'volunteer.home.dashboard.day_streak'
                            .tr(),
                      ),

                      _buildStatCard(
                        icon: AppIcons.badge,
                        value: '12',
                        title:
                        'volunteer.home.dashboard.badges'
                            .tr(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String value,
    required String title,
  }) {
    return Container(
      width: AppSize.getWidth(100),
      height: AppSize.getHeight(100),
      padding: AppSize.padding(all: 10),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIcon(
            icon: icon,
            color: AppColors.white,
            width: AppSize.getWidth(20),
            height: AppSize.getHeight(20),
          ),

          SizedBox(height: AppSize.getHeight(5)),

          Text(
            value,
            style: TextStyle(
              fontSize: AppSize.font(20),
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSize.font(10),
              fontWeight: FontWeight.w300,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}