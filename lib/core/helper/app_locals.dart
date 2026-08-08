import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../network/local/cache/cache_helper.dart';

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

  /// Supported languages
  static const supportedLanguages = AppLanguage.values;

  /// Current locale
  static Locale get currentLocale {
    return currentLang?.locale ?? AppLanguage.english.locale;
  }

  /// Current language code
  static String get currentLocaleCode {
    return currentLang?.code ?? AppLanguage.english.code;
  }

  /// Supported locales
  static List<Locale> get supportedLocales {
    return supportedLanguages.map((lang) => lang.locale).toList();
  }

  /// Initialize language
  static Future<void> init() async {
    // Get device language
    final deviceLanguage = Intl.getCurrentLocale().split('_').first;

    // Get cached language
    final cachedLangCode = await CacheHelper.get(CacheKeys.lang) as String?;

    // If user selected a language before, use it.
    // Otherwise, use device language.
    final selectedLang =
        _getLangEnumFromCode(cachedLangCode) ??
        _getLangEnumFromCode(deviceLanguage) ??
        AppLanguage.english;

    currentLang = selectedLang;

    // Save initial language if there is no cached language
    if (cachedLangCode == null) {
      await CacheHelper.save(CacheKeys.lang, selectedLang.code);
    }
  }

  /// Change language manually
  static Future<void> changeLang(BuildContext context, AppLanguage lang) async {
    currentLang = lang;

    await context.setLocale(lang.locale);

    await CacheHelper.save(CacheKeys.lang, lang.code);
  }

  /// Convert language code to enum
  static AppLanguage? _getLangEnumFromCode(String? code) {
    if (code == null || code.isEmpty) {
      return null;
    }

    return AppLanguage.values.cast<AppLanguage?>().firstWhere(
      (lang) => lang?.code == code,
      orElse: () => null,
    );
  }
}
