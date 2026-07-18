import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/shared/widgets/custom_search_field.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/shared/widgets/custom_selectable_chips.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../volunteer/home/presentation/widgets/volunteer_home_appbar_widget.dart';
import '../../data/repos/Organization_events_repo.dart';
import '../cards/organization_events_card.dart';
import '../controllers/organization_events_cubit.dart';
import '../forms/create_organization_event_form.dart';

class OrganizationEventsScreen extends StatefulWidget {
  const OrganizationEventsScreen({super.key});

  @override
  State<OrganizationEventsScreen> createState() =>
      _OrganizationEventsScreenState();
}

class _OrganizationEventsScreenState extends State<OrganizationEventsScreen> {
  late final OrganizationEventsCubit _cubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _cubit = OrganizationEventsCubit(OrganizationEventsRepoImpel());

    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getOrganizationEvents(refresh: true, status: null);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _cubit.loadMoreOrganizationEvents();
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

    return BlocBuilder<OrganizationEventsCubit, OrganizationEventsState>(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AppNavigator.push(const CreateOrganizationEventForm());
            },
            backgroundColor: AppColors.primary,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
                // const OrganizationHomeAppbarWidget(),
                const VolunteerHomeAppbarWidget(),

                SizedBox(height: AppSize.getHeight(15)),

                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primary,

                    onRefresh: () async {
                      await _cubit.getOrganizationEvents(
                        refresh: true,
                        status: _cubit.selectedStatus,
                      );
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
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
                              color: textColor.withValues(alpha: .5),
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
                            initialSelected: [
                              'organization.events.filter.all'.tr(),
                            ],
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
                            onChanged: (selected) {
                              if (selected.isEmpty) return;
                              final selectedItem = selected.first;
                              String? status;
                              if (selectedItem ==
                                  'organization.events.filter.upcoming'.tr()) {
                                status = "upcoming";
                              } else if (selectedItem ==
                                  'organization.events.filter.in_progress'
                                      .tr()) {
                                status = "ongoing";
                              } else if (selectedItem ==
                                  'organization.events.filter.completed'.tr()) {
                                status = "completed";
                              } else if (selectedItem ==
                                  'organization.events.filter.drafted'.tr()) {
                                status = "draft";
                              } else {
                                // All
                                status = null;
                              }

                              _cubit.getOrganizationEvents(
                                refresh: true,
                                status: status,
                              );
                            },
                          ),
                          SizedBox(height: AppSize.getHeight(20)),
                          if (state is LoadingEvents && _cubit.events.isEmpty)
                            Skeletonizer(
                              enabled: true,
                              child: Column(
                                children: List.generate(
                                  3,
                                  (_) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: AppSize.getHeight(15),
                                    ),
                                    child: const OrganizationEventsCard(
                                      isLoading: true,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else if (_cubit.events.isEmpty)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: AppSize.getHeight(50),
                                ),
                                child: Text(
                                  'organization.events.no_events_found'.tr(),
                                  style: TextStyle(
                                    color: textColor.withValues(alpha: .5),
                                    fontSize: AppSize.font(16),
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  _cubit.events.length +
                                  (_cubit.nextPage != null ? 1 : 0),
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: AppSize.getHeight(15)),
                              itemBuilder: (context, index) {
                                if (index == _cubit.events.length) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppSize.getHeight(20),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                return OrganizationEventsCard(
                                  event: _cubit.events[index],
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
