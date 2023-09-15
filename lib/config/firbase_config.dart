import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase_options.dart';

//Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

class FirbaseConfig {
  static String firbaseToken = '';
  Future<void> initFirbaseMessaging() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //Request permission
    final messaging = FirebaseMessaging.instance;

    // Web/iOS app users need to grant permission to receive messages
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }
    // Register with FCM
    // use the registration token to send messages to users from your trusted server environment
    String? token = await messaging.getToken();

    firbaseToken = token ?? '';
    if (kDebugMode) {
      print('Registration Token=$token');
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    messaging.subscribeToTopic('MALOMATI');
    initFlutterLocalNotifications();
  }

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  initFlutterLocalNotifications() {
    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }
      showNotification(message);
    });

    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initiallizationSettingsIOS = const DarwinInitializationSettings();
    var initialSetting = InitializationSettings(
        android: android, iOS: initiallizationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.initialize(initialSetting);
    flutterLocalNotificationsPlugin?.initialize(
      initialSetting,
    );
  }

  Future<void> showNotification(RemoteMessage payload) async {
    if (flutterLocalNotificationsPlugin == null) {
      initFlutterLocalNotifications();
    }
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_notification_channel_id',
      'Notification',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: "@mipmap/ic_launcher",
      playSound: true,
    );
    const iOSDetails = DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin?.show(0, payload.notification!.title,
        payload.notification!.body, platformChannelSpecifics,
        payload: payload.notification!.body);
  }
}
