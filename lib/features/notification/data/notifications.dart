import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/services/routes/app_router.dart';
import 'package:mediecom/injection_container.dart';

class NotificationService {
  // Singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Firebase
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Local Notifications
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Must be called FIRST in main.dart
  Future<void> initialize() async {
    await _initializeFirebaseMessaging();
    await _initializeLocalNotifications();
    await _requestPermissions();
    await _getFCMToken();
    _listenForegroundMessages();
    _handleMessageTap();
  }

  // ---------------------------------------------------------------------------
  // BACKGROUND HANDLER (Required to be static)
  // ---------------------------------------------------------------------------

  static Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint("📩 Background message: ${message.messageId}");
  }

  // ---------------------------------------------------------------------------
  // INITIALIZE FCM
  // ---------------------------------------------------------------------------

  Future<void> _initializeFirebaseMessaging() async {
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  }

  // ---------------------------------------------------------------------------
  // PERMISSION REQUEST (iOS + Android 13+)
  // ---------------------------------------------------------------------------

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("🔔 Notification permissions: ${settings.authorizationStatus}");
  }

  // ---------------------------------------------------------------------------
  // FETCH TOKEN
  // ---------------------------------------------------------------------------

  Future<String?> _getFCMToken() async {
    String? token = await _messaging.getToken();
    debugPrint("📲 FCM Token: $token");

    if (token != null) {
      final cache = sl<CacheHelper>();
      await cache.cacheFcmToken(token);
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint("♻️ FCM Token Refreshed: $newToken");
      final cache = sl<CacheHelper>();
      await cache.cacheFcmToken(newToken);
    });

    return token;
  }

  // ---------------------------------------------------------------------------
  // LOCAL NOTIFICATION INITIALIZATION
  // ---------------------------------------------------------------------------

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint("🔔 Local notification tapped");
      },
    );
  }

  // ---------------------------------------------------------------------------
  // SHOW LOCAL NOTIFICATION (Foreground FCM)
  // ---------------------------------------------------------------------------

  Future<void> _showLocalNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
    );
  }

  // ---------------------------------------------------------------------------
  // FOREGROUND MESSAGES
  // ---------------------------------------------------------------------------

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground message received");

      final notification = message.notification;

      if (notification != null) {
        _showLocalNotification(notification);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // NOTIFICATION TAPPED (Background / Terminated)
  // ---------------------------------------------------------------------------

  void _handleMessageTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("🚀 Notification clicked while app in background");

      // 👇 Navigate based on custom data sent from backend
      final route = message.data["route"];

      if (route != null && rootNavigatorKey.currentState != null) {
        rootNavigatorKey.currentState!.pushNamed(route);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // OPTIONAL: TOPIC SUBSCRIBE
  // ---------------------------------------------------------------------------

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint("📌 Subscribed to topic: $topic");
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint("❌ Unsubscribed from topic: $topic");
  }
}
