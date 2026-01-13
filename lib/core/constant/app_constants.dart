import '../network/local/cache/cache_helper.dart';

class AppConstants {
  static final String fontIBMPlexSansArabic = 'IBMPlexSansArabic';

  static final bool isAr = CacheHelper.get(CacheKeys.lang) == CacheKeys.langAr;

  static final String addressAr =
      '456 شارع الملك فهد، الرياض، المملكة العربية السعودية';
  static final String addressEn = '456 King Fahd Street, Riyadh, Saudi Arabia';

  static final String appAddress = isAr ? addressAr : addressEn;

  static final String taxNumber = '3020142734';

  static final String appUrl = 'https://shuaa-alamal.com/';
}
