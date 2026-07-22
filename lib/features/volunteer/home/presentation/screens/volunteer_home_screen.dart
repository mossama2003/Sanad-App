import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/badges/presentation/screens/badges_screen.dart';
import '../../../events/presentation/controllers/volunteer_events_cubit.dart';
import '../../../rewards/presentation/screens/rewards_screen.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../sections/volunteer_upcoming_events_section.dart';
import '../widgets/volunteer_home_dashboard_widget.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../widgets/volunteer_home_appbar_widget.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/constant/app_size.dart';

class VolunteerHomeScreen extends StatefulWidget {
  const VolunteerHomeScreen({super.key});

  @override
  State<VolunteerHomeScreen> createState() => _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends State<VolunteerHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<VolunteerEventsCubit, VolunteerEventsState>(
      builder: (context, state) {
        final eventsCubit = VolunteerEventsCubit.get(context);

        final myActiveEvents =
            eventsCubit.events
                .where(
                  (e) =>
                      e.joined &&
                      (e.status == 'ongoing' || e.status == 'upcoming'),
                )
                .toList()
              ..sort((a, b) {
                if (a.status == 'ongoing' && b.status != 'ongoing') return -1;
                if (a.status != 'ongoing' && b.status == 'ongoing') return 1;

                return a.date.compareTo(b.date);
              });

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const VolunteerHomeAppbarWidget(),
                  SizedBox(height: AppSize.getHeight(15)),

                  Padding(
                    padding: AppSize.padding(horizontal: 12),
                    child: Column(
                      children: [
                        /// Home Dashboard
                        const VolunteerHomeDashboardWidget(),
                        SizedBox(height: AppSize.getHeight(15)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  AppNavigator.push(VolunteerRewardsScreen()),
                              child: _buildStatCard(
                                bgColor: AppColors.sportyViolet.withValues(
                                  alpha: 0.2,
                                ),
                                bgIconColor: AppColors.sportyViolet.withValues(
                                  alpha: 0.2,
                                ),
                                iconColor: AppColors.sportyViolet,
                                titleColor: AppColors.sportyViolet,
                                icon: AppIcons.achievement,
                                value: '1,250',
                                title: 'volunteer.home.dashboard.xp_points'
                                    .tr(),
                              ),
                            ),

                            GestureDetector(
                              onTap: () =>
                                  AppNavigator.push(VolunteerRewardsScreen()),
                              child: _buildStatCard(
                                bgColor: AppColors.brand600.withValues(
                                  alpha: 0.2,
                                ),
                                bgIconColor: AppColors.brand600.withValues(
                                  alpha: 0.2,
                                ),
                                iconColor: AppColors.brand600,
                                titleColor: AppColors.brand600,
                                icon: AppIcons.fire,
                                value: '7',
                                title: 'volunteer.home.dashboard.day_streak'
                                    .tr(),
                              ),
                            ),

                            GestureDetector(
                              onTap: () => AppNavigator.push(BadgesScreen()),
                              child: _buildStatCard(
                                bgColor: AppColors.secondary400.withValues(
                                  alpha: 0.2,
                                ),
                                bgIconColor: AppColors.secondary400.withValues(
                                  alpha: 0.2,
                                ),
                                iconColor: AppColors.secondary400,
                                titleColor: AppColors.secondary400,
                                icon: AppIcons.badge,
                                value: '12',
                                title: 'volunteer.home.dashboard.badges'.tr(),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppSize.getHeight(15)),

                        /// Upcoming Events
                        MyEventsSection(events: myActiveEvents),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String value,
    required String title,
    required Color titleColor,
    required Color bgColor,
    required Color bgIconColor,
    required Color iconColor,
  }) {
    return Container(
      width: AppSize.getWidth(110),
      padding: AppSize.padding(all: 15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: AppSize.padding(all: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgIconColor,
            ),
            child: CustomIcon(
              icon: icon,
              color: iconColor,
              width: AppSize.getWidth(20),
              height: AppSize.getHeight(20),
            ),
          ),

          SizedBox(height: AppSize.getHeight(5)),

          Text(
            value,
            style: TextStyle(
              color: titleColor,
              fontSize: AppSize.font(20),
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: AppSize.getHeight(5)),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSize.font(12),
              fontWeight: FontWeight.w400,
              color: titleColor,
            ),
          ),
        ],
      ),
    );
  }
}
