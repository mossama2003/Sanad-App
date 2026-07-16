import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class PastRolesCard extends StatefulWidget {
  const PastRolesCard({super.key});

  @override
  State<PastRolesCard> createState() => _PastRolesCardState();
}

class _PastRolesCardState extends State<PastRolesCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;

    final secondaryTextColor = isDark ? AppColors.grey400 : AppColors.grey700;

    final lightTextColor = isDark ? AppColors.grey500 : AppColors.grey500;

    final itemBackground = isDark
        ? AppColors.grey900.withValues(alpha: .25)
        : AppColors.grey100;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: textColor.withValues(alpha: .15), width: .7),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .3 : .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      padding: AppSize.padding(all: 15),

      child: Column(
        children: [
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.starOutlined,
                color: AppColors.gold,
                width: AppSize.getSize(18),
                height: AppSize.getSize(18),
              ),

              SizedBox(width: AppSize.getWidth(5)),

              Text(
                'volunteer.profile.past_roles'.tr(),

                style: TextStyle(
                  color: textColor,
                  fontSize: AppSize.font(15),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(16)),

          Text(
            'volunteer.profile.past_roles_desc'.tr(),

            style: TextStyle(
              color: secondaryTextColor,
              fontSize: AppSize.font(12),
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: AppSize.getHeight(16)),

          _RoleItem(
            background: itemBackground,
            tag: 'volunteer.profile_removed.team_lead'.tr(),
            title: 'volunteer.profile_removed.beach_cleanup'.tr(),
            date: 'volunteer.profile_removed.event_date1'.tr(),
            textColor: textColor,
            lightTextColor: lightTextColor,
          ),

          SizedBox(height: AppSize.getHeight(10)),

          _RoleItem(
            background: itemBackground,
            tag: 'volunteer.profile_removed.first_aid'.tr(),
            title: 'volunteer.profile_removed.blood_donation'.tr(),
            date: 'volunteer.profile_removed.event_date2'.tr(),
            textColor: textColor,
            lightTextColor: lightTextColor,
          ),
        ],
      ),
    );
  }
}

class _RoleItem extends StatelessWidget {
  final Color background;
  final String tag;
  final String title;
  final String date;
  final Color textColor;
  final Color lightTextColor;

  const _RoleItem({
    required this.background,
    required this.tag,
    required this.title,
    required this.date,
    required this.textColor,
    required this.lightTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: AppSize.padding(vertical: 15, horizontal: 15),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: AppSize.padding(vertical: 5, horizontal: 13),
            child: Text(
              tag,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: AppSize.font(12),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(width: AppSize.getWidth(10)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: AppSize.font(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(2)),

                Text(
                  date,
                  style: TextStyle(
                    color: lightTextColor,
                    fontSize: AppSize.font(12),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
