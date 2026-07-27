import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class OrganizationHomeDashboardWidget extends StatelessWidget {
  const OrganizationHomeDashboardWidget({
    super.key,
    required this.organizationName,
  });

  final String organizationName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.75),
          ],
        ),

        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: AppColors.grey.withValues(alpha: 0.3),
            blurRadius: 12,
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),

        child: Stack(
          children: [
            Positioned(
              top: -10,
              right: -10,

              child: CustomIcon(
                width: AppSize.getSize(100),
                height: AppSize.getSize(100),
                icon: AppIcons.sparkle,
                color: AppColors.white.withValues(alpha: 0.15),
              ),
            ),

            Padding(
              padding: AppSize.padding(all: 20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'organization.home.dashboard.title'.tr(),

                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.9),
                      fontSize: AppSize.font(14),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(4)),

                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          organizationName,

                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: AppSize.font(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(width: AppSize.getWidth(5)),

                      Text('👋', style: TextStyle(fontSize: AppSize.font(20))),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(5)),

                  Text(
                    'organization.home.dashboard.desc'.tr(),

                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.9),
                      fontSize: AppSize.font(15),
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(18)),

                  CustomButton(
                    height: AppSize.getHeight(40),

                    title: 'organization.home.dashboard.go_to_dashboard'.tr(),

                    textSize: AppSize.font(14),

                    textColor: AppColors.black,

                    bgColor: AppColors.white.withValues(alpha: 0.95),
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
