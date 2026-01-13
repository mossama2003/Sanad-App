import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shuaa_alamal/core/style/app_text_style.dart';

import '../constant/app_constants.dart';
import '../constant/app_size.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData appLightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: AppConstants.fontIBMPlexSansArabic,
    primaryColor: AppColors.primary,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: AppColors.scaffoldBgLight,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primary,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      titleSpacing: AppSize.getWidth(16),
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.grey700,
        fontFamily: AppConstants.fontIBMPlexSansArabic,
      ).md,
      backgroundColor: AppColors.appbarBgLight,
      surfaceTintColor: AppColors.appbarBgLight,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness:
            Platform.isIOS ? Brightness.light : Brightness.dark,
        statusBarColor: AppColors.appbarBgLight,
        statusBarIconBrightness:
            Platform.isIOS ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: AppColors.appbarBgLight,
        systemNavigationBarIconBrightness:
            Platform.isIOS ? Brightness.light : Brightness.dark,
      ),
      iconTheme: IconThemeData(color: AppColors.grey600),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 2,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontSize: AppSize.font(12),
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      ),
      type: BottomNavigationBarType.fixed,
      unselectedLabelStyle: TextStyle(
        fontSize: AppSize.font(12),
        fontWeight: FontWeight.w500,
        color: AppColors.navbarUnSelected,
      ),
      backgroundColor: AppColors.navbarBgLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.navbarSelectedDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isDense: true,
      errorMaxLines: 5,
      helperMaxLines: 3,
      isCollapsed: true,
      hintStyle: TextStyle(
        fontSize: AppSize.font(16),
        fontWeight: FontWeight.w500,
        color: AppColors.fieldTextLight,
        fontFamily: AppConstants.fontIBMPlexSansArabic,
      ),
      labelStyle: TextStyle(
        fontSize: AppSize.font(12),
        fontWeight: FontWeight.w400,
        color: AppColors.platinum500,
        fontFamily: AppConstants.fontIBMPlexSansArabic,
      ),
      helperStyle: TextStyle(
        fontSize: AppSize.font(12),
        fontWeight: FontWeight.w400,
        color: AppColors.grey500,
        fontFamily: AppConstants.fontIBMPlexSansArabic,
      ),
      errorStyle: TextStyle(
        color: AppColors.red500,
        fontSize: AppSize.font(12),
        fontWeight: FontWeight.w400,
        fontFamily: AppConstants.fontIBMPlexSansArabic,
      ),
      fillColor: AppColors.fieldBgLight,
      border: _buildFieldBorder(),
      errorBorder: _buildFieldBorder(),
      enabledBorder: _buildFieldBorder(),
      focusedBorder: _buildFieldBorder(),
      focusedErrorBorder: _buildFieldBorder(),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSize.getWidth(14),
        vertical: AppSize.getHeight(10),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.scaffoldBgLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.getSize(12)),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0.0,
    ),
  );
}

InputBorder _buildFieldBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSize.getSize(8)),
    borderSide: BorderSide(color: AppColors.fieldBorderLight),
  );
}
