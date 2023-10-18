import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase_options.dart';
import 'constant_config.dart';

//Define the background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
  if (Platform.isIOS) {
    FlutterAppBadger.isAppBadgeSupported().then((value) {
      if (value) {
        FlutterLocalNotificationsPlugin().getActiveNotifications().then(
          (value) {
            FlutterAppBadger.updateBadgeCount(value.length);
          },
        );
      }
    });
  }
}

class FirbaseConfig {
  static String firbaseToken = '';
  static ValueNotifier<Map<String, dynamic>?> onFirbaseMessageOpened =
      ValueNotifier(null);
  Future<void> initFirbaseMessaging() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //Request permission
    final messaging = FirebaseMessaging.instance;

    // Web/iOS app users need to grant permission to receive messages
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

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
        //print('Handling a foreground message: ${json.encode(message)}');
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
        print('Message notification: ${message.data.toString()}');
        print(
            'Message notification: ${message.notification?.android?.clickAction ?? ''}');
        print(
            'Message notification: ${message.notification?.apple?.subtitleLocArgs ?? ''}');
      }
      if (Platform.isAndroid) {
        showNotification(message);
      }
      if (Platform.isIOS) {
        FlutterAppBadger.isAppBadgeSupported().then((value) {
          if (value) {
            flutterLocalNotificationsPlugin?.getActiveNotifications().then(
              (value) {
                FlutterAppBadger.updateBadgeCount(value.length);
              },
            );
          }
        });
      }
      if (message.data['type'] == 'POPUP') {
        ConstantConfig.onFCMMessageReceived.value = {'data': message.data};
      }
    });

    var android =
        const AndroidInitializationSettings('@mipmap/ic_app_notification');
    var initiallizationSettingsIOS = const DarwinInitializationSettings();
    var initialSetting = InitializationSettings(
        android: android, iOS: initiallizationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.initialize(initialSetting);
    flutterLocalNotificationsPlugin?.initialize(
      initialSetting,
      onDidReceiveNotificationResponse: (details) {
        onFirbaseMessageOpened.value = jsonDecode(details.payload ?? '');
      },
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
        payload: jsonEncode(payload.data));
  }
}
