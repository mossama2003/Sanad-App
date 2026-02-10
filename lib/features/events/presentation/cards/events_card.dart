import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';

import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_size.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/widgets/custom_icon.dart';
import '../../../../core/style/app_colors.dart';
import '../dialogs/events_bottom_sheet.dart';

class EventsCard extends StatelessWidget {
  const EventsCard({super.key});

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
                    AppImages.eventsImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: AppSize.padding(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.brand50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'home_removed.blood_donation'.tr(),
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: AppSize.font(12),
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
                  'home_removed.blood_donation_drive'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(3)),
                Text(
                  'home_removed.egyptian_red_crescent'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    fontWeight: FontWeight.w400,
                    color: AppColors.black.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(15)),
                Row(
                  children: [
                    CustomIcon(
                      icon: AppIcons.events,
                      height: AppSize.getSize(18),
                      width: AppSize.getSize(18),
                      color: AppColors.black.withValues(alpha: 0.7),
                    ),
                    SizedBox(width: AppSize.getWidth(5)),
                    Text(
                      'home_removed.date'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Row(
                  children: [
                    CustomIcon(
                      icon: AppIcons.duration,
                      height: AppSize.getSize(18),
                      width: AppSize.getSize(18),
                      color: AppColors.black.withValues(alpha: 0.7),
                    ),
                    SizedBox(width: AppSize.getWidth(5)),
                    Text(
                      'home_removed.duration'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Row(
                  children: [
                    CustomIcon(
                      icon: AppIcons.location,
                      height: AppSize.getSize(18),
                      width: AppSize.getSize(18),
                      color: AppColors.black.withValues(alpha: 0.7),
                    ),
                    SizedBox(width: AppSize.getWidth(5)),
                    Text(
                      'home_removed.cairo_medical_center'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Row(
                  children: [
                    CustomIcon(
                      icon: AppIcons.community,
                      height: AppSize.getSize(18),
                      width: AppSize.getSize(18),
                      color: AppColors.black.withValues(alpha: 0.7),
                    ),
                    SizedBox(width: AppSize.getWidth(5)),
                    Text(
                      'home_removed.members'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(15)),
                CustomButton(
                  title: 'events.button'.tr(),
                  onTap: () => AppNavigator.sheet(const EventsBottomSheet()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
