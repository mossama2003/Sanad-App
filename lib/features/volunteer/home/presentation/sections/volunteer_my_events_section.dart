import 'package:sanad_app/features/volunteer/events/presentation/cards/volunteer_events_card.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../events/presentation/dialogs/volunteer_events_bottom_sheet.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../data/enums/volunteer_home_navbar_enum.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../controllers/volunteer_home_cubit.dart';
import '../../../../../core/constant/app_size.dart';

class VolunteerMyEventsSection extends StatelessWidget {
  const VolunteerMyEventsSection({super.key, required this.cubit});

  final VolunteerHomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;
    final secondaryColor = textColor.withValues(alpha: .6);

    final myEvents =
    (cubit.home?.activeEvents ?? [])
        .where(
          (e) =>
      e.joined &&
          (e.status == 'ongoing' || e.status == 'upcoming'),
    )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return Column(
      children: [
        // Header
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'volunteer.home.my_events.title'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(18),
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),

                Text(
                  'volunteer.home.my_events.title_desc'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    fontWeight: FontWeight.w300,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),

            const Spacer(),

            GestureDetector(
              onTap: () {
                cubit.updateSelectedNavbarItem(
                  VolunteerHomeNavbarItem.events,
                );
              },
              child: Row(
                children: [
                  Text(
                    'volunteer.home.my_events.find_more'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(12),
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),

                  CustomIcon(
                    icon: AppIcons.rightArrow,
                    color: textColor,
                    width: AppSize.getSize(20),
                    height: AppSize.getSize(20),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: AppSize.getHeight(12)),

        // Empty State
        if (myEvents.isEmpty)
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
                  'volunteer.home.my_events.no_events_yet'.tr(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: AppSize.font(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(15)),

                Text(
                  'volunteer.home.my_events.browse_available_events'.tr(),
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
                  title: 'volunteer.home.my_events.browse_events'.tr(),
                  onTap: () {
                    cubit.updateSelectedNavbarItem(
                      VolunteerHomeNavbarItem.events,
                    );
                  },
                ),
              ],
            ),
          )
        // Events List
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: myEvents.length > 2 ? 2 : myEvents.length,
            itemBuilder: (context, index) {
              final event = myEvents[index];

              return Padding(
                padding: AppSize.padding(bottom: 12),
                child: VolunteerEventsCard(
                  event: event,

                  onDetailsTap: () {
                    AppNavigator.sheet(
                      VolunteerEventsBottomSheet(
                        event: event,
                        onJoinTap: () {
                          if (event.joined) {
                            AppNavigator.dialog(
                              ConfirmDialog(
                                title: 'volunteer.events.leave_title'.tr(),
                                message: 'volunteer.events.leave_message'
                                    .tr(),
                                confirmText:
                                'volunteer.events.leave_confirm'.tr(),
                                cancelText: 'core.cancel'.tr(),
                                isDestructive: true,
                                onConfirm: () {
                                  cubit.leaveEvent(event.id);
                                  AppNavigator.pop();
                                },
                              ),
                            );
                          } else {
                            AppNavigator.pop();
                            cubit.joinEvent(event.id);
                          }
                        },
                      ),
                    );
                  },

                  onJoinTap: () {
                    if (event.joined) {
                      AppNavigator.dialog(
                        ConfirmDialog(
                          title: 'volunteer.events.leave_title'.tr(),
                          message: 'volunteer.events.leave_message'.tr(),
                          confirmText: 'volunteer.events.leave_confirm'
                              .tr(),
                          cancelText: 'core.cancel'.tr(),
                          isDestructive: true,
                          onConfirm: () {
                            cubit.leaveEvent(event.id);
                          },
                        ),
                      );
                    } else {
                      cubit.joinEvent(event.id);
                    }
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}
