import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';

class OrganizationHomeDashboardWidget extends StatelessWidget {
  const OrganizationHomeDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSize.getHeight(230),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.laserBlue,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: AppColors.grey.withValues(alpha: 0.8),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: AppSize.padding(all: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'organization.home.dashboard.title'.tr()}Ahmed Hassan!',
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppSize.font(20),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppSize.getHeight(10)),
            Text(
              'organization.home.dashboard.desc'.tr(),
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppSize.font(15),
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: AppSize.getHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
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
                        icon: AppIcons.events,
                        color: AppColors.white,
                        width: AppSize.getWidth(18),
                        height: AppSize.getHeight(18),
                      ),
                      SizedBox(height: AppSize.getHeight(5)),
                      Text(
                        '12',
                        style: TextStyle(
                          fontSize: AppSize.font(20),
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        'organization.home.dashboard.active_events'.tr(),
                        style: TextStyle(
                          fontSize: AppSize.font(10),
                          fontWeight: FontWeight.w300,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
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
                        icon: AppIcons.completed,
                        color: AppColors.white,
                        width: AppSize.getWidth(20),
                        height: AppSize.getHeight(20),
                      ),
                      SizedBox(height: AppSize.getHeight(5)),
                      Text(
                        '48',
                        style: TextStyle(
                          fontSize: AppSize.font(20),
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        'organization.home.dashboard.completed'.tr(),
                        style: TextStyle(
                          fontSize: AppSize.font(10),
                          fontWeight: FontWeight.w300,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
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
                        icon: AppIcons.community,
                        color: AppColors.white,
                        width: AppSize.getWidth(20),
                        height: AppSize.getHeight(20),
                      ),
                      SizedBox(height: AppSize.getHeight(5)),
                      Text(
                        '1.2K',
                        style: TextStyle(
                          fontSize: AppSize.font(20),
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        'organization.home.dashboard.volunteers'.tr(),
                        style: TextStyle(
                          fontSize: AppSize.font(10),
                          fontWeight: FontWeight.w300,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
