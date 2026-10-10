import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_svg.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/enums/organization_home_navbar_enum.dart';

class OrganizationHomeNavbarWidget extends StatelessWidget {
  const OrganizationHomeNavbarWidget({
    super.key,
    required this.selected,
    required this.onTap,
  });

  final OrganizationHomeNavbarItem selected;
  final ValueChanged<OrganizationHomeNavbarItem> onTap;

  List<OrganizationHomeNavbarItem> get _items =>
      OrganizationHomeNavbarItem.values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double topAreaHeight = AppSize.getHeight(40);

    final backgroundColor = theme.scaffoldBackgroundColor;

    final inactiveColor = isDark
        ? AppColors.white.withValues(alpha: 0.65)
        : AppColors.black.withValues(alpha: 0.7);

    return SafeArea(
      top: false,
      child: Container(
        clipBehavior: Clip.none,
        padding: EdgeInsets.only(
          top: AppSize.getHeight(8),
          bottom: AppSize.getHeight(8),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(1.5, 0),
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : AppColors.grey.withValues(alpha: 0.35),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _items.map((item) {
            final isSelected = item == selected;
            final isDashboard = item == OrganizationHomeNavbarItem.dashboard;

            Widget iconArea;

            if (isDashboard) {
              iconArea = SizedBox(
                height: topAreaHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      top: -25,
                      child: Container(
                        padding: AppSize.padding(all: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CustomSvg(
                          svg: item.icon,
                          width: AppSize.getSize(32),
                          height: AppSize.getSize(32),
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              iconArea = SizedBox(
                height: topAreaHeight,
                child: Column(
                  children: [
                    Container(
                      margin: AppSize.margin(bottom: AppSize.getHeight(6)),
                      width: AppSize.getWidth(20),
                      height: AppSize.getHeight(3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      padding: AppSize.padding(horizontal: 8, vertical: 5),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: CustomSvg(
                        svg: item.icon,
                        width: AppSize.getSize(20),
                        height: AppSize.getSize(20),
                        color: isSelected ? AppColors.primary : inactiveColor,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Expanded(
              child: InkWell(
                onTap: () => onTap(item),
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    iconArea,
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: AppSize.font(11),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? AppColors.primary : inactiveColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
