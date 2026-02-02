import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/constant/app_size.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/shared/widgets/custom_svg.dart';

enum HomeNavbarItem { home, events, community, donations, cases }

extension HomeNavbarItemExt on HomeNavbarItem {
  String get icon {
    switch (this) {
      case HomeNavbarItem.home:
        return AppIcons.home;
      case HomeNavbarItem.events:
        return AppIcons.events;
      case HomeNavbarItem.community:
        return AppIcons.community;
      case HomeNavbarItem.donations:
        return AppIcons.donations;
      case HomeNavbarItem.cases:
        return AppIcons.cases;
    }
  }

  String get label {
    switch (this) {
      case HomeNavbarItem.home:
        return 'home.navbar.home'.tr();
      case HomeNavbarItem.events:
        return 'home.navbar.events'.tr();
      case HomeNavbarItem.community:
        return 'home.navbar.community'.tr();
      case HomeNavbarItem.donations:
        return 'home.navbar.donations'.tr();
      case HomeNavbarItem.cases:
        return 'home.navbar.cases'.tr();
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
