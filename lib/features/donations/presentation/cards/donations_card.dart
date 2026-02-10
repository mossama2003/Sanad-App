import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/app_navigator.dart';
import '../../../../core/shared/widgets/custom_progress_bar.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_size.dart';
import '../../../../core/style/app_colors.dart';
import '../dialogs/donations_pop_up.dart';

class DonationsCard extends StatelessWidget {
  const DonationsCard({super.key});

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
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.grey.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Image.asset(
                    AppImages.donationsImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSize.padding(all: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'donations_removed.winter_clothing_drive'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(20),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Text(
                  'donations_removed.help_provide_warm'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.w400,
                    color: AppColors.black.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Text(
                  'donations_removed.resala_charity'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(12),
                    fontWeight: FontWeight.w400,
                    color: AppColors.black.withValues(alpha: 0.4),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Row(
                  children: [
                    Text(
                      'donations_removed.raised'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    Spacer(),
                    Text(
                      'donations_removed.goal'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(6)),
                CustomProgressBar(percent: 65, color: AppColors.magenta),
                SizedBox(height: AppSize.getHeight(6)),
                Row(
                  children: [
                    Text(
                      'donations_removed.funded'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w400,
                        color: AppColors.magenta,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'donations_removed.days_left'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(15)),
                CustomButton(
                  title: 'donations.button'.tr(),
                  icon: AppIcons.donations,
                  bgColor: AppColors.magenta,
                  height: AppSize.getHeight(50),
                  onTap: () => AppNavigator.dialog(const DonationsPopUp()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
