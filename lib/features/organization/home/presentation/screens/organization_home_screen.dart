import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../sections/organization_quick_actions_section.dart';
import '../sections/organization_recently_completed_section.dart';
import '../widgets/organization_home_appbar_widget.dart';
import '../widgets/organization_home_dashboard_widget.dart';

class OrganizationHomeScreen extends StatefulWidget {
  const OrganizationHomeScreen({super.key});

  @override
  State<OrganizationHomeScreen> createState() => _OrganizationHomeScreenState();
}

class _OrganizationHomeScreenState extends State<OrganizationHomeScreen> {
  // late final OrganizationEventsCubit _cubit;

  @override
  // void initState() {
  //   super.initState();
  // _cubit = OrganizationEventsCubit(OrganizationEventsRepoImpel());
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   _cubit.loadEventsFromCache();
  //
  //   if (_cubit.shouldRefreshEvents()) {
  //     _cubit.getOrganizationEvents();
  //   }
  // });
  // }
  // @override
  // void dispose() {
  //   _cubit.close();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<OrganizationEventsCubit, OrganizationEventsState>(
    // bloc: _cubit,

    // builder: (context, state) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const OrganizationHomeAppbarWidget(),

              SizedBox(height: AppSize.getHeight(15)),

              Padding(
                padding: AppSize.padding(horizontal: 12),

                child: Column(
                  children: [
                    OrganizationHomeDashboardWidget(),

                    SizedBox(height: AppSize.getHeight(15)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        _buildStatCard(
                          context,

                          icon: AppIcons.events,
                          iconColor: AppColors.primary,
                          iconBg: AppColors.primary.withValues(alpha: .2),
                          value: '12',
                          title: 'organization.home.dashboard.active_events'
                              .tr(),
                        ),

                        _buildStatCard(
                          context,

                          icon: AppIcons.completed,
                          iconColor: AppColors.green,
                          iconBg: AppColors.green.withValues(alpha: .2),
                          value: '48',
                          title: 'organization.home.dashboard.completed'.tr(),
                        ),

                        _buildStatCard(
                          context,

                          icon: AppIcons.community,
                          iconColor: AppColors.laserBlue,
                          iconBg: AppColors.laserBlue.withValues(alpha: .2),
                          value: '1.2K',
                          title: 'organization.home.dashboard.volunteers'.tr(),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSize.getHeight(15)),

                    const OrganizationQuickActionsSection(),

                    SizedBox(height: AppSize.getHeight(15)),

                    // OrganizationYourActiveEventsSection(cubit: _cubit),
                    SizedBox(height: AppSize.getHeight(8)),

                    const OrganizationRecentlyCompletedSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ,

  // );
}

Widget _buildStatCard(
  BuildContext context, {

  required String icon,
  required Color iconColor,
  required Color iconBg,
  required String value,
  required String title,
}) {
  final theme = Theme.of(context);

  return Container(
    width: AppSize.getWidth(100),

    padding: AppSize.padding(all: 10),

    decoration: BoxDecoration(
      color: theme.cardColor,

      borderRadius: BorderRadius.circular(20),

      border: Border.all(
        color: theme.colorScheme.onSurface.withValues(alpha: .08),
      ),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: theme.brightness == Brightness.dark ? .35 : .08,
          ),

          blurRadius: 8,

          offset: const Offset(0, 2),
        ),
      ],
    ),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Container(
          padding: AppSize.padding(all: 8),

          decoration: BoxDecoration(shape: BoxShape.circle, color: iconBg),

          child: CustomIcon(
            icon: icon,

            color: iconColor,

            width: AppSize.getSize(20),

            height: AppSize.getSize(20),
          ),
        ),

        SizedBox(height: AppSize.getHeight(5)),

        Text(
          value,

          style: TextStyle(
            fontSize: AppSize.font(20),

            fontWeight: FontWeight.w500,

            color: theme.colorScheme.onSurface,
          ),
        ),

        Text(
          title,

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: AppSize.font(10),

            fontWeight: FontWeight.w300,

            color: theme.colorScheme.onSurface.withValues(alpha: .6),
          ),
        ),
      ],
    ),
  );
}

// }
