import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/shared/widgets/custom_progress_bar.dart';
import '../../../../../core/style/app_colors.dart';

class OrganizationEventsCard extends StatelessWidget {
  const OrganizationEventsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSize.padding(all: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'organization.home_removed.blood_donation_drive'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(5)),
                Row(
                  children: [
                    Container(
                      padding: AppSize.padding(vertical: 6, horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.laserBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'organization.home_removed.blood_donation'.tr(),
                        style: TextStyle(
                          color: AppColors.laserBlue,
                          fontSize: AppSize.font(13),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.getWidth(8)),
                    Container(
                      padding: AppSize.padding(vertical: 6, horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'organization.events.filter.upcoming'.tr(),
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: AppSize.font(13),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(10)),
                Text(
                  '${'organization.home_removed.date'.tr()} • ${'organization.home_removed.10am'.tr()} • ${'organization.home_removed.cairo_medical_canter'.tr()}',
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    fontWeight: FontWeight.w400,
                    color: AppColors.black.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(10)),
                Row(
                  children: [
                    Text(
                      'organization.events.volunteers'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'organization.home_removed.45_60'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(6)),
                CustomProgressBar(
                  percent: 60,
                  color: AppColors.laserBlue,
                  height: AppSize.getHeight(8),
                ),
                SizedBox(height: AppSize.getHeight(15)),
                Row(children: []),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
