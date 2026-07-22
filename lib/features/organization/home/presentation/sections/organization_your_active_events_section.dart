import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../events/presentation/cards/organization_events_card.dart';
import '../../../events/presentation/controllers/organization_events_cubit.dart';
import '../../../events/presentation/dialogs/organization_publish_dialog.dart';
import '../../../events/presentation/screens/organization_event_form_screen.dart';
import '../../../events/presentation/screens/organization_qr_code_screen.dart';
import '../../data/enums/organization_home_navbar_enum.dart';
import '../controllers/organization_home_cubit.dart';

class OrganizationYourActiveEventsSection extends StatelessWidget {
  const OrganizationYourActiveEventsSection({super.key, required this.cubit});

  final OrganizationEventsCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final activeEvents =
        cubit.events
            .where((e) => e.status == 'ongoing' || e.status == 'upcoming')
            .toList()
          ..sort((a, b) {
            if (a.status == 'ongoing' && b.status != 'ongoing') {
              return -1;
            }

            if (a.status != 'ongoing' && b.status == 'ongoing') {
              return 1;
            }

            return a.date.compareTo(b.date);
          });

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
                OrganizationHomeCubit.get(
                  context,
                ).updateSelectedNavbarItem(OrganizationHomeNavbarItem.events);
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
          Center(
            child: Padding(
              padding: AppSize.padding(vertical: 30),

              child: Text(
                'organization.events.no_events_found'.tr(),

                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: .6),
                  fontSize: AppSize.font(14),
                ),
              ),
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
                              value: cubit,

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
                        value: cubit,

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
