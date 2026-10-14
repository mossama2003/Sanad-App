import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../repos/notification_repo.dart';

typedef NotificationTapCallback =
    Future<void> Function(Map<String, dynamic> data);

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final NotificationsRepoImpel _notificationsRepo = NotificationsRepoImpel();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'sanad_notifications',
    'Sanad Notifications',
    description: 'Notifications from Sanad',
    importance: Importance.max,
  );

  NotificationTapCallback? _onNotificationTap;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;

  StreamSubscription<RemoteMessage>? _openedSubscription;

  StreamSubscription<String>? _tokenRefreshSubscription;

  bool _initialized = false;

  Future<void> initialize({
    required NotificationTapCallback onNotificationTap,
  }) async {
    // تحديث الـ callback حتى لو تم استدعاء initialize مرة أخرى.
    _onNotificationTap = onNotificationTap;

    if (_initialized) return;

    await _requestPermission();

    await _initializeLocalNotifications();

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );

    // التطبيق مفتوح.
    _foregroundSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) async {
      try {
        await _handleForegroundMessage(message);
      } catch (e, stackTrace) {
        debugPrint('Foreground notification error: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    });

    // المستخدم ضغط على إشعار والتطبيق كان في الخلفية.
    _openedSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
      RemoteMessage message,
    ) {
      _handleTap(message.data);
    });

    // المستخدم فتح التطبيق من إشعار والتطبيق كان مغلقًا.
    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      await _handleTap(initialMessage.data);
    }

    // الضغط على إشعار محلي تم عرضه أثناء الـ Foreground.
    final launchDetails = await _localNotifications
        .getNotificationAppLaunchDetails();

    final response = launchDetails?.notificationResponse;

    if (launchDetails?.didNotificationLaunchApp == true &&
        response?.payload != null &&
        response!.payload!.isNotEmpty) {
      _handleLocalNotificationPayload(response.payload!);
    }

    // تسجيل الـ Token الحالي.
    await _registerCurrentToken();

    // متابعة تغيّر الـ Token.
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      (token) async {
        debugPrint('FCM token refreshed.');

        await _registerToken(token);
      },
      onError: (Object error) {
        debugPrint('FCM token refresh error: $error');
      },
    );

    _initialized = true;

    debugPrint('NotificationService initialized.');
  }

  // ============================================================
  // Permissions
  // ============================================================

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint(
      'Notification authorization: '
      '${settings.authorizationStatus}',
    );
  }

  // ============================================================
  // Local Notifications
  // ============================================================

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;

        if (payload == null || payload.isEmpty) {
          return;
        }

        _handleLocalNotificationPayload(payload);
      },
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_channel);

    await androidPlugin?.requestNotificationsPermission();
  }

  // ============================================================
  // FCM Token
  // ============================================================

  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();

      debugPrint('FCM token available: ${token != null}');

      return token;
    } catch (e, stackTrace) {
      debugPrint('FCM token error: $e');

      debugPrintStack(stackTrace: stackTrace);

      return null;
    }
  }

  Future<void> _registerCurrentToken() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      debugPrint('FCM token is not available yet.');
      return;
    }

    await _registerToken(token);
  }

  Future<void> _registerToken(String token) async {
    try {
      final deviceType = _getDeviceType();

      if (deviceType == null) {
        debugPrint('Unsupported platform for FCM registration.');
        return;
      }

      final result = await _notificationsRepo.registerDevice(
        registrationId: token,
        type: deviceType,
        name: 'Sanad ${deviceType.toUpperCase()}',
      );

      result.fold(
        (failure) {
          debugPrint(
            'FCM device registration failed: '
            '${failure.errMessage}',
          );
        },
        (_) {
          debugPrint('FCM device registered successfully.');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('FCM device registration error: $e');

      debugPrintStack(stackTrace: stackTrace);
    }
  }

  String? _getDeviceType() {
    if (kIsWeb) return 'web';

    if (Platform.isAndroid) return 'android';

    if (Platform.isIOS) return 'ios';

    return null;
  }

  // ============================================================
  // Foreground Messages
  // ============================================================

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;

    // دعم رسائل Notification وData معًا.
    final title =
        notification?.title ?? message.data['title']?.toString() ?? 'Sanad';

    final body =
        notification?.body ??
        message.data['body']?.toString() ??
        message.data['message']?.toString() ??
        '';

    // تجاهل الرسالة إذا لم يكن بها محتوى قابل للعرض.
    if (body.isEmpty && notification == null) {
      debugPrint('Received data-only message: ${message.messageId}');

      return;
    }

    await _localNotifications.show(
      id: message.messageId?.hashCode ?? message.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  // ============================================================
  // Notification Tap
  // ============================================================

  Future<void> _handleTap(Map<String, dynamic> data) async {
    try {
      await _onNotificationTap?.call(data);
    } catch (e, stackTrace) {
      debugPrint('Notification tap handling error: $e');

      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _handleLocalNotificationPayload(String payload) {
    try {
      final decoded = jsonDecode(payload);

      if (decoded is Map) {
        _handleTap(Map<String, dynamic>.from(decoded));
      }
    } catch (e) {
      debugPrint('Invalid notification payload: $e');
    }
  }

  // ============================================================
  // Cleanup
  // ============================================================

  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _openedSubscription?.cancel();
    await _tokenRefreshSubscription?.cancel();

    _foregroundSubscription = null;
    _openedSubscription = null;
    _tokenRefreshSubscription = null;

    _initialized = false;
  }
}
