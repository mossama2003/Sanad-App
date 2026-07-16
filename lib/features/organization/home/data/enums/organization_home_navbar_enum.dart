import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_svg.dart';
import '../../../../../core/style/app_colors.dart';

enum OrganizationHomeNavbarItem { home, events, donations, cases }

extension VolunteerHomeNavbarItemExt on OrganizationHomeNavbarItem {
  String get icon {
    switch (this) {
      case OrganizationHomeNavbarItem.home:
        return AppIcons.home;
      case OrganizationHomeNavbarItem.events:
        return AppIcons.events;
      // case OrganizationHomeNavbarItem.community:
      //   return AppIcons.community;
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
      // case OrganizationHomeNavbarItem.community:
      //   return 'home.navbar.community'.tr();
      case OrganizationHomeNavbarItem.donations:
        return 'organization.home.navbar.donations'.tr();
      case OrganizationHomeNavbarItem.cases:
        return 'organization.home.navbar.cases'.tr();
    }
  }

  BottomNavigationBarItem buildItem(bool isSelected) {
    return BottomNavigationBarItem(
      label: '',
      icon: Container(
        padding: AppSize.padding(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSize.getSize(14)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvg(
              svg: icon,
              width: AppSize.getSize(23),
              height: AppSize.getSize(23),
              color: isSelected
                  ? AppColors.primary
                  : AppColors.black.withValues(alpha: 0.7),
            ),
            SizedBox(height: AppSize.getHeight(4)),
            Text(
              label,
              style: TextStyle(
                fontSize: AppSize.font(11),
                color: isSelected
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
