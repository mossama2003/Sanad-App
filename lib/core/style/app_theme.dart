import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constant/app_constants.dart';
import '../network/local/cache/cache_helper.dart';
import 'app_colors.dart';

enum AppThemeEnum { light, dark }

extension AppThemeExtension on AppThemeEnum {
  String get key {
    switch (this) {
      case AppThemeEnum.light:
        return CacheKeys.light;
      case AppThemeEnum.dark:
        return CacheKeys.dark;
    }
  }

  String get name {
    switch (this) {
      case AppThemeEnum.light:
        return 'settings.themes.light'.tr();
      case AppThemeEnum.dark:
        return 'settings.themes.dark'.tr();
    }
  }

  ThemeMode get mode {
    switch (this) {
      case AppThemeEnum.light:
        return ThemeMode.light;
      case AppThemeEnum.dark:
        return ThemeMode.dark;
    }
  }
}

class AppTheme {
  static final ValueNotifier<AppThemeEnum> themeNotifier = ValueNotifier(
    AppThemeEnum.light,
  );

  static Future<void> init() async {
    final theme = CacheHelper.get(CacheKeys.theme) ?? CacheKeys.light;

    themeNotifier.value = theme == CacheKeys.dark
        ? AppThemeEnum.dark
        : AppThemeEnum.light;
  }

  static void setTheme(AppThemeEnum theme) {
    themeNotifier.value = theme;
  }

  // ════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ════════════════════════════════════════════════════════════

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      brightness: Brightness.light,

      primaryColor: AppColors.primary,

      scaffoldBackgroundColor: AppColors.scaffoldBgLight,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,

        secondary: AppColors.secondary,

        surface: AppColors.white,

        error: AppColors.red500,
      ),

      textTheme: base.textTheme.apply(
        fontFamily: AppConstants.fontIBMPlexSansArabic,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.appbarBgLight,

        elevation: 0,

        iconTheme: IconThemeData(color: AppColors.appbarTextLight),
      ),

      dividerColor: AppColors.divider,

      cardColor: AppColors.white,

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,

        fillColor: AppColors.fieldBgLight,

        border: OutlineInputBorder(),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // DARK THEME
  // ════════════════════════════════════════════════════════════

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      brightness: Brightness.dark,

      primaryColor: AppColors.primary,

      scaffoldBackgroundColor: AppColors.scaffoldBgDark,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,

        secondary: AppColors.secondary,

        surface: AppColors.fieldBgDark,

        error: AppColors.red500,
      ),

      textTheme: base.textTheme.apply(
        fontFamily: AppConstants.fontIBMPlexSansArabic,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.appbarBgDark,

        elevation: 0,

        iconTheme: IconThemeData(color: AppColors.appbarTextDark),
      ),

      dividerColor: AppColors.divider,

      cardColor: AppColors.fieldBgDark,

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,

        fillColor: AppColors.fieldBgDark,

        border: OutlineInputBorder(),
      ),
    );
  }
}
