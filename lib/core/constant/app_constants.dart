import '../network/local/cache/cache_helper.dart';

class AppConstants {
  static final String fontIBMPlexSansArabic = 'IBMPlexSansArabic';

  static final bool isAr = CacheHelper.get(CacheKeys.lang) == CacheKeys.langAr;

  static const String cscApiKey =
      "45fcbf7eec16504e3126a670eac227a6f594fd8af5133046fb7663f7004d23d7";
}
