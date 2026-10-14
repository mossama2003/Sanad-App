import 'package:sanad_app/features/volunteer/community/presentation/controllers/volunteer_community_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/organization/home/presentation/controllers/organization_home_cubit.dart';
import 'features/shared/notification/data/services/notification_service.dart';
import 'features/volunteer/events/presentation/controllers/volunteer_events_cubit.dart';
import 'features/volunteer/home/presentation/controllers/volunteer_home_cubit.dart';
import 'features/volunteer/community/data/repos/volunteer_community_repo.dart';
import 'features/organization/home/data/repos/organization_home_repo.dart';
import 'features/shared/splash/presentations/screens/splash_screen.dart';
import 'features/volunteer/events/data/repos/volunteer_events_repo.dart';
import 'features/volunteer/home/data/repos/volunteer_home_repo.dart';
import 'core/shared/controllers/user/app_cubit.dart';
import 'core/network/local/cache/cache_helper.dart';
import 'core/network/remote/api/dio_helper.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/storage/hive/hive_init.dart';
import 'core/helper/app_navigator.dart';
import 'core/helper/app_helper.dart';
import 'core/helper/app_locals.dart';
import 'core/style/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Firebase
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('FCM Background Message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background handler only once.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Hive
  await HiveInit.init();

  // Shared Preferences
  await CacheHelper.init();

  // Theme
  await AppTheme.init();

  // Localization
  await EasyLocalization.ensureInitialized();

  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');

  await AppLocales.init();

  // Dio
  await DioHelper.init();

  // Disable auto rotation
  await SystemChrome.setPreferredOrientations([
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _notificationsInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_notificationsInitialized) return;

    _notificationsInitialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _initializeNotifications();
    });
  }

  Future<void> _initializeNotifications() async {
    try {
      await NotificationService.instance.initialize(
        onNotificationTap: _handleNotificationTap,
      );

      final token = await NotificationService.instance.getToken();

      debugPrint('Sanad FCM Token: $token');
    } catch (e, stackTrace) {
      debugPrint('Notifications initialization failed: $e');

      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _handleNotificationTap(Map<String, dynamic> data) async {
    final route = data['route']?.toString();

    if (route == null || route.isEmpty) {
      debugPrint('Notification has no route: $data');
      return;
    }

    final navigator = AppNavigator.key.currentState;

    if (navigator == null) {
      debugPrint('Navigator is not ready yet.');
      return;
    }

    try {
      navigator.pushNamed(route, arguments: data);
    } catch (e, stackTrace) {
      debugPrint('Failed to open notification route "$route": $e');

      debugPrintStack(stackTrace: stackTrace);
    }
  }

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
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              navigatorKey: AppNavigator.key,
              debugShowCheckedModeBanner: false,
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
