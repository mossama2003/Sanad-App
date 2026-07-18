import 'package:sanad_app/core/shared/widgets/custom_search_field.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared/widgets/custom_selectable_chips.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../home/presentation/widgets/organization_home_appbar_widget.dart';
import '../../data/repos/organization_events_repo.dart';
import '../controllers/organization_events_cubit.dart';
import '../forms/create_organization_event_form.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../cards/organization_events_card.dart';

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
      _cubit.loadEventsFromCache();

      if (_cubit.shouldRefreshEvents()) {
        _cubit.getOrganizationEvents(refresh: false);
      }
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
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                await _cubit.getOrganizationEvents(
                  refresh: true,
                  status: _cubit.selectedStatus,
                );
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: OrganizationHomeAppbarWidget(),
                  ),

                  SliverPadding(
                    padding: AppSize.padding(horizontal: 12, top: 15),
                    sliver: SliverToBoxAdapter(
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
                              }

                              _cubit.getOrganizationEvents(
                                refresh: true,
                                status: status,
                              );
                            },
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
                          'organization.events.no_events_found'.tr(),
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
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSize.getHeight(20),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final event = _cubit.events[index];

                            return Padding(
                              padding: AppSize.padding(bottom: 15),

                              child: OrganizationEventsCard(
                                event: event,

                                onDeleteTap: () {
                                  final eventId = event.id;

                                  showDialog(
                                    context: context,
                                    builder: (_) => ConfirmDialog(
                                      title: 'organization.events.delete'.tr(),
                                      message: 'organization.events.delete_desc'
                                          .tr(),
                                      confirmText: 'organization.events.delete'
                                          .tr(),
                                      isDestructive: true,

                                      onConfirm: () async {
                                        if (!context.mounted) return;
                                        await _cubit.deleteOrganizationEvent(
                                          id: eventId,
                                        );
                                      },
                                    ),
                                  );
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
