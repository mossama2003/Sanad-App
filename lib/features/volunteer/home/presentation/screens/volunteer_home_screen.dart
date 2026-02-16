import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:sanad_app/core/constant/app_size.dart';

import '../../../emergency/emergency_events/presentation/screens/emergency_screen.dart';
import '../sections/volunteer_recently_completed_section.dart';
import '../sections/volunteer_upcoming_events_section.dart';
import '../widgets/volunteer_home_appbar_widget.dart';
import '../widgets/volunteer_home_dashboard_widget.dart';

class VolunteerHomeScreen extends StatelessWidget {
  const VolunteerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              VolunteerHomeAppbarWidget(),
              SizedBox(height: AppSize.getHeight(15)),
              Padding(
                padding: AppSize.padding(horizontal: 12),
                child: Column(
                  children: [
                    /// Home Dashboard
                    VolunteerHomeDashboardWidget(),
                    SizedBox(height: AppSize.getHeight(15)),

                    /// Options
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => AppNavigator.push(EmergencyScreen()),
                            child: Container(
                              height: AppSize.getHeight(70),
                              padding: AppSize.padding(start: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.red.withValues(alpha: 0.3),
                                ),
                                color: AppColors.red.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: AppSize.getSize(40),
                                    height: AppSize.getHeight(40),
                                    decoration: BoxDecoration(
                                      color: AppColors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: CustomIcon(
                                        icon: AppIcons.warning,
                                        color: AppColors.white,
                                        width: AppSize.getSize(25),
                                        height: AppSize.getSize(25),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: AppSize.getWidth(10)),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'home.options.emergency'.tr(),
                                        style: TextStyle(
                                          fontSize: AppSize.font(12),
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        'home.options.report_urgent'.tr(),
                                        style: TextStyle(
                                          fontSize: AppSize.font(10),
                                          color: AppColors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSize.getWidth(10)),
                        Expanded(
                          child: Container(
                            height: AppSize.getHeight(70),
                            padding: AppSize.padding(start: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                              color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: AppSize.getSize(40),
                                  height: AppSize.getHeight(40),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: CustomIcon(
                                      icon: AppIcons.qr,
                                      color: AppColors.white,
                                      width: AppSize.getSize(25),
                                      height: AppSize.getSize(25),
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppSize.getWidth(10)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'home.options.qr_check_in'.tr(),
                                      style: TextStyle(
                                        fontSize: AppSize.font(12),
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      'home.options.scan_to_earn'.tr(),
                                      style: TextStyle(
                                        fontSize: AppSize.font(10),
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.getHeight(15)),

                    /// Upcoming Events
                    VolunteerUpcomingEventsSection(),
                    SizedBox(height: AppSize.getHeight(8)),

                    /// Recently Completed
                    VolunteerRecentlyCompletedSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
