import 'package:sanad_app/core/shared/widgets/custom_field_text.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared/widgets/custom_selectable_chips.dart';
import '../../../home/presentation/widgets/volunteer_home_appbar_widget.dart';
import '../cards/events_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool showFilters = false;

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
                      'volunteer.events.title'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(22),
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(3)),
                    Text(
                      'volunteer.events.desc'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w300,
                        color: AppColors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(15)),

                    CustomFieldText(
                      controller: TextEditingController(),
                      bgColor: AppColors.white,
                      iconStart: AppIcons.search,
                      hintText: 'volunteer.events.search'.tr(),
                    ),

                    SizedBox(height: AppSize.getHeight(10)),

                    CustomButton(
                      title: 'volunteer.events.filters'.tr(),
                      onTap: () {
                        setState(() {
                          showFilters = !showFilters;
                        });
                      },
                      icon: AppIcons.filter,
                      bgColor: Colors.transparent,
                      borderColor: AppColors.grey.withValues(alpha: 0.3),
                      textColor: AppColors.black,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: showFilters
                          ? Padding(
                              key: const ValueKey('filters'),
                              padding: EdgeInsets.only(
                                top: AppSize.getHeight(12),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: AppSize.padding(all: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.grey.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                  color: AppColors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Events Type
                                    CustomSelectableChips(
                                      title:
                                          'volunteer.events.filter.type_title'
                                              .tr(),
                                      items: [
                                        'volunteer.events.filter.all'.tr(),
                                        'volunteer.events.filter.blood_donation'
                                            .tr(),
                                        'volunteer.events.filter.orphanage'
                                            .tr(),
                                        'volunteer.events.filter.environment'
                                            .tr(),
                                        'volunteer.events.filter.food_distribution'
                                            .tr(),
                                        'volunteer.events.filter.healthcare'
                                            .tr(),
                                      ],
                                      multiSelect: false,
                                    ),

                                    SizedBox(height: AppSize.getHeight(20)),

                                    /// Events Location
                                    CustomSelectableChips(
                                      title:
                                          'volunteer.events.filter.location_title'
                                              .tr(),
                                      items: [
                                        'volunteer.events.filter.cairo'.tr(),
                                        'volunteer.events.filter.alexandria'
                                            .tr(),
                                        'volunteer.events.filter.giza'.tr(),
                                        'volunteer.events.filter.mansoura'.tr(),
                                        'volunteer.events.filter.aswan'.tr(),
                                        'volunteer.events.filter.luxor'.tr(),
                                      ],
                                      multiSelect: false,
                                    ),

                                    SizedBox(height: AppSize.getHeight(20)),

                                    /// Events Date
                                    CustomSelectableChips(
                                      title:
                                          'volunteer.events.filter.date_title'
                                              .tr(),
                                      items: [
                                        'volunteer.events.filter.today'.tr(),
                                        'volunteer.events.filter.tomorrow'.tr(),
                                        'volunteer.events.filter.this_week'
                                            .tr(),
                                        'volunteer.events.filter.this_month'
                                            .tr(),
                                        'volunteer.events.filter.upcoming'.tr(),
                                      ],
                                      multiSelect: false,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    SizedBox(height: AppSize.getHeight(15)),
                    EventsCard(),
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
