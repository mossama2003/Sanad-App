import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../events/presentation/cards/organization_events_card.dart';
import '../../../events/presentation/dialogs/organization_publish_dialog.dart';
import '../../../events/presentation/screens/organization_event_form_screen.dart';
import '../../../events/presentation/screens/organization_qr_code_screen.dart';
import '../../data/enums/organization_home_navbar_enum.dart';
import '../controllers/organization_home_cubit.dart';

class OrganizationYourActiveEventsSection extends StatelessWidget {
  const OrganizationYourActiveEventsSection({super.key, required this.cubit});

  final OrganizationHomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;
    final secondaryColor = textColor.withValues(alpha: .6);

    final activeEvents = cubit.home?.activeEvents ?? [];

    final displayedEvents = activeEvents.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          children: [
            Text(
              'organization.home.your_active_events.title'.tr(),

              style: TextStyle(
                fontSize: AppSize.font(18),
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const Spacer(),

            GestureDetector(
              onTap: () {
                cubit.updateSelectedNavbarItem(
                  OrganizationHomeNavbarItem.events,
                );
              },
              child: Row(
                children: [
                  Text(
                    'organization.home.your_active_events.see_all'.tr(),

                    style: TextStyle(
                      fontSize: AppSize.font(12),
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(width: AppSize.getWidth(4)),

                  CustomIcon(
                    icon: AppIcons.rightArrow,
                    color: theme.colorScheme.onSurface,
                    width: AppSize.getSize(18),
                    height: AppSize.getSize(18),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: AppSize.getHeight(12)),

        if (displayedEvents.isEmpty)
          Container(
            width: double.infinity,
            padding: AppSize.padding(all: 20),

            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: textColor.withValues(alpha: .12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: theme.brightness == Brightness.dark ? .35 : .12,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),

            child: Column(
              children: [
                Container(
                  height: AppSize.getHeight(40),
                  width: AppSize.getWidth(40),
                  decoration: BoxDecoration(
                    color: textColor.withValues(alpha: .1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIcon(
                      icon: AppIcons.calendar,
                      color: textColor.withValues(alpha: .5),
                      width: AppSize.getSize(20),
                      height: AppSize.getSize(20),
                    ),
                  ),
                ),

                SizedBox(height: AppSize.getHeight(15)),

                Text(
                  'organization.home.your_active_events.no_events_yet'.tr(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: AppSize.font(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(15)),

                Text(
                  'organization.home.your_active_events.description'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: AppSize.font(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(15)),

                CustomButton(
                  width: AppSize.getWidth(140),
                  height: AppSize.getHeight(40),
                  title: 'organization.home.your_active_events.manage_events'
                      .tr(),
                  onTap: () {
                    cubit.updateSelectedNavbarItem(
                      OrganizationHomeNavbarItem.events,
                    );
                  },
                ),
              ],
            ),
          )
        else
          ListView.builder(
            itemCount: displayedEvents.length,

            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),

            itemBuilder: (context, index) {
              final event = displayedEvents[index];

              return Padding(
                padding: AppSize.padding(bottom: 15),

                child: OrganizationEventsCard(
                  event: event,

                  onQrTap: () {
                    AppNavigator.push(OrganizationQrCodeScreen(event: event));
                  },

                  onPublishTap: () {
                    AppNavigator.dialog(
                      OrganizationPublishDialog(
                        event: event,

                        loading: false,

                        onPublish: (date) {
                          cubit.publishOrganizationEvent(
                            id: event.id,
                            date: date,
                          );
                        },

                        onEditFullEvent: () {
                          AppNavigator.push(
                            BlocProvider.value(
                              value: cubit.eventsCubit,

                              child: OrganizationEventFormScreen(event: event),
                            ),
                          );
                        },
                      ),
                    );
                  },

                  onEditTap: () {
                    AppNavigator.push(
                      BlocProvider.value(
                        value: cubit.eventsCubit,

                        child: OrganizationEventFormScreen(event: event),
                      ),
                    );
                  },

                  onDeleteTap: () {
                    AppNavigator.dialog(
                      ConfirmDialog(
                        title: 'organization.events.delete'.tr(),

                        message: 'organization.events.delete_desc'.tr(),

                        confirmText: 'organization.events.delete'.tr(),

                        isDestructive: true,

                        onConfirm: () async {
                          await cubit.deleteOrganizationEvent(id: event.id);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}
