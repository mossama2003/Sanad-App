import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/shared/widgets/custom_selectable_chips.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../home/presentation/widgets/volunteer_home_appbar_widget.dart';
import '../../../../../core/shared/widgets/custom_search_field.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../dialogs/volunteer_events_bottom_sheet.dart';
import '../controllers/volunteer_events_cubit.dart';
import '../cards/volunteer_events_card.dart';

class VolunteerEventsScreen extends StatefulWidget {
  const VolunteerEventsScreen({super.key});

  @override
  State<VolunteerEventsScreen> createState() => _VolunteerEventsScreenState();
}

class _VolunteerEventsScreenState extends State<VolunteerEventsScreen> {
  late final VolunteerEventsCubit _cubit;
  late final ScrollController _scrollController;

  final Set<String> selectedCategories = {};

  bool upcoming = false;
  bool ongoing = false;
  bool completed = false;

  String selectedSort = 'soonest';

  bool mostAvailableSpots = false;

  @override
  void initState() {
    super.initState();

    _cubit = VolunteerEventsCubit.get(context);

    _scrollController = ScrollController()..addListener(_onScroll);
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
                  categories: _cubit.selectedCategories,
                  nearByFilter: _cubit.nearBy,
                  startDate: _cubit.dateAfter,
                  endDate: _cubit.dateBefore,
                  ordering: _cubit.selectedOrdering,
                  mostAvailableSpots: _cubit.mostAvailableSpots,
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

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    CustomSearchField(
                                      controller: _cubit.searchController,
                                      hint: 'volunteer.events.search'.tr(),
                                      borderColor: AppColors.grey300,
                                      borderRadius: 20,
                                      borderWidth: 1,
                                      onChanged: _cubit.onSearchChanged,
                                    ),
                                    SizedBox(height: AppSize.getHeight(10)),
                                    CustomSelectableChips(
                                      multiSelect: true,
                                      initialSelected: [
                                        if (_cubit.nearBy)
                                          'volunteer.events.filter.near_me'
                                              .tr(),

                                        if (_cubit.thisWeek)
                                          'volunteer.events.filter.this_week'
                                              .tr(),
                                      ],
                                      items: [
                                        'volunteer.events.filter.near_me'.tr(),
                                        'volunteer.events.filter.this_week'
                                            .tr(),
                                      ],
                                      onChanged: (selected) {
                                        _cubit.updateQuickFilters(
                                          nearMe: selected.contains(
                                            'volunteer.events.filter.near_me'
                                                .tr(),
                                          ),
                                          thisWeekFilter: selected.contains(
                                            'volunteer.events.filter.this_week'
                                                .tr(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: AppSize.getWidth(10)),

                              MenuAnchor(
                                style: MenuStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    theme.cardColor,
                                  ),
                                  elevation: const WidgetStatePropertyAll(6),
                                  padding: const WidgetStatePropertyAll(
                                    EdgeInsets.zero,
                                  ),
                                  side: WidgetStatePropertyAll(
                                    BorderSide(
                                      color: AppColors.grey300,
                                      width: 1,
                                    ),
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),

                                menuChildren: [
                                  StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      void applyFilters() {
                                        DateTime? startDate;
                                        DateTime? endDate;

                                        if (_cubit.thisWeek) {
                                          final now = DateTime.now();

                                          startDate = DateTime(
                                            now.year,
                                            now.month,
                                            now.day,
                                          );

                                          endDate = startDate.add(
                                            const Duration(days: 6),
                                          );
                                        }

                                        _cubit.getVolunteerEvents(
                                          refresh: true,

                                          status: _cubit.selectedStatus,

                                          categories: selectedCategories,

                                          nearByFilter: _cubit.nearBy,

                                          startDate: startDate,

                                          endDate: endDate,

                                          searchText: _cubit.search,

                                          ordering: selectedSort == 'popular'
                                              ? 'popular'
                                              : null,

                                          mostAvailableSpots:
                                              mostAvailableSpots,
                                        );
                                      }

                                      return ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: AppSize.getWidth(280),
                                          maxHeight: AppSize.getHeight(380),
                                        ),

                                        child: SingleChildScrollView(
                                          padding: AppSize.padding(all: 16),
                                          primary: false,

                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'volunteer.events.filter.sort_by'
                                                    .tr(),
                                                style: TextStyle(
                                                  fontSize: AppSize.font(15),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),

                                              buildFilterItem(
                                                title:
                                                    'volunteer.events.filter.soonest_first'
                                                        .tr(),

                                                selected:
                                                    selectedSort == 'soonest',

                                                onTap: () {
                                                  menuSetState(() {
                                                    selectedSort = 'soonest';
                                                    mostAvailableSpots = false;
                                                  });

                                                  applyFilters();
                                                },
                                              ),

                                              buildFilterItem(
                                                title:
                                                    'volunteer.events.filter.most_spots_available'
                                                        .tr(),

                                                selected:
                                                    selectedSort == 'available',

                                                onTap: () {
                                                  menuSetState(() {
                                                    selectedSort = 'available';
                                                    mostAvailableSpots = true;
                                                  });

                                                  applyFilters();
                                                },
                                              ),

                                              buildFilterItem(
                                                title:
                                                    'volunteer.events.filter.most_popular'
                                                        .tr(),

                                                selected:
                                                    selectedSort == 'popular',

                                                onTap: () {
                                                  menuSetState(() {
                                                    selectedSort = 'popular';
                                                    mostAvailableSpots = false;
                                                  });

                                                  applyFilters();
                                                },
                                              ),

                                              const Divider(thickness: .2),

                                              Text(
                                                'volunteer.events.filter.quick_filters'
                                                    .tr(),
                                                style: TextStyle(
                                                  fontSize: AppSize.font(15),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),

                                              buildFilterItem(
                                                title:
                                                    'volunteer.events.filter.near_me'
                                                        .tr(),
                                                selected: _cubit.nearBy,
                                                onTap: () {
                                                  _cubit.updateQuickFilters(
                                                    nearMe: !_cubit.nearBy,
                                                    thisWeekFilter:
                                                        _cubit.thisWeek,
                                                  );

                                                  menuSetState(() {});
                                                },
                                              ),

                                              buildFilterItem(
                                                title:
                                                    'volunteer.events.filter.this_week'
                                                        .tr(),
                                                selected: _cubit.thisWeek,
                                                onTap: () {
                                                  menuSetState(() {
                                                    _cubit.thisWeek =
                                                        !_cubit.thisWeek;
                                                  });

                                                  applyFilters();
                                                },
                                              ),
                                              const Divider(thickness: .2),

                                              Text(
                                                'volunteer.events.filter.category'
                                                    .tr(),
                                                style: TextStyle(
                                                  fontSize: AppSize.font(15),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),

                                              ..._cubit.eventCategories.map((
                                                category,
                                              ) {
                                                final selected =
                                                    selectedCategories.contains(
                                                      category,
                                                    );

                                                return buildFilterItem(
                                                  title: _cubit
                                                      .categoryTranslations[category]!,
                                                  selected: selected,
                                                  onTap: () {
                                                    menuSetState(() {
                                                      if (selectedCategories
                                                          .contains(category)) {
                                                        selectedCategories
                                                            .remove(category);
                                                      } else {
                                                        selectedCategories.add(
                                                          category,
                                                        );
                                                      }
                                                    });

                                                    applyFilters();
                                                  },
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],

                                builder: (context, controller, child) {
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      controller.isOpen
                                          ? controller.close()
                                          : controller.open();
                                    },
                                    child: Container(
                                      width: AppSize.getSize(48),
                                      height: AppSize.getSize(48),

                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.grey300,
                                        ),
                                      ),

                                      child: Center(
                                        child: CustomIcon(
                                          icon: AppIcons.filter,
                                          color: AppColors.primary,
                                          width: AppSize.getSize(20),
                                          height: AppSize.getSize(20),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: AppSize.getHeight(15)),

                          Text(
                            'volunteer.events.showing_events'.tr(
                              namedArgs: {
                                'count': _cubit.filteredEvents.length
                                    .toString(),
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

                  if (_cubit.filteredEvents.isEmpty)
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
                            if (index == _cubit.filteredEvents.length) {
                              return Padding(
                                padding: AppSize.padding(vertical: 20),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final event = _cubit.filteredEvents[index];

                            return Padding(
                              padding: AppSize.padding(bottom: 15),
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
                                              title:
                                                  'volunteer.events.leave_title'
                                                      .tr(),
                                              message:
                                                  'volunteer.events.leave_message'
                                                      .tr(),
                                              confirmText:
                                                  'volunteer.events.leave_confirm'
                                                      .tr(),
                                              cancelText: 'core.cancel'.tr(),
                                              isDestructive: true,
                                              onConfirm: () {
                                                _cubit.leaveEvent(event.id);
                                                AppNavigator.pop();
                                              },
                                            ),
                                          );
                                        } else {
                                          AppNavigator.pop();
                                          _cubit.joinEvent(event.id);
                                        }
                                      },
                                    ),
                                  );
                                },
                                onJoinTap: () {
                                  if (event.joined) {
                                    AppNavigator.dialog(
                                      ConfirmDialog(
                                        title: 'volunteer.events.leave_title'
                                            .tr(),
                                        message:
                                            'volunteer.events.leave_message'
                                                .tr(),
                                        confirmText:
                                            'volunteer.events.leave_confirm'
                                                .tr(),
                                        cancelText: 'core.cancel'.tr(),
                                        isDestructive: true,
                                        onConfirm: () {
                                          _cubit.leaveEvent(event.id);
                                        },
                                      ),
                                    );
                                  } else {
                                    _cubit.joinEvent(event.id);
                                  }
                                },
                              ),
                            );
                          },
                          childCount:
                              _cubit.filteredEvents.length +
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

  Widget buildFilterItem({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: AppSize.padding(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.grey200 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppSize.font(14),
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: selected ? 1 : 0,
              child: CustomIcon(
                icon: AppIcons.check,
                color: AppColors.primary,
                width: AppSize.getSize(18),
                height: AppSize.getSize(18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
