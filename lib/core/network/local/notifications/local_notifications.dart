// import 'dart:developer';
// import 'dart:convert';
//
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../features/notifications/presentation/screens/notifications_screen.dart';
// import '../../../helper/app_navigator.dart';
// import '../cache/cache_helper.dart';
//
// class LocalNotificationService {
//   static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
//   static const String _androidChannelId = 'PushNotificationAppChannel';
//   static const String _androidChannelName = 'PushNotificationApp';
//
//   // Initialize Local Notifications
//   static Future<void> initialize() async {
//     const initialSettings = InitializationSettings(
//       iOS: DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//       ),
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     );
//
//     await _notificationsPlugin.initialize(
//       initialSettings,
//       onDidReceiveNotificationResponse: receiveNotification,
//       onDidReceiveBackgroundNotificationResponse: receiveNotification,
//     );
//
//     // Create Android notification channel
//     await _createAndroidNotificationChannel();
//   }
//
//   // Create Android notification channel
//   static Future<void> _createAndroidNotificationChannel() async {
//     const androidChannel = AndroidNotificationChannel(
//       _androidChannelId,
//       _androidChannelName,
//       description: 'Channel for push notifications',
//       importance: Importance.max,
//       playSound: true,
//     );
//
//     await _notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(androidChannel);
//
//     log('✅ Android notification channel created: $_androidChannelId');
//   }
//
//   // Display local notification
//   static Future<void> displayNotification(RemoteMessage message) async {
//     try {
//       final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       const notificationDetails = NotificationDetails(
//         iOS: DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//         android: AndroidNotificationDetails(
//           _androidChannelName,
//           _androidChannelId,
//           channelDescription: 'Channel for push notifications',
//           priority: Priority.high,
//           importance: Importance.max,
//           enableVibration: true,
//         ),
//       );
//       final payload = jsonEncode(message.data);
//       await _notificationsPlugin.show(
//         id,
//         message.notification?.title,
//         message.notification?.body,
//         notificationDetails,
//         payload: payload,
//       );
//     } catch (e) {
//       log('Error creating and displaying notification: $e');
//     }
//   }
//
//   // Handle local notification click
//   static void receiveNotification(NotificationResponse msg) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (msg.payload != null) {
//         if (CacheHelper.get(CacheKeys.token) != null) {
//           AppNavigator.push(NotificationsScreen());
//         }
//       }
//     });
//   }
// }
