import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:sanad_app/core/constant/app_size.dart';

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
