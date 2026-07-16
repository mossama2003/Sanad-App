import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../sections/organization_recently_completed_section.dart';
import '../sections/organization_your_active_events_section.dart';
import '../widgets/organization_home_appbar_widget.dart';
import '../widgets/organization_home_dashboard_widget.dart';

class OrganizationHomeScreen extends StatelessWidget {
  const OrganizationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              OrganizationHomeAppbarWidget(),
              SizedBox(height: AppSize.getHeight(15)),
              Padding(
                padding: AppSize.padding(horizontal: 12),
                child: Column(
                  children: [
                    /// Home Dashboard
                    OrganizationHomeDashboardWidget(),
                    SizedBox(height: AppSize.getHeight(15)),
                    OrganizationYourActiveEventsSection(),
                    SizedBox(height: AppSize.getHeight(8)),
                    OrganizationRecentlyCompletedSection(),
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
