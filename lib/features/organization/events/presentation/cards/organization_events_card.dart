import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_progress_bar.dart';
import '../../../../../core/style/app_colors.dart';

class OrganizationEventsCard extends StatefulWidget {
  const OrganizationEventsCard({super.key});

  @override
  State<OrganizationEventsCard> createState() => _OrganizationEventsCardState();
}

class _OrganizationEventsCardState extends State<OrganizationEventsCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = theme.colorScheme.onSurface;

    final secondaryColor = textColor.withValues(alpha: 0.5);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : AppColors.black.withValues(alpha: 0.15),
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
                    'organization.events_remove.beach_cleanup'.tr(),
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
                    color: AppColors.laserBlue.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'organization.events.filter.upcoming'.tr(),
                    style: TextStyle(
                      color: AppColors.laserBlue,
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
                'organization.events.filter.environment'.tr(),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: AppSize.font(12),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: AppSize.getHeight(10)),

            Text(
              'organization.events_remove.beach_cleanup_desc'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(15),
                fontWeight: FontWeight.w400,
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
                  '${'organization.home_removed.date'.tr()} • ${'organization.home_removed.10am'.tr()}',
                  style: TextStyle(
                    fontSize: AppSize.font(14),
                    fontWeight: FontWeight.w400,
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

                Text(
                  'organization.home_removed.cairo_medical_canter'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(14),
                    fontWeight: FontWeight.w400,
                    color: secondaryColor,
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
                    fontWeight: FontWeight.w400,
                    color: secondaryColor,
                  ),
                ),

                const Spacer(),

                Text(
                  'organization.home_removed.45_60'.tr(),
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
              percent: 60,
              color: AppColors.primary,
              height: AppSize.getHeight(6),
            ),

            SizedBox(height: AppSize.getHeight(15)),

            Row(
              children: [
                Expanded(
                  child: _buildEventAction(
                    backgroundColor: AppColors.laserBlue.withValues(alpha: .1),
                    iconColor: AppColors.laserBlue,
                    icon: AppIcons.qr,
                    title: 'organization.events.qr_code'.tr(),
                  ),
                ),

                SizedBox(width: AppSize.getWidth(8)),

                Expanded(
                  child: _buildEventAction(
                    backgroundColor: AppColors.primary.withValues(alpha: .1),
                    iconColor: AppColors.primary,
                    icon: AppIcons.chat,
                    title: 'organization.events.chat'.tr(),
                  ),
                ),

                SizedBox(width: AppSize.getWidth(8)),

                Expanded(
                  child: _buildEventAction(
                    backgroundColor: AppColors.grey600.withValues(alpha: .1),
                    iconColor: AppColors.grey500,
                    icon: AppIcons.edit,
                    title: 'organization.events.edit'.tr(),
                  ),
                ),

                SizedBox(width: AppSize.getWidth(8)),

                Expanded(
                  child: _buildEventAction(
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

  Widget _buildEventAction({
    required String icon,
    required String title,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
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
    );
  }
}
