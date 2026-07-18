import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_svg.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/enums/volunteer_home_navbar_enum.dart';

class VolunteerHomeNavbarWidget extends StatelessWidget {
  const VolunteerHomeNavbarWidget({
    super.key,
    required this.selected,
    required this.onTap,
  });

  final VolunteerHomeNavbarItem selected;
  final ValueChanged<VolunteerHomeNavbarItem> onTap;

  List<VolunteerHomeNavbarItem> get _items => VolunteerHomeNavbarItem.values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;

    final inactiveColor = isDark
        ? AppColors.white.withValues(alpha: 0.65)
        : AppColors.black.withValues(alpha: 0.7);

    final double iconAreaHeight = AppSize.getHeight(40);

    return SafeArea(
      top: false,
      child: Container(
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

            return Expanded(
              child: InkWell(
                onTap: () => onTap(item),
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: iconAreaHeight,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              bottom: AppSize.getHeight(6),
                            ),
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
                            padding: AppSize.padding(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            child: CustomSvg(
                              svg: item.icon,
                              width: AppSize.getSize(20),
                              height: AppSize.getSize(20),
                              color: isSelected
                                  ? AppColors.primary
                                  : inactiveColor,
                            ),
                          ),
                        ],
                      ),
                    ),

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
