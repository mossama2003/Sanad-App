// import 'dart:developer';
// import 'dart:async';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// import '../../local/cache/cache_helper.dart';
//
// // Background message handler - must be top-level function
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   log('🔔 Background Notification received');
//   log('   Title: ${message.notification?.title}');
//   log('   Body: ${message.notification?.body}');
//   log('   Data: ${message.data}');
//   // Background notifications are automatically displayed by FCM
//   // if the notification payload is present
// }
//
// class FirebaseNotifications {
//   static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//
//   static Future<void> checkInitialMessage() async {
//     final initialMessage = await _fcm.getInitialMessage();
//     if (initialMessage != null) _handleNotificationTap(initialMessage);
//   }
//
//   // Initialize Firebase Messaging
//   static Future<void> initialize() async {
//     try {
//       await _handleNotificationPermissions();
//
//       // Fetch FCM Token and save to local storage
//       final token = await _fcm.getToken();
//       if (token != null) {
//         await CacheHelper.save(CacheKeys.fcmToken, token);
//         log('✅ FCM Token saved: $token');
//       } else {
//         log('⚠️ FCM Token is null');
//       }
//
//       // Listen for token refresh
//       _fcm.onTokenRefresh.listen((newToken) async {
//         await CacheHelper.save(CacheKeys.fcmToken, newToken);
//         log('🔄 FCM Token refreshed: ${newToken.substring(0, 20)}...');
//       });
//
//       // Subscribe to default topic
//       await subscribeToTopic('AllUsers');
//
//       // Set up notification listeners
//       FirebaseMessaging.onMessage.listen(_handleNotificationForeground);
//       FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
//       FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//
//       log('✅ Firebase Messaging initialized successfully');
//     } catch (e) {
//       log('❌ Error initializing Firebase Messaging: $e');
//     }
//   }
//
//   // Request notification permissions
//   static Future<void> _handleNotificationPermissions() async {
//     final settings = await _fcm.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       log('✅ Notification permissions granted');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       log('⚠️ Notification permissions granted provisionally');
//     } else {
//       log('❌ Notification permissions denied');
//     }
//   }
//
//   // Handle notification tap (when user clicks on FCM notification)
//   static Future<void> _handleNotificationTap(RemoteMessage msg) async {
//     log('🔔 Notification Clicked: ${msg.data}');
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (CacheHelper.get(CacheKeys.token) != null) {
//         // AppNavigator.push(NotificationsScreen());
//       }
//     });
//   }
//
//   // Handle notification when app is in the foreground
//   static Future<void> _handleNotificationForeground(RemoteMessage msg) async {
//     log('📱 Foreground Notification received');
//     // await LocalNotificationService.displayNotification(msg);
//   }
//
//   // Subscribe to a topic
//   static Future<void> subscribeToTopic(String topic) async {
//     try {
//       await _fcm.subscribeToTopic(topic);
//       log('Subscribed to topic: $topic');
//     } catch (e) {
//       log('Failed to subscribe to topic $topic: $e');
//     }
//   }
//
//   // Unsubscribe from a topic
//   static Future<void> unsubscribeFromTopic(String topic) async {
//     try {
//       await _fcm.unsubscribeFromTopic(topic);
//       log('Unsubscribed from topic: $topic');
//     } catch (e) {
//       log('Failed to unsubscribe from topic $topic: $e');
//     }
//   }
// }
