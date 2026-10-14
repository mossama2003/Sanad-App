import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/models/notification_model.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/notification_repo.dart';
import '../controllers/notification_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>(
      create: (_) =>
      NotificationsCubit(NotificationsRepoImpel())
        ..getAllNotifications(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  Future<void> _refreshNotifications(BuildContext context) async {
    await context.read<NotificationsCubit>().refreshNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final secondaryColor = textColor.withValues(alpha: .6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: AppSize.padding(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'shared.notifications.title'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(22),
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            SizedBox(height: AppSize.getHeight(3)),

            // وصف الصفحة: عدد الإشعارات غير المقروءة
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final unreadCount =
                    context.read<NotificationsCubit>().unreadCount;

                return Text(
                  'shared.notifications.desc'.tr(
                    namedArgs: {
                      'count': unreadCount.toString(),
                    },
                  ),
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.w300,
                    color: secondaryColor,
                  ),
                );
              },
            ),

            SizedBox(height: AppSize.getHeight(12)),

            // Tabs
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final cubit = context.read<NotificationsCubit>();

                return _NotifTabBar(
                  selected: cubit.selectedTab,
                  unreadCount: cubit.unreadCount,
                  onTap: cubit.changeTab,
                );
              },
            ),

            SizedBox(height: AppSize.getHeight(16)),

            // Notifications list
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  final cubit = context.read<NotificationsCubit>();
                  final notifications = cubit.filteredNotifications;

                  if (state is NotificationsLoading &&
                      cubit.notifications.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (state is NotificationsError &&
                      cubit.notifications.isEmpty) {
                    return _NotificationsMessage(
                      icon: Icons.cloud_off_outlined,
                      title: 'shared.notifications.load_error_title'.tr(),
                      message: state.message,
                      actionLabel: 'shared.notifications.retry'.tr(),
                      onAction: () => _refreshNotifications(context),
                    );
                  }

                  if (notifications.isEmpty) {
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => _refreshNotifications(context),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: AppSize.getHeight(100)),
                          _NotificationsMessage(
                            icon: _emptyIcon(cubit.selectedTab),
                            title: _emptyTitle(cubit.selectedTab),
                            message: _emptyDescription(cubit.selectedTab),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => _refreshNotifications(context),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: AppSize.padding(
                        horizontal: 16,
                        bottom: 24,
                      ),
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: AppSize.getHeight(10)),
                      itemBuilder: (context, index) {
                        return _NotificationCard(
                          notification: notifications[index],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _emptyIcon(int tab) {
    switch (tab) {
      case 1:
        return Icons.mark_email_read_outlined;
      case 2:
        return Icons.workspace_premium_outlined;
      case 3:
        return Icons.event_available_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  String _emptyTitle(int tab) {
    switch (tab) {
      case 1:
        return 'shared.notifications.empty_unread_title'.tr();
      case 2:
        return 'shared.notifications.empty_rewards_title'.tr();
      case 3:
        return 'shared.notifications.empty_events_title'.tr();
      default:
        return 'shared.notifications.empty_title'.tr();
    }
  }

  String _emptyDescription(int tab) {
    switch (tab) {
      case 1:
        return 'shared.notifications.empty_unread_desc'.tr();
      case 2:
        return 'shared.notifications.empty_rewards_desc'.tr();
      case 3:
        return 'shared.notifications.empty_events_desc'.tr();
      default:
        return 'shared.notifications.empty_desc'.tr();
    }
  }
}

class _NotificationsMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _NotificationsMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .6);

    return Center(
      child: Padding(
        padding: AppSize.padding(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSize.getSize(76),
              height: AppSize.getSize(76),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSize.getSize(36),
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppSize.getHeight(18)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: AppSize.font(17),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSize.getHeight(8)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryColor,
                fontSize: AppSize.font(13),
                height: 1.5,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSize.getHeight(18)),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel!),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotifTabBar extends StatelessWidget {
  final int selected;
  final int unreadCount;
  final ValueChanged<int> onTap;

  const _NotifTabBar({
    required this.selected,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final surfaceColor = theme.cardColor;

    final tabs = [
      ('shared.notifications.all'.tr(), null),
      ('shared.notifications.unread'.tr(), unreadCount),
      ('shared.notifications.rewards'.tr(), null),
      ('shared.notifications.events'.tr(), null),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: textColor.withValues(alpha: .2), width: .7),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selected == index;
          final (label, badge) = tabs[index];

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: AppSize.padding(vertical: 9, horizontal: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                            ? AppColors.primary.withValues(alpha: .12)
                            : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 1.5)
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppSize.font(11),
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : textColor.withValues(alpha: .6),
                        ),
                      ),
                    ),
                    if (badge != null && badge > 0) ...[
                      SizedBox(width: AppSize.getWidth(4)),
                      Container(
                        padding: AppSize.padding(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$badge',
                          style: TextStyle(
                            fontSize: AppSize.font(10),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationCard({required this.notification});

  Color get _iconBgColor {
    switch (notification.type) {
      case NotificationEnums.badge:
        return const Color(0xFFFFD700).withValues(alpha: .15);
      case NotificationEnums.xp:
        return const Color(0xFF7B2FBE).withValues(alpha: .12);
      case NotificationEnums.urgentCase:
        return const Color(0xFFE05C5C).withValues(alpha: .12);
      case NotificationEnums.event:
        return const Color(0xFF2ECFA0).withValues(alpha: .12);
      case NotificationEnums.general:
        return AppColors.primary.withValues(alpha: .12);
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationEnums.badge:
        return const Color(0xFFB8860B);
      case NotificationEnums.xp:
        return const Color(0xFF7B2FBE);
      case NotificationEnums.urgentCase:
        return const Color(0xFFE05C5C);
      case NotificationEnums.event:
        return const Color(0xFF159B78);
      case NotificationEnums.general:
        return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (notification.type) {
      case NotificationEnums.badge:
        return Icons.workspace_premium_outlined;
      case NotificationEnums.xp:
        return Icons.bolt;
      case NotificationEnums.urgentCase:
        return Icons.warning_amber_outlined;
      case NotificationEnums.event:
        return Icons.calendar_month_outlined;
      case NotificationEnums.general:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;
    final secondaryColor = textColor.withValues(alpha: isDark ? .6 : .65);

    return Container(
      padding: AppSize.padding(all: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withValues(alpha: isDark ? .12 : .15),
          width: .7,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .25 : .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSize.getSize(44),
            height: AppSize.getSize(44),
            decoration: BoxDecoration(
              color: _iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, color: _iconColor, size: AppSize.getSize(20)),
          ),
          SizedBox(width: AppSize.getWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: AppSize.font(14),
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (!notification.isRead) ...[
                      SizedBox(width: AppSize.getWidth(8)),
                      Container(
                        width: AppSize.getSize(8),
                        height: AppSize.getSize(8),
                        margin: const EdgeInsets.only(top: 5),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: AppSize.getHeight(4)),
                Text(
                  notification.body,
                  style: TextStyle(
                    fontSize: AppSize.font(12),
                    color: secondaryColor,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.relativeTime,
                        style: TextStyle(
                          fontSize: AppSize.font(11),
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    if (notification.xpAmount != null &&
                        notification.xpAmount! > 0)
                      Container(
                        padding: AppSize.padding(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '+${notification.xpAmount} XP',
                          style: TextStyle(
                            fontSize: AppSize.font(11),
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
