import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/features/organization/events/data/models/organization_event_details_model.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_progress_bar.dart';
import '../../../../../core/style/app_colors.dart';

class OrganizationEventsCard extends StatelessWidget {
  const OrganizationEventsCard({
    super.key,
    this.event,
    this.isLoading = false,
    this.onQrTap,
    this.onChatTap,
    this.onEditTap,
    this.onDeleteTap,
  });

  final OrganizationEventDetailsModel? event;
  final bool isLoading;

  final VoidCallback? onQrTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;

  String _getStatusText(String? status) {
    switch (status) {
      case "upcoming":
        return "organization.events.filter.upcoming".tr();
      case "completed":
        return "organization.events.filter.completed".tr();
      case "ongoing":
        return "organization.events.filter.in_progress".tr();
      case "draft":
        return "organization.events.filter.drafted".tr();
      default:
        return "organization.events.filter.upcoming".tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final textColor = theme.colorScheme.onSurface;

    final secondaryColor = textColor.withValues(alpha: .5);

    final name = event?.name ?? "organization.create_event.event_name".tr();

    final description =
        event?.description ??
            "organization.create_event.event_description_will_appear_here".tr();

    final category =
        event?.category ?? "organization.create_event.event_category".tr();

    final status = _getStatusText(event?.status);

    final attendeesCount = event?.attendees ?? 0;

    final spots = event?.spots ?? 100;

    final progress = spots == 0 ? 0.0 : attendeesCount / spots;

    final date = event?.date;

    final location = event?.location != null
        ? event!.location.toString()
        : "organization.create_event.location".tr();

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: .4)
                : AppColors.black.withValues(alpha: .15),

            blurRadius: 8,
          ),
        ],
      ),

      child: Padding(
        padding: AppSize.padding(all: 15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppSize.font(20),
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ),

                Container(
                  padding: AppSize.padding(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    status,
                    style: TextStyle(
                      color: _statusColor(status),
                      fontSize: AppSize.font(12),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSize.getHeight(5)),

            Container(
              padding: AppSize.padding(vertical: 3, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: AppSize.font(12),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: AppSize.getHeight(10)),

            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppSize.font(15),
                color: secondaryColor,
              ),
            ),

            SizedBox(height: AppSize.getHeight(10)),

            Row(
              children: [
                CustomIcon(
                  icon: AppIcons.calendar,
                  width: AppSize.getWidth(16),
                  height: AppSize.getHeight(16),
                  color: secondaryColor,
                ),

                SizedBox(width: AppSize.getWidth(5)),

                Text(
                  date != null
                      ? DateFormat('dd MMM yyyy • hh:mm a').format(date)
                      : "20 Jul 2026 • 10:00 AM",
                  style: TextStyle(
                    fontSize: AppSize.font(14),
                    color: secondaryColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSize.getHeight(3)),

            Row(
              children: [
                CustomIcon(
                  icon: AppIcons.location,
                  width: AppSize.getWidth(16),
                  height: AppSize.getHeight(16),
                  color: secondaryColor,
                ),

                SizedBox(width: AppSize.getWidth(5)),

                Expanded(
                  child: Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppSize.font(14),
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSize.getHeight(10)),

            Row(
              children: [
                Text(
                  'organization.events.volunteers'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(14),
                    color: secondaryColor,
                  ),
                ),

                const Spacer(),

                Text(
                  '$attendeesCount / $spots',
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSize.getHeight(6)),

            CustomProgressBar(
              percent: progress.clamp(0, 1),
              color: AppColors.primary,
              height: AppSize.getHeight(6),
            ),

            SizedBox(height: AppSize.getHeight(15)),

            Row(
              children: [
                Expanded(
                  child: _buildEventAction(
                    onTap: onQrTap,
                    backgroundColor: AppColors.laserBlue.withValues(alpha: .1),
                    iconColor: AppColors.laserBlue,
                    icon: AppIcons.qr,
                    title: 'organization.events.qr_code'.tr(),
                  ),
                ),

                SizedBox(width: AppSize.getWidth(8)),

                Expanded(
                  child: _buildEventAction(
                    onTap: onChatTap,
                    backgroundColor: AppColors.primary.withValues(alpha: .1),
                    iconColor: AppColors.primary,
                    icon: AppIcons.chat,
                    title: 'organization.events.chat'.tr(),
                  ),
                ),

                SizedBox(width: AppSize.getWidth(8)),

                Expanded(
                  child: _buildEventAction(
                    onTap: onEditTap,
                    backgroundColor: AppColors.grey600.withValues(alpha: .1),
                    iconColor: AppColors.grey500,
                    icon: AppIcons.edit,
                    title: 'organization.events.edit'.tr(),
                  ),
                ),

                SizedBox(width: AppSize.getWidth(8)),

                Expanded(
                  child: _buildEventAction(
                    onTap: onDeleteTap,
                    backgroundColor: AppColors.red.withValues(alpha: .1),
                    iconColor: AppColors.red,
                    icon: AppIcons.delete,
                    title: 'organization.events.delete'.tr(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "upcoming":
        return AppColors.laserBlue;

      case "completed":
        return AppColors.primary;

      case "ongoing":
        return AppColors.bronze;

      case "draft":
        return AppColors.primary;

      default:
        return AppColors.primary;
    }
  }

  Widget _buildEventAction({
    required String icon,
    required String title,
    required Color iconColor,
    required Color backgroundColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: AppSize.getHeight(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(
              icon: icon,
              color: iconColor,
              width: AppSize.getSize(22),
              height: AppSize.getSize(22),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: AppSize.font(10),
                fontWeight: FontWeight.w500,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
