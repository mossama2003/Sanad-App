import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sanad_app/features/volunteer/community/presentation/controllers/volunteer_community_cubit.dart';

import 'features/organization/home/presentation/controllers/organization_home_cubit.dart';
import 'features/volunteer/community/data/repos/volunteer_community_repo.dart';
import 'features/volunteer/events/presentation/controllers/volunteer_events_cubit.dart';
import 'features/volunteer/home/presentation/controllers/volunteer_home_cubit.dart';
import 'features/organization/home/data/repos/organization_home_repo.dart';
import 'features/volunteer/events/data/repos/volunteer_events_repo.dart';
import 'features/shared/splash/presentations/screens/splash_screen.dart';
import 'features/volunteer/home/data/repos/volunteer_home_repo.dart';
import 'core/shared/controllers/user/app_cubit.dart';
import 'core/network/local/cache/cache_helper.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/network/remote/api/dio_helper.dart';
import 'core/storage/hive/hive_init.dart';
import 'core/helper/app_navigator.dart';
import 'core/helper/app_helper.dart';
import 'core/helper/app_locals.dart';
import 'core/style/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// HIVE INITIALIZATION
  await HiveInit.init();

  /// SHARED PREFERENCE INITIALIZATION
  await CacheHelper.init();

  /// THEME INIT
  await AppTheme.init();

  /// LANGUAGE INIT
  await EasyLocalization.ensureInitialized();

  /// LANGUAGE INIT
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');
  await AppLocales.init();

  /// DIO INITIALIZATION
  await DioHelper.init();

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
    return ValueListenableBuilder<AppThemeEnum>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, currentTheme, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AppCubit()),

            BlocProvider(
              create: (_) => VolunteerHomeCubit(VolunteerHomeRepoImpel()),
            ),

            BlocProvider(
              create: (_) => VolunteerEventsCubit(VolunteerEventsRepoImpel())
                ..loadEventsFromCache()
                ..getVolunteerEvents(),
            ),

            BlocProvider(
              create: (_) => OrganizationHomeCubit(OrganizationHomeRepoImpel()),
            ),

            BlocProvider(
              create: (_) =>
                  VolunteerCommunityCubit(VolunteerCommunityRepoImpel()),
            ),
          ],
          child: GestureDetector(
            onTap: AppHelper.closeKeyboard,
            child: MaterialApp(
              title: 'Sanad',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: currentTheme.mode,
              home: SplashScreen(),
              locale: context.locale,
              navigatorKey: AppNavigator.key,
              debugShowCheckedModeBanner: false,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              builder: (context, child) {
                return ScrollConfiguration(
                  behavior: AppBehavior(),
                  child: child!,
                );
              },
            ),
          ),
        );
      },
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
