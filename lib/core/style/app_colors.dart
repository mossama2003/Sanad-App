import 'package:flutter/material.dart';

import '../network/local/cache/cache_helper.dart';

class AppColors {
  AppColors._();

  static bool get isDark => CacheHelper.get(CacheKeys.theme) == CacheKeys.dark;

  /// Brand Colors
  static const Color primary = Color(0xff00B281);
  static const Color secondary = Color(0xffEDFDF5);
  static const Color green = Color(0xff008000);
  static const Color laserBlue = Color(0xff416EFD);
  static const Color red = Color(0xffF72C3D);
  static const Color magenta = Color(0xffED1B72);
  static const Color sportyViolet = Color(0xff8A43DA);
  static const Color selago = Color(0xffF2EBFA);
  static const Color silver = Color(0xffB0B0B0);
  static const Color bronze = Color(0xffCD7F32);
  static const Color gold = Color(0xffFFD700);

  static const Color brand50 = Color(0xffFFF5F9);
  static const Color brand200 = Color(0xffFFB6CF);
  static const Color brand300 = Color(0xffFB9DBE);
  static const Color brand600 = Color(0xffD81F5F);
  static const Color brand700 = Color(0xff851D41);

  static const Color secondary400 = Color(0xffFDB022);

  /// Base Colors
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color grey = Color(0xffA8AAAD);

  static const Color grey50 = Color(0xffF9FAFB);
  static const Color grey100 = Color(0xffF2F4F7);
  static const Color grey200 = Color(0xffEAECF0);
  static const Color grey300 = Color(0xffD0D5DD);
  static const Color grey400 = Color(0xff98A2B3);
  static const Color grey500 = Color(0xff7C879E);
  static const Color grey600 = Color(0xff475467);
  static const Color grey700 = Color(0xff344054);
  static const Color grey800 = Color(0xff182230);
  static const Color grey900 = Color(0xff101828);

  static const Color textBlack = Color(0xff182230);
  static const Color textGrey = Color(0xff475467);
  static const Color iconGrey = Color(0xff7C879E);

  static const Color divider = Color(0xffEAECF0);
  static const Color border = Color(0xffEAECF0);

  /// Buttons
  static const Color buttonGhost = Color(0xff7E49FF);
  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryDisabled = Color(0xffF2F4F7);
  static const Color buttonDisabledText = Color(0xff98A2B3);
  static const Color buttonPrimaryText = Color(0xffE8E7E6);

  static const Color buttonTertiary = Color(0xffE8E7E6);
  static const Color buttonTertiaryBorder = Color(0xffD6D4D2);

  /// Chips
  static const Color chipBackground = Color(0xffffffff);
  static const Color chipActiveBorder = Color(0xffE2E8F0);
  static const Color chipActiveTextColor = Color(0xff020617);
  static const Color chipActiveBackground = Color(0xffF8FAFC);

  /// Toggle
  static const Color toggleActiveBackground = Color(0xff34C759);
  static const Color toggleUnActiveBackground = Color(0xff787880);

  static const Color cardBorder = Color(0xffE2E8F0);

  static const Color paginationBg = Color(0xff262626);

  static const Color avatarIconColor = Color(0xff334155);

  static const Color platinum950 = Color(0xff020617);
  static const Color platinum300 = Color(0xffCBD5E1);
  static const Color platinum500 = Color(0xff64748B);

  static const Color mainBlack = Color(0xff1F2029);
  static const Color secondaryBlack = Color(0xff797979);
  static const Color coffeeMain = Color(0xff704F38);

  static const Color red500 = Color(0xffFF2C20);
  static const Color error700 = Color(0xffB42318);
  static const Color green500 = Color(0xff00DD00);
  static const Color green700 = Color(0xff028907);

  static const Color yellow500 = Color(0xffFFEB3B);

  static const Color stone100 = Color(0xffE8E7E6);
  static const Color dividerE7E7E7 = Color(0xffE7E7E7);

  //========================
  // Scaffold
  //========================

  static const Color scaffoldBgLight = Color(0xffffffff);
  static const Color scaffoldBgDark = Color(0xff0F172A);

  static Color get scaffoldBg => isDark ? scaffoldBgDark : scaffoldBgLight;

  //========================
  // Text
  //========================

  static const Color textPrimaryLight = Color(0xff020617);
  static const Color textPrimaryDark = Color(0xffF8FAFC);

  static Color get textPrimary => isDark ? textPrimaryDark : textPrimaryLight;

  static const Color textSecondaryLight = Color(0xff64748B);
  static const Color textSecondaryDark = Color(0xffCBD5E1);

  static Color get textSecondary =>
      isDark ? textSecondaryDark : textSecondaryLight;

  //========================
  // AppBar
  //========================

  static const Color appbarBgLight = Color(0xffffffff);
  static const Color appbarBgDark = Color(0xff0F172A);

  static Color get appbarBg => isDark ? appbarBgDark : appbarBgLight;

  static const Color appbarTextLight = Color(0xff020617);
  static const Color appbarTextDark = Color(0xffF8FAFC);

  static Color get appbarText => isDark ? appbarTextDark : appbarTextLight;

  //========================
  // Bottom Navigation
  //========================

  static const Color navbarBgLight = Color(0xffffffff);
  static const Color navbarBgDark = Color(0xff111827);

  static Color get navbarBg => isDark ? navbarBgDark : navbarBgLight;

  static const Color navbarSelectedLight = primary;
  static const Color navbarSelectedDark = primary;

  static Color get navbarSelected =>
      isDark ? navbarSelectedDark : navbarSelectedLight;

  static const Color navbarUnSelectedLight = Color(0xff98A2B3);
  static const Color navbarUnSelectedDark = Color(0xff94A3B8);

  static Color get navbarUnSelected =>
      isDark ? navbarUnSelectedDark : navbarUnSelectedLight;

  //========================
  // Fields
  //========================

  static const Color fieldBgLight = Color(0xffffffff);
  static const Color fieldBgDark = Color(0xff1E293B);

  static Color get fieldBg => isDark ? fieldBgDark : fieldBgLight;

  static const Color fieldBorderLight = Color(0xffD0D5DD);
  static const Color fieldBorderDark = Color(0xff334155);

  static Color get fieldBorder => isDark ? fieldBorderDark : fieldBorderLight;

  static const Color fieldTextLight = Color(0xff64748B);
  static const Color fieldTextDark = Color(0xffCBD5E1);

  static Color get fieldText => isDark ? fieldTextDark : fieldTextLight;

  static const Color inputTextLight = Color(0xff020617);
  static const Color inputTextDark = Color(0xffF8FAFC);

  static Color get inputText => isDark ? inputTextDark : inputTextLight;
}
