import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/widgets/custom_search_field.dart';
import '../../../../../core/shared/widgets/custom_selectable_chips.dart';
import '../../../home/presentation/widgets/volunteer_home_appbar_widget.dart';
import '../../data/repos/volunteer_events_repo.dart';
import '../cards/volunteer_events_card.dart';
import '../controllers/volunteer_events_cubit.dart';
import '../dialogs/Volunteer_events_bottom_sheet.dart';

class VolunteerEventsScreen extends StatefulWidget {
  const VolunteerEventsScreen({super.key});

  @override
  State<VolunteerEventsScreen> createState() => _VolunteerEventsScreenState();
}

class _VolunteerEventsScreenState extends State<VolunteerEventsScreen> {
  late final VolunteerEventsCubit _cubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _cubit = VolunteerEventsCubit(VolunteerEventsRepoImpel());

    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.loadEventsFromCache();

      if (_cubit.shouldRefreshEvents()) {
        _cubit.getVolunteerEvents(refresh: false);
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _cubit.loadMoreVolunteerEvents();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return BlocBuilder<VolunteerEventsCubit, VolunteerEventsState>(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,

          body: SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                await _cubit.getVolunteerEvents(
                  refresh: true,
                  status: _cubit.selectedStatus,
                );
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: VolunteerHomeAppbarWidget()),

                  SliverPadding(
                    padding: AppSize.padding(horizontal: 12, top: 15),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'volunteer.events.title'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(22),
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),

                          Text(
                            'volunteer.events.desc'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(15),
                              color: textColor.withValues(alpha: .5),
                            ),
                          ),

                          SizedBox(height: AppSize.getHeight(20)),

                          CustomSearchField(
                            hint: 'volunteer.events.search'.tr(),
                            borderColor: AppColors.grey300,
                            borderRadius: 20,
                            borderWidth: 1,
                          ),

                          SizedBox(height: AppSize.getHeight(15)),

                          CustomSelectableChips(
                            multiSelect: false,
                            initialSelected: [
                              'volunteer.events.filter.all'.tr(),
                            ],
                            selectedColor: AppColors.primary,
                            backgroundColor: Colors.transparent,
                            borderColor: AppColors.primary,
                            items: [
                              'volunteer.events.filter.all'.tr(),
                              'volunteer.events.filter.blood_donation'.tr(),
                              'volunteer.events.filter.environment'.tr(),
                              'volunteer.events.filter.orphanage'.tr(),
                              'volunteer.events.filter.education'.tr(),
                              'volunteer.events.filter.healthcare'.tr(),
                            ],
                            onChanged: (selected) {
                              if (selected.isEmpty) return;

                              final selectedItem = selected.first;

                              String? category;

                              if (selectedItem ==
                                  'volunteer.events.filter.blood_donation'
                                      .tr()) {
                                category = 'Blood Donation';
                              } else if (selectedItem ==
                                  'volunteer.events.filter.environment'.tr()) {
                                category = 'Environment';
                              } else if (selectedItem ==
                                  'volunteer.events.filter.orphanage'.tr()) {
                                category = 'Children Support';
                              } else if (selectedItem ==
                                  'volunteer.events.filter.education'.tr()) {
                                category = 'Education';
                              } else if (selectedItem ==
                                  'volunteer.events.filter.healthcare'.tr()) {
                                category = 'Healthcare';
                              }

                              _cubit.getVolunteerEvents(
                                refresh: true,
                                // category: category,
                              );
                            },
                          ),

                          SizedBox(height: AppSize.getHeight(15)),

                          CustomSelectableChips(
                            multiSelect: true,
                            selectedColor: AppColors.primary,
                            borderColor: AppColors.primary,
                            items: [
                              'volunteer.events.filter.near_me'.tr(),
                              'volunteer.events.filter.this_week'.tr(),
                            ],
                            onChanged: (selected) {
                              // TODO
                            },
                          ),

                          SizedBox(height: AppSize.getHeight(15)),

                          Text(
                            'volunteer.events.showing_events'.tr(
                              namedArgs: {
                                'count': _cubit.events.length.toString(),
                              },
                            ),
                            style: TextStyle(
                              fontSize: AppSize.font(15),
                              color: textColor.withValues(alpha: .5),
                            ),
                          ),

                          SizedBox(height: AppSize.getHeight(20)),
                        ],
                      ),
                    ),
                  ),

                  if (_cubit.events.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'volunteer.events.no_events_found'.tr(),
                          style: TextStyle(
                            color: textColor.withValues(alpha: .5),
                            fontSize: AppSize.font(16),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: AppSize.padding(horizontal: 12),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == _cubit.events.length) {
                              return Padding(
                                padding: AppSize.padding(vertical: 20),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final event = _cubit.events[index];

                            return Padding(
                              padding: AppSize.padding(bottom: 15),
                              child: VolunteerEventsCard(
                                event: event,
                                onDetailsTap: () {
                                  AppNavigator.sheet(
                                    VolunteerEventsBottomSheet(),
                                    // VolunteerEventsBottomSheet(event: event),
                                  );
                                },
                                onJoinTap: () {
                                  // TODO Join Event
                                },
                              ),
                            );
                          },
                          childCount:
                              _cubit.events.length +
                              (_cubit.nextPage != null ? 1 : 0),
                        ),
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
}
