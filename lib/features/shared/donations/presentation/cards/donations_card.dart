import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared/widgets/custom_progress_bar.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../dialogs/donations_pop_up.dart';

class DonationsCard extends StatelessWidget {
  const DonationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'shared.donations.active_campaigns'.tr(),
          style: TextStyle(
            fontSize: AppSize.font(18),
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: AppSize.getHeight(10)),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(30),
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
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

                    Positioned(
                      top: AppSize.getHeight(10),
                      right: AppSize.getWidth(10),
                      child: Container(
                        padding: AppSize.padding(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'shared.donations_removed.days_left'.tr(),
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: AppSize.font(11),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                      'shared.donations_removed.winter_clothing_drive'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(20),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(8)),
                    Text(
                      'shared.donations_removed.help_provide_warm'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(8)),
                    Text(
                      'shared.donations_removed.resala_charity'.tr(),
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
                          'shared.donations_removed.raised'.tr(),
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            fontWeight: FontWeight.w400,
                            color: AppColors.black.withValues(alpha: 0.8),
                          ),
                        ),
                        Spacer(),
                        Text(
                          'shared.donations_removed.goal'.tr(),
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
                          'shared.donations_removed.funded'.tr(),
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            fontWeight: FontWeight.w400,
                            color: AppColors.magenta,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'shared.donations_removed.days_left'.tr(),
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
                      title: 'shared.donations.button'.tr(),
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
        ),
      ],
    );
  }
}
