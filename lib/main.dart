import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/helper/app_helper.dart';
import 'core/helper/app_locals.dart';
import 'core/helper/app_navigator.dart';
import 'core/network/local/cache/cache_helper.dart';
import 'core/network/remote/api/dio_helper.dart';
import 'core/style/app_theme.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// SHARED PREFERENCE INITIALIZATION
  await CacheHelper.init();

  /// LANGUAGE INIT
  await EasyLocalization.ensureInitialized();
  await AppLocales.init();

  /// DIO INITIALIZATION
  DioHelper.init();

  /// DISABLE AUTO ROTATE
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      startLocale: AppLocales.currentLocale,
      fallbackLocale: AppLanguage.english.locale,
      supportedLocales: AppLocales.supportedLocales,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: AppHelper.closeKeyboard,
      child: MaterialApp(
        title: 'CHIAKA',
        home: OnboardingScreen(),
        navigatorKey: AppNavigator.key,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: AppTheme.appLightTheme,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        builder: (context, child) =>
            ScrollConfiguration(behavior: AppBehavior(), child: child!),
      ),
    );
  }
}

class AppBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
