import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_svg.dart';
import '../../../../../core/style/app_colors.dart';

enum VolunteerHomeNavbarItem { home, events, community, donations, cases }

extension VolunteerHomeNavbarItemExt on VolunteerHomeNavbarItem {
  String get icon {
    switch (this) {
      case VolunteerHomeNavbarItem.home:
        return AppIcons.home;
      case VolunteerHomeNavbarItem.events:
        return AppIcons.events;
      case VolunteerHomeNavbarItem.community:
        return AppIcons.community;
      case VolunteerHomeNavbarItem.donations:
        return AppIcons.donations;
      case VolunteerHomeNavbarItem.cases:
        return AppIcons.cases;
    }
  }

  String get label {
    switch (this) {
      case VolunteerHomeNavbarItem.home:
        return 'volunteer.home.navbar.home'.tr();
      case VolunteerHomeNavbarItem.events:
        return 'volunteer.home.navbar.events'.tr();
      case VolunteerHomeNavbarItem.community:
        return 'volunteer.home.navbar.community'.tr();
      case VolunteerHomeNavbarItem.donations:
        return 'volunteer.home.navbar.donations'.tr();
      case VolunteerHomeNavbarItem.cases:
        return 'volunteer.home.navbar.cases'.tr();
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
