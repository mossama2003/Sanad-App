import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/shared/widgets/custom_progress_bar.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class OrganizationYourActiveEventsSection extends StatelessWidget {
  const OrganizationYourActiveEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'organization.home.your_active_events.title'.tr(),
          style: TextStyle(
            fontSize: AppSize.font(18),
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: AppSize.getHeight(12)),
        ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: AppSize.padding(bottom: 12),
              child: Container(
                width: double.infinity,
                padding: AppSize.padding(all: 15),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
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
                    Text(
                      'organization.home_removed.blood_donation_drive'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(5)),
                    Text(
                      'organization.home_removed.date'.tr(),
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
                          'organization.home.your_active_events.volunteers'
                              .tr(),
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
                    SizedBox(height: AppSize.getHeight(10)),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            title:
                                'organization.home.your_active_events.view_details_button'
                                    .tr(),
                            bgColor: AppColors.laserBlue.withValues(alpha: 0.1),
                            textColor: AppColors.laserBlue,
                            height: AppSize.getHeight(35),
                            textSize: AppSize.font(12),
                          ),
                        ),
                        SizedBox(width: AppSize.getWidth(5)),
                        Expanded(
                          child: CustomButton(
                            title:
                                'organization.home.your_active_events.edit_event_button'
                                    .tr(),
                            bgColor: AppColors.grey200,
                            textColor: AppColors.grey700,
                            height: AppSize.getHeight(35),
                            textSize: AppSize.font(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
