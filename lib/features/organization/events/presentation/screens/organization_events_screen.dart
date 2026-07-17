import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/shared/widgets/custom_search_field.dart';

import '../../../../../core/shared/widgets/custom_selectable_chips.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../volunteer/home/presentation/widgets/volunteer_home_appbar_widget.dart';
import '../cards/organization_events_card.dart';
import '../forms/create_event_form.dart';

class OrganizationEventsScreen extends StatelessWidget {
  const OrganizationEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigator.push(const CreateEventForm()),
        backgroundColor: AppColors.primary,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: CustomIcon(
          icon: AppIcons.add,
          color: AppColors.white,
          width: AppSize.getSize(28),
          height: AppSize.getSize(28),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VolunteerHomeAppbarWidget(),

            // const OrganizationHomeAppbarWidget(),
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
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),

                  Text(
                    'organization.events.desc'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(15),
                      fontWeight: FontWeight.w400,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .5),
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(20)),

                  CustomSearchField(
                    hint: 'organization.events.search'.tr(),
                    borderColor: AppColors.grey300,
                    borderRadius: 20,
                    borderWidth: 1,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomSelectableChips(
                    multiSelect: false,
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.transparent,
                    borderColor: AppColors.primary,
                    items: [
                      'organization.events.filter.all'.tr(),
                      'organization.events.filter.upcoming'.tr(),
                      'organization.events.filter.in_progress'.tr(),
                      'organization.events.filter.completed'.tr(),
                      'organization.events.filter.drafted'.tr(),
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
    );
  }
}
