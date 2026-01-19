import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../network/local/cache/cache_helper.dart';

// class AppLocales {
//   static int? currentLang;
//
//   static Future<void> init() async {
//     // String languageCode = Intl.systemLocale.split('_')[0];
//
//     /// SET DEFAULT LANG
//     if (await CacheHelper.get('lang') == null) {
//       await CacheHelper.save('lang', 'en');
//       // await CacheHelper.saveData('lang', languageCode);
//     }
//
//     String lang = await CacheHelper.get('lang');
//
//     if (lang == 'ar') {
//       currentLang = 0;
//     } else if (lang == 'en') {
//       currentLang = 1;
//     }
//   }
//
//   /// list of supported locales
//   static const supportedLocales = [
//     Locale('ar', 'EG'),
//     Locale('en', 'US'),
//   ];
//
//   /// list of supported locales names
//   static const supportedLocalesNames = [
//     'العربية',
//     'English',
//   ];
//
//   /// list of supported locales codes
//   static const supportedLocalesCodes = [
//     'ar',
//     'en',
//   ];
//
//   /// current app locale
//   static Locale currentLocale = supportedLocales[0];
//
//   /// updates device locale, takes [context] and [index] of supported locales as parameters
//   ///
//   /// * [index] is the index of supported locales in [supportedLocales]
//   ///
//   /// * [context] is the current [BuildContext].
//
//   static void setDeviceLocale(BuildContext context, int index) {
//     //make sure the index is in range
//     if (index < 0 || index >= supportedLocales.length) {
//       return;
//     }
//     EasyLocalization.of(context)!
//         .setLocale(supportedLocales[index])
//         .then((value) => currentLocale = supportedLocales[index]);
//   }
// }

enum AppLanguage { arabic, english }

extension AppLanguageExtension on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.arabic:
        return 'ar';
      case AppLanguage.english:
        return 'en';
    }
  }

  Locale get locale {
    switch (this) {
      case AppLanguage.arabic:
        return const Locale('ar', 'EG');
      case AppLanguage.english:
        return const Locale('en', 'US');
    }
  }

  String get displayName {
    switch (this) {
      case AppLanguage.arabic:
        return 'العربية';
      case AppLanguage.english:
        return 'English';
    }
  }
}

class AppLocales {
  /// Current selected language
  static AppLanguage? currentLang;

  /// List of supported languages
  static const supportedLanguages = AppLanguage.values;

  /// Get current locale
  static Locale get currentLocale {
    return currentLang?.locale ?? AppLanguage.english.locale;
  }

  /// Get current language code
  static String get currentLocaleCode {
    return currentLang?.code ?? AppLanguage.english.code;
  }

  /// Get list of supported locales
  static List<Locale> get supportedLocales {
    return supportedLanguages.map((lang) => lang.locale).toList();
  }

  /// Initialize locales by detecting device language or using cached language
  static Future<void> init() async {
    final deviceLang = Intl.systemLocale.split('_')[0];
    final cachedLangCode = await CacheHelper.get(CacheKeys.lang);
    final defaultLang = _getLangEnumFromCode(deviceLang) ?? AppLanguage.english;
    final selectedLang = _getLangEnumFromCode(cachedLangCode) ?? defaultLang;
    currentLang = selectedLang;
    if (cachedLangCode == null) {
      await CacheHelper.save(CacheKeys.lang, selectedLang.code);
    }
  }

  /// Change lang
  static Future<void> changeLang(BuildContext ctx, AppLanguage lang) async {
    currentLang = lang;
    await ctx.setLocale(lang.locale);
    await CacheHelper.save(CacheKeys.lang, lang.code);
  }

  /// Helper method to get `AppLanguageEnum` from code
  static AppLanguage? _getLangEnumFromCode(String? code) {
    return AppLanguage.values.firstWhere(
          (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
