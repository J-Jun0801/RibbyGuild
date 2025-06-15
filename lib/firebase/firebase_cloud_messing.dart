import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<String?> getFirebaseToken() async {
  final token = await FirebaseMessaging.instance
      .getToken(vapidKey: 'BGjQ-hnvDCi2RdK5e3GgXBs-u0KGubUZzcQ3s7perthVBYq4PgVblNuhuT9nJdkM1bog03rSfWVip5VK-3O5MW0');
  return token;
}

Future<void> sendPushToMultipleUsers({
  required List<String> pushTokens,
  required String title,
  required String body,
}) async {
  const String serverKey =
      'BGjQ-hnvDCi2RdK5e3GgXBs-u0KGubUZzcQ3s7perthVBYq4PgVblNuhuT9nJdkM1bog03rSfWVip5VK-3O5MW0'; // FCM 서버 키
  const String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/ribbyguild/messages:send';

  final url = Uri.parse(fcmEndpoint); // 너의 서버 주소
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $serverKey'},
    body: jsonEncode({
      'tokens': pushTokens,
      'title': title,
      'body': body,
    }),
  );

  print(">>>>>>>>> ${response}");
}
