import 'package:sanad_app/core/network/local/cache/cache_helper.dart';
import 'package:sanad_app/core/shared/widgets/custom_search_field.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../shared/chat/data/models/chat_model.dart';
import '../../../../shared/chat/presentation/screens/chat_screen.dart';
import '../../data/models/organization_event_details_model.dart';
import '../controllers/organization_events_cubit.dart';
import '../dialogs/organization_publish_dialog.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../cards/organization_events_card.dart';
import 'organization_event_form_screen.dart';
import 'organization_qr_code_screen.dart';

class OrganizationEventsScreen extends StatefulWidget {
  const OrganizationEventsScreen({super.key});

  @override
  State<OrganizationEventsScreen> createState() =>
      _OrganizationEventsScreenState();
}

class _OrganizationEventsScreenState extends State<OrganizationEventsScreen> {
  late final OrganizationEventsCubit _cubit;
  late final ScrollController _scrollController;

  bool upcoming = false;
  bool ongoing = false;
  bool completed = false;
  bool draft = false;

  @override
  void initState() {
    super.initState();
    _cubit = OrganizationEventsCubit.get(context);

    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getOrganizationEvents();
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
    super.dispose();
  }

  void _openForm({OrganizationEventDetailsModel? event}) {
    if (event == null && _cubit.isEditMode) {
      _cubit.resetForm();
    }

    AppNavigator.push(
      BlocProvider.value(
        value: _cubit,
        child: OrganizationEventFormScreen(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return BlocBuilder<OrganizationEventsCubit, OrganizationEventsState>(
      bloc: _cubit,
      builder: (context, state) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await _cubit.getOrganizationEvents(
              refresh: true,
              statuses: _cubit.selectedStatuses,
            );
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: AppSize.padding(horizontal: 12, vertical: 15),
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

                      Row(
                        children: [
                          Expanded(
                            child: CustomSearchField(
                              controller: _cubit.searchController,
                              hint: 'organization.events.search'.tr(),
                              borderColor: AppColors.grey300,
                              borderRadius: 20,
                              borderWidth: 1,
                              onChanged: _cubit.onSearchChanged,
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
                                BorderSide(color: AppColors.grey300, width: 1),
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
                                    final statuses = <String>[];

                                    if (upcoming) statuses.add('upcoming');
                                    if (ongoing) statuses.add('ongoing');
                                    if (completed) statuses.add('completed');
                                    if (draft) statuses.add('draft');

                                    _cubit.getOrganizationEvents(
                                      refresh: true,
                                      statuses: statuses.isEmpty
                                          ? null
                                          : statuses,
                                    );
                                  }

                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: AppSize.getWidth(280),
                                      maxHeight: AppSize.getHeight(380),
                                    ),
                                    child: SingleChildScrollView(
                                      primary: false,
                                      padding: AppSize.padding(all: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: Text(
                                              'organization.events.filter.title'
                                                  .tr(),
                                              style: TextStyle(
                                                fontSize: AppSize.font(15),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          buildFilterItem(
                                            title:
                                                'organization.events.filter.upcoming'
                                                    .tr(),
                                            selected: upcoming,
                                            onTap: () {
                                              menuSetState(() {
                                                upcoming = !upcoming;
                                              });
                                              applyFilters();
                                            },
                                          ),
                                          buildFilterItem(
                                            title:
                                                'organization.events.filter.in_progress'
                                                    .tr(),
                                            selected: ongoing,
                                            onTap: () {
                                              menuSetState(() {
                                                ongoing = !ongoing;
                                              });
                                              applyFilters();
                                            },
                                          ),
                                          buildFilterItem(
                                            title:
                                                'organization.events.filter.completed'
                                                    .tr(),
                                            selected: completed,
                                            onTap: () {
                                              menuSetState(() {
                                                completed = !completed;
                                              });
                                              applyFilters();
                                            },
                                          ),
                                          buildFilterItem(
                                            title:
                                                'organization.events.filter.drafted'
                                                    .tr(),
                                            selected: draft,
                                            onTap: () {
                                              menuSetState(() {
                                                draft = !draft;
                                              });
                                              applyFilters();
                                            },
                                          ),
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
                            padding: AppSize.padding(
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
                            onChatTap: () => AppNavigator.push(
                              ChatScreen(
                                eventId: event.id,
                                currentUserId: CacheHelper.get(
                                  CacheKeys.profileId,
                                ),
                                event: event.toChatEvent(),
                              ),
                            ),
                            onQrTap: () => AppNavigator.push(
                              OrganizationQrCodeScreen(event: event),
                            ),
                            onPublishTap: () {
                              AppNavigator.dialog(
                                OrganizationPublishDialog(
                                  event: event,
                                  loading: state is Loading,
                                  onPublish: (date) {
                                    _cubit.publishOrganizationEvent(
                                      id: event.id,
                                      date: date,
                                    );
                                  },
                                  onEditFullEvent: () {
                                    _openForm(event: event);
                                  },
                                ),
                              );
                            },
                            onEditTap: () {
                              _openForm(event: event);
                            },
                            onDeleteTap: () {
                              final eventId = event.id;
                              AppNavigator.dialog(
                                ConfirmDialog(
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
        padding: AppSize.padding(horizontal: 14, vertical: 12),
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
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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
