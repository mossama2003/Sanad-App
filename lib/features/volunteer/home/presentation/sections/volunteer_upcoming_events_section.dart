import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../events/presentation/screens/events_screen.dart';

class VolunteerUpcomingEventsSection extends StatelessWidget {
  const VolunteerUpcomingEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'volunteer.home.upcoming_events.title'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(18),
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () => AppNavigator.push(EventsScreen()),
              child: Text(
                'volunteer.home.upcoming_events.view_all'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(12),
                  fontWeight: FontWeight.w400,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        // SizedBox(height: AppSize.getHeight(5)),
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
                      'volunteer.home_removed.blood_donation_drive'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(5)),
                    Text(
                      'volunteer.home_removed.egyptian_red_crescent'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(5)),
                    Row(
                      children: [
                        Text(
                          'volunteer.home_removed.date'.tr(),
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'volunteer.home_removed.cairo_medical_center'.tr(),
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            fontWeight: FontWeight.w400,
                            color: AppColors.primary,
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
