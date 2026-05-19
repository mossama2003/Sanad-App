import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/style/app_colors.dart';

class EventsBottomSheet extends StatelessWidget {
  const EventsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    AppImages.eventsImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                    ),
                    child: Center(
                      child: CustomIcon(
                        onTap: () => AppNavigator.pop(),
                        icon: AppIcons.close,
                        color: AppColors.black,
                        width: AppSize.getSize(35),
                        height: AppSize.getSize(35),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: AppSize.padding(all: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'volunteer.home_removed.blood_donation_drive'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(10)),
                  Text(
                    'volunteer.home_removed.egyptian_red_crescent'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(15),
                      fontWeight: FontWeight.w400,
                      color: AppColors.black.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(12)),
                  Text(
                    'volunteer.home_removed.help_save'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(15),
                      fontWeight: FontWeight.w300,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(20)),
                  Container(
                    padding: AppSize.padding(all: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.grey50,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomIcon(
                              icon: AppIcons.events,
                              color: AppColors.primary,
                              width: AppSize.getSize(20),
                              height: AppSize.getSize(20),
                            ),
                            SizedBox(width: AppSize.getWidth(10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'volunteer.events.bottom_sheet.date_time'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(13),
                                    color: AppColors.grey700,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'volunteer.home_removed.date'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(14),
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.getHeight(10)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomIcon(
                              icon: AppIcons.duration,
                              color: AppColors.primary,
                              width: AppSize.getSize(20),
                              height: AppSize.getSize(20),
                            ),
                            SizedBox(width: AppSize.getWidth(10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'volunteer.events.bottom_sheet.duration'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(13),
                                    color: AppColors.grey700,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'volunteer.home_removed.4_hours'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(14),
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.getHeight(10)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomIcon(
                              icon: AppIcons.location,
                              color: AppColors.primary,
                              width: AppSize.getSize(20),
                              height: AppSize.getSize(20),
                            ),
                            SizedBox(width: AppSize.getWidth(10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'volunteer.events.bottom_sheet.location'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(13),
                                    color: AppColors.grey700,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'volunteer.home_removed.cairo_medical_center'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(14),
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.getHeight(10)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomIcon(
                              icon: AppIcons.community,
                              color: AppColors.primary,
                              width: AppSize.getSize(20),
                              height: AppSize.getSize(20),
                            ),
                            SizedBox(width: AppSize.getWidth(10)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'volunteer.events.bottom_sheet.volunteers'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(13),
                                    color: AppColors.grey700,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'volunteer.home_removed.members'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(14),
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(20)),
                  CustomButton(
                    title: 'volunteer.events.bottom_sheet.button'.tr(),
                    height: AppSize.getHeight(50),
                    bgColor: AppColors.primary,
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
