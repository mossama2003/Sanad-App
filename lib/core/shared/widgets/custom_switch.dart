import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key, required this.value, this.onChanged});

  final bool value;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: AppSize.getWidth(44),
      height: AppSize.getHeight(24),
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        // ON state
        activeTrackColor: AppColors.primary.withValues(alpha: .3),
        // OFF state
        inactiveThumbColor: AppColors.white,
        inactiveTrackColor: isDark
            ? AppColors.grey500.withValues(alpha: .5)
            : AppColors.grey500.withValues(alpha: .3),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        thumbColor: value
            ? AppColors.primary
            : (isDark ? AppColors.grey300 : AppColors.white),
      ),
    );
  }
}
