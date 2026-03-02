import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
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
    FlutterAppBadgeControl.isAppBadgeSupported().then((value) {
      if (value) {
        FlutterLocalNotificationsPlugin().getActiveNotifications().then(
          (value) {
            FlutterAppBadgeControl.updateBadgeCount(value.length);
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

  /// initialize timezone database used by flutter_local_notifications
  ///
  /// this must be called once before scheduling any notifications.
  static void _configureLocalTimeZone() {
    try {
      tz.initializeTimeZones();
      final String timeZoneName = tz.local.name;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      // ignore errors; if timezone package isn't available scheduling will
      // still fall back to system default but might be off by an hour.
    }
  }

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

  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  void initFlutterLocalNotifications() {
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
        FlutterAppBadgeControl.isAppBadgeSupported().then((value) {
          if (value) {
            flutterLocalNotificationsPlugin?.getActiveNotifications().then(
              (value) {
                FlutterAppBadgeControl.updateBadgeCount(value.length);
              },
            );
          }
        });
      }
      if (message.data['type'] == 'POPUP') {
        ConstantConfig.onFCMMessageReceived.value = {'data': message.data};
      }
    });

    // make sure timezone database is initialised so scheduled notifications work
    _configureLocalTimeZone();

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

  static Future<void> showLocalNotification(String title, String body) async {
    if (flutterLocalNotificationsPlugin == null) {
      FirbaseConfig().initFlutterLocalNotifications();
    }
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'local_notification_channel_id',
      'Local Notification',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: "@mipmap/ic_launcher",
      playSound: true,
    );
    const iOSDetails = DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await flutterLocalNotificationsPlugin?.show(
        DateTime.now().millisecond, title, body, platformChannelSpecifics);
  }

  /// schedule a notification at [scheduledDate]
  static Future<void> scheduleLocalNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    if (flutterLocalNotificationsPlugin == null) {
      FirbaseConfig().initFlutterLocalNotifications();
    }
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'local_notification_channel_id',
      'Local Notification',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: "@mipmap/ic_launcher",
      playSound: true,
    );
    const iOSDetails = DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    try {
      await flutterLocalNotificationsPlugin?.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } on PlatformException catch (e) {
      // On Android 12+/13+ exact alarms may require permission. If the
      // permission is not granted, fall back to an inexact schedule so the
      // notification will still fire approximately at the requested time.
      if (e.code == 'exact_alarms_not_permitted') {
        try {
          await flutterLocalNotificationsPlugin?.zonedSchedule(
            id,
            title,
            body,
            tz.TZDateTime.from(scheduledDate, tz.local),
            platformChannelSpecifics,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
          );
        } catch (_) {}
      } else {
        rethrow;
      }
    } catch (_) {}
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin?.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin?.cancelAll();
  }

  /// Requests the exact alarm permission on Android 12+ (API 31+).
  ///
  /// If granted the plugin will be able to schedule notifications with
  /// `AndroidScheduleMode.exactAllowWhileIdle`. On newer platforms the system
  /// shows a runtime prompt and this method returns true when the user allows
  /// it.  Returns null on non-Android platforms.
  static Future<bool?> requestExactAlarmPermission() async {
    try {
      return await flutterLocalNotificationsPlugin
          ?.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission();
    } catch (_) {
      return null;
    }
  }
}
