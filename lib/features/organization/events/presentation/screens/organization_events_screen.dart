import 'package:sanad_app/core/shared/widgets/custom_selectable_chips.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../volunteer/home/presentation/widgets/volunteer_home_appbar_widget.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../cards/organization_events_card.dart';

class OrganizationEventsScreen extends StatelessWidget {
  const OrganizationEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VolunteerHomeAppbarWidget(),
              SizedBox(height: AppSize.getHeight(15)),
              Padding(
                padding: AppSize.padding(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'organization.events.title'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(22),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(8)),
                    Text(
                      'organization.events.desc'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(20)),
                    CustomButton(
                      onTap: () {},
                      title: 'organization.events.create_event_button'.tr(),
                      bgColor: AppColors.laserBlue,
                      height: AppSize.getHeight(50),
                      icon: AppIcons.add,
                    ),
                    SizedBox(height: AppSize.getHeight(15)),
                    CustomSelectableChips(
                      multiSelect: false,
                      selectedColor: AppColors.laserBlue,
                      borderColor: Colors.transparent,
                      items: [
                        'organization.events.filter.all'.tr(),
                        'organization.events.filter.upcoming'.tr(),
                        'organization.events.filter.in_progress'.tr(),
                        'organization.events.filter.completed'.tr(),
                      ],
                    ),
                    SizedBox(height: AppSize.getHeight(20)),
                    OrganizationEventsCard(),
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
