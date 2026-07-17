import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_svg.dart';
import '../../../../../core/style/app_colors.dart';

enum OrganizationHomeNavbarItem { home, events, dashboard, donations, cases }

extension OrganizationHomeNavbarItemExt on OrganizationHomeNavbarItem {
  String get icon {
    switch (this) {
      case OrganizationHomeNavbarItem.home:
        return AppIcons.home;
      case OrganizationHomeNavbarItem.events:
        return AppIcons.events;
      case OrganizationHomeNavbarItem.dashboard:
        return AppIcons.dashboard;
      case OrganizationHomeNavbarItem.donations:
        return AppIcons.donations;
      case OrganizationHomeNavbarItem.cases:
        return AppIcons.cases;
    }
  }

  String get label {
    switch (this) {
      case OrganizationHomeNavbarItem.home:
        return 'organization.home.navbar.home'.tr();
      case OrganizationHomeNavbarItem.events:
        return 'organization.home.navbar.events'.tr();
      case OrganizationHomeNavbarItem.dashboard:
        return 'organization.home.navbar.dashboard'.tr();
      case OrganizationHomeNavbarItem.donations:
        return 'organization.home.navbar.donations'.tr();
      case OrganizationHomeNavbarItem.cases:
        return 'organization.home.navbar.cases'.tr();
    }
  }

  BottomNavigationBarItem buildItem(
      bool isSelected,
      ) {
    final isDashboard = this == OrganizationHomeNavbarItem.dashboard;

    return BottomNavigationBarItem(
      label: '',

      icon: Container(
        padding: isDashboard
            ? AppSize.padding(
          horizontal: 14,
          vertical: 12,
        )
            : AppSize.padding(
          horizontal: 10,
          vertical: 6,
        ),

        decoration: BoxDecoration(
          color: isDashboard && isSelected
              ? AppColors.primary
              : isSelected
              ? AppColors.primary.withValues(alpha: 0.10)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(
            isDashboard ? 20 : 14,
          ),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            CustomSvg(
              svg: icon,

              width: isDashboard
                  ? AppSize.getSize(28)
                  : AppSize.getSize(23),

              height: isDashboard
                  ? AppSize.getSize(28)
                  : AppSize.getSize(23),

              color: isDashboard && isSelected
                  ? AppColors.white
                  : isSelected
                  ? AppColors.primary
                  : AppColors.black.withValues(alpha: 0.7),
            ),

            SizedBox(
              height: AppSize.getHeight(4),
            ),

            Text(
              label,

              maxLines: 1,

              softWrap: false,

              overflow: TextOverflow.visible,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: AppSize.font(11),

                color: isDashboard && isSelected
                    ? AppColors.white
                    : isSelected
                    ? AppColors.primary
                    : AppColors.black.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
