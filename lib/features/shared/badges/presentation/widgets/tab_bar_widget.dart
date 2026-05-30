import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class TabBarWidget extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  final int allCount, earnedCount, inProgressCount;

  const TabBarWidget({
    super.key,
    required this.selected,
    required this.onTap,
    required this.allCount,
    required this.earnedCount,
    required this.inProgressCount,
  });

  @override
  Widget build(BuildContext context) {
    final labels = [
      '${'shared.badges.all'.tr()} ($allCount)',
      '${'shared.badges.earned'.tr()} ($earnedCount)',
      '${'shared.badges.in_progress'.tr()} ($inProgressCount)',
    ];

    return Container(
      padding: AppSize.padding(all: 4),
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.transparent, width: 0.7),
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (i) => Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: Container(
                padding: AppSize.padding(all: 5),
                decoration: BoxDecoration(
                  color: selected == i ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: selected == i
                      ? Border.all(color: AppColors.white, width: 1.5)
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(labels[i]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
