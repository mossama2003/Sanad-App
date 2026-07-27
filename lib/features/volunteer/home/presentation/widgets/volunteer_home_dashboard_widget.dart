import 'dart:ui';

import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../qr_check_in/presentation/screens/qr_check_in_screen.dart';

class VolunteerHomeDashboardWidget extends StatelessWidget {
  const VolunteerHomeDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppCubit.get(context).user;

    return Container(
      height: AppSize.getHeight(165),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset.zero,
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
            /// Background
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Image.asset(
                AppImages.dashboardBackground,
                fit: BoxFit.cover,
              ),
            ),

            /// Overlay
            Container(color: AppColors.black.withValues(alpha: 0.3)),

            /// Content
            Padding(
              padding: AppSize.padding(all: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'volunteer.home.dashboard.title'.tr()} ${user?.name ?? ''}!',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppSize.font(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(10)),

                  Text(
                    'volunteer.home.dashboard.desc'.tr(),
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppSize.font(15),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(20)),

                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onTap: () => AppNavigator.push(QrCheckInScreen()),
                          icon: AppIcons.qr,
                          iconSize: AppSize.getSize(20),
                          bgColor: AppColors.bronze,
                          textColor: AppColors.white,
                          title: 'volunteer.home.options.qr_check_in'.tr(),
                        ),
                      ),
                      SizedBox(width: AppSize.getWidth(10)),
                      Expanded(
                        child: CustomButton(
                          icon: AppIcons.warning,
                          iconSize: AppSize.getSize(20),
                          bgColor: AppColors.red,
                          textColor: AppColors.white,
                          title: 'volunteer.home.options.emergency'.tr(),
                        ),
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
}
