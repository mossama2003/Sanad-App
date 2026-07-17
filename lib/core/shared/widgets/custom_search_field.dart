import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hint,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hint;

  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final radius = borderRadius ?? 15;

    final textColor = theme.colorScheme.onSurface;

    final hintColor = isDark
        ? AppColors.white.withValues(alpha: 0.5)
        : AppColors.black.withValues(alpha: 0.5);

    final iconColor = isDark
        ? AppColors.white.withValues(alpha: 0.7)
        : AppColors.grey400;

    return TextField(
      controller: controller,
      onChanged: onChanged,

      style: TextStyle(fontSize: AppSize.font(14), color: textColor),

      decoration: InputDecoration(
        hintText: hint ?? 'Search...',

        hintStyle: TextStyle(fontSize: AppSize.font(14), color: hintColor),

        prefixIcon: Icon(
          Icons.search,
          size: AppSize.getSize(25),
          color: iconColor,
        ),

        filled: true,

        fillColor: theme.cardColor,

        contentPadding: AppSize.padding(vertical: AppSize.getHeight(14)),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 0,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 0,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.primary,
            width: borderWidth ?? 1,
          ),
        ),
      ),
    );
  }
}
