import 'package:flutter/material.dart';
import '../constant/app_constants.dart';
import '../constant/app_size.dart';

extension AppTextStyle on TextStyle {
  TextStyle get xl {
    return copyWith(
      fontSize: AppSize.font(26),
      fontWeight: FontWeight.w500,
      height: AppSize.fontHeight(26, 34),
      fontFamily: AppConstants.fontIBMPlexSansArabic,
    );
  }

  TextStyle get lg {
    return copyWith(
      fontSize: AppSize.font(22),
      fontWeight: FontWeight.w500,
      height: AppSize.fontHeight(22, 28),
      fontFamily: AppConstants.fontIBMPlexSansArabic,
    );
  }

  TextStyle get md {
    return copyWith(
      fontSize: AppSize.font(18),
      fontWeight: FontWeight.w500,
      height: AppSize.fontHeight(18, 24),
      fontFamily: AppConstants.fontIBMPlexSansArabic,
    );
  }

  TextStyle get sm {
    return copyWith(
      fontSize: AppSize.font(16),
      fontWeight: FontWeight.w500,
      height: AppSize.fontHeight(16, 22),
      fontFamily: AppConstants.fontIBMPlexSansArabic,
    );
  }

  TextStyle get xs {
    return copyWith(
      fontSize: AppSize.font(14),
      fontWeight: FontWeight.w400,
      height: AppSize.fontHeight(12, 20),
      fontFamily: AppConstants.fontIBMPlexSansArabic,
    );
  }
}
