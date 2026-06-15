import 'package:sanad_app/features/shared/notification/data/enums/notification_enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTab = 0;

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(
          isRead: true,
        );
      }
    });
  }

  final List<NotificationModel> _notifications = [
    NotificationModel(
      type: NotificationEnums.badge,
      title: 'New Badge Unlocked!',
      body: "You earned the 'Blood Hero' badge for donating blood 5 times.",
      time: '2m ago',
      isRead: false,
      xpAmount: 250,
    ),
    NotificationModel(
      type: NotificationEnums.xp,
      title: 'XP Earned',
      body: 'You received 150 XP for attending Beach Cleanup Drive.',
      time: '1h ago',
      isRead: false,
      xpAmount: 150,
    ),
    NotificationModel(
      type: NotificationEnums.urgentCase,
      title: 'Urgent Case Near You',
      body: 'Blood donation needed at Cairo University Hospital.',
      time: '3h ago',
      isRead: false,
    ),
    NotificationModel(
      type: NotificationEnums.event,
      title: 'Event Reminder',
      body: 'Orphanage Visit starts tomorrow at 2:00 PM.',
      time: '5h ago',
      isRead: true,
    ),
  ];

  List<NotificationModel> get _filtered {
    switch (_selectedTab) {
      case 1:
        return _notifications.where((n) => !n.isRead).toList();
      case 2:
        return _notifications
            .where(
              (n) =>
                  n.type == NotificationEnums.badge ||
                  n.type == NotificationEnums.xp,
            )
            .toList();
      case 3:
        return _notifications
            .where((n) => n.type == NotificationEnums.event)
            .toList();
      default:
        return _notifications;
    }
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
                color: AppColors.black,
              ),
            ),

            SizedBox(height: AppSize.getHeight(3)),

            Text(
              'shared.notifications.desc'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(15),
                fontWeight: FontWeight.w300,
                color: AppColors.black.withValues(alpha: 0.7),
              ),
            ),

            SizedBox(height: AppSize.getHeight(15)),
            // Mark all as read banner
            _MarkAllBanner(
              onTap: _markAllAsRead,
            ),
            SizedBox(height: AppSize.getHeight(12)),

            // Tab bar
            _NotifTabBar(
              selected: _selectedTab,
              unreadCount: _unreadCount,
              onTap: (i) => setState(() => _selectedTab = i),
            ),
            SizedBox(height: AppSize.getHeight(16)),

            // List
            Expanded(
              child: ListView.separated(
                padding: AppSize.padding(horizontal: 16, bottom: 24),
                itemCount: _filtered.length,
                separatorBuilder: (_, _) =>
                    SizedBox(height: AppSize.getHeight(10)),
                itemBuilder: (_, i) =>
                    _NotificationCard(notification: _filtered[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mark All Banner
// ─────────────────────────────────────────────────────────────────────────────
class _MarkAllBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _MarkAllBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: AppSize.padding(horizontal: 16),
        padding: AppSize.padding(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppColors.primary,
              size: AppSize.getSize(16),
            ),
            SizedBox(width: AppSize.getWidth(6)),
            Text(
              'shared.notifications.mark_all_read'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(13),
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab Bar
// ─────────────────────────────────────────────────────────────────────────────
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
    final tabs = [
      ('shared.notifications.all'.tr(), null),
      ('shared.notifications.unread'.tr(), unreadCount),
      ('shared.notifications.rewards'.tr(), null),
      ('shared.notifications.events'.tr(), null),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.2),
          width: 0.7,
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = selected == i;
          final (label, badge) = tabs[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: AppSize.padding(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 1.5)
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: AppSize.font(11),
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : AppColors.grey,
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

// ─────────────────────────────────────────────────────────────────────────────
// Notification Card
// ─────────────────────────────────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationCard({required this.notification});

  Color get _iconBgColor {
    switch (notification.type) {
      case NotificationEnums.badge:
        return const Color(0xFFFFD700).withValues(alpha: 0.15);
      case NotificationEnums.xp:
        return const Color(0xFF7B2FBE).withValues(alpha: 0.12);
      case NotificationEnums.urgentCase:
        return const Color(0xFFE05C5C).withValues(alpha: 0.12);
      case NotificationEnums.event:
        return const Color(0xFF2ECFA0).withValues(alpha: 0.12);
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationEnums.badge:
        return const Color(0xFFFFD700);
      case NotificationEnums.xp:
        return const Color(0xFF7B2FBE);
      case NotificationEnums.urgentCase:
        return const Color(0xFFE05C5C);
      case NotificationEnums.event:
        return const Color(0xFF2ECFA0);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSize.padding(all: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.15),
          width: 0.7,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon circle
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

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: AppSize.font(14),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: AppSize.getSize(8),
                        height: AppSize.getSize(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(4)),
                Text(
                  notification.body,
                  style: TextStyle(
                    fontSize: AppSize.font(12),
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Row(
                  children: [
                    Text(
                      notification.time,
                      style: TextStyle(
                        fontSize: AppSize.font(11),
                        color: AppColors.grey,
                      ),
                    ),
                    const Spacer(),
                    if (notification.xpAmount != null)
                      Container(
                        padding: AppSize.padding(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
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
