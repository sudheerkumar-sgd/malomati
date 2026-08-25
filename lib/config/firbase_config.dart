import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'constant_config.dart';

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

  // Bump id when channel importance/category changes (Android won't update existing).
  static const String _localChannelId = 'work_hours_channel_v3';
  static const String _notificationIcon = '@drawable/ic_notification_white';

  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  static bool _localNotificationsReady = false;

  static void _configureLocalTimeZone() {
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Dubai'));
    } catch (_) {}
  }

  Future<void> initFirbaseMessaging() async {
    await Firebase.initializeApp();
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }

    String? token = await messaging.getToken();
    firbaseToken = token ?? '';
    if (kDebugMode) {
      print('Registration Token=$token');
    }

    messaging.subscribeToTopic('MALOMATI');
    await initFlutterLocalNotifications();
  }

  /// Call after the UI is up (never from main() — dialog blocks runApp).
  static Future<bool> requestAndroidNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    await ensureLocalNotificationsReady();
    final android =
        flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    if (kDebugMode) {
      print('Android notification permission granted: $granted');
      print(
          'Android notifications enabled: ${await android?.areNotificationsEnabled()}');
    }
    return granted ?? (await android?.areNotificationsEnabled() ?? true);
  }

  Future<void> initFlutterLocalNotifications() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
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

    await ensureLocalNotificationsReady();
  }

  Future<void> showNotification(RemoteMessage payload) async {
    await ensureLocalNotificationsReady();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'default_notification_channel_id',
        'Notification',
        importance: Importance.max,
        priority: Priority.high,
        icon: _notificationIcon,
        playSound: true,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin?.show(
      id: 0,
      title: payload.notification?.title,
      body: payload.notification?.body,
      notificationDetails: details,
      payload: jsonEncode(payload.data),
    );
  }

  static Future<void> ensureLocalNotificationsReady() async {
    if (_localNotificationsReady && flutterLocalNotificationsPlugin != null) {
      return;
    }
    _configureLocalTimeZone();
    const android = AndroidInitializationSettings(_notificationIcon);
    const ios = DarwinInitializationSettings();
    flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload == null || payload.isEmpty) return;
        try {
          onFirbaseMessageOpened.value = jsonDecode(payload);
        } catch (_) {}
      },
    );
    if (Platform.isAndroid) {
      const localChannel = AndroidNotificationChannel(
        _localChannelId,
        'Work Hours',
        description: 'Working hours completed reminders',
        importance: Importance.max,
        playSound: true,
      );
      await flutterLocalNotificationsPlugin
          ?.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(localChannel);
    }
    _localNotificationsReady = true;
  }

  static NotificationDetails get _localDetails => const NotificationDetails(
        android: AndroidNotificationDetails(
          _localChannelId,
          'Work Hours',
          channelDescription: 'Working hours completed reminders',
          importance: Importance.max,
          priority: Priority.max,
          icon: _notificationIcon,
          playSound: true,
          visibility: NotificationVisibility.public,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

  static Future<void> showLocalNotification(String title, String body) async {
    try {
      await ensureLocalNotificationsReady();
      // Never abort on Android permission check — iOS has no such gate.
      // MainActivity already prompts for POST_NOTIFICATIONS on Android 13+.
      if (Platform.isAndroid) {
        await requestAndroidNotificationPermission();
      }
      await flutterLocalNotificationsPlugin!.show(
        id: 100,
        title: title,
        body: body,
        notificationDetails: _localDetails,
      );
      if (kDebugMode) print('showLocalNotification posted: $title');
    } catch (e, st) {
      if (kDebugMode) {
        print('showLocalNotification failed: $e');
        print(st);
      }
    }
  }

  /// Schedule a local notification at [scheduledDate] (Android + iOS).
  /// Same zonedSchedule API on both; Android only differs in schedule mode fallbacks.
  static Future<void> scheduleLocalNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      await ensureLocalNotificationsReady();
      _configureLocalTimeZone();

      if (Platform.isAndroid) {
        // Prompt only — do not return early (that made Android a no-op while iOS worked).
        await requestAndroidNotificationPermission();
        // Required so AlarmManager can fire while the screen is off / in Doze.
        await requestExactAlarmPermission();
      }

      final location = tz.getLocation('Asia/Dubai');
      final tzDateTime = tz.TZDateTime(
        location,
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        scheduledDate.hour,
        scheduledDate.minute,
        scheduledDate.second,
      );
      final now = tz.TZDateTime.now(location);
      // If target is now/past, bump a couple seconds so Android still uses
      // zonedSchedule (immediate show() is flaky on some devices; schedule works).
      final scheduleAt = tzDateTime.isAfter(now)
          ? tzDateTime
          : now.add(const Duration(seconds: 2));

      await flutterLocalNotificationsPlugin?.cancel(id: id);

      Future<void> schedule(AndroidScheduleMode mode) {
        return flutterLocalNotificationsPlugin!.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduleAt,
          notificationDetails: _localDetails,
          androidScheduleMode: mode,
        );
      }

      // alarmClock uses setAlarmClock — most reliable when screen is off / Doze.
      // exactAllowWhileIdle still needs SCHEDULE_EXACT_ALARM; inexact is deferred in Doze.
      try {
        await schedule(AndroidScheduleMode.alarmClock);
      } catch (e) {
        if (kDebugMode) print('alarmClock failed: $e — trying exactAllowWhileIdle');
        try {
          await schedule(AndroidScheduleMode.exactAllowWhileIdle);
        } catch (e2) {
          if (kDebugMode) print('exact failed: $e2 — using inexactAllowWhileIdle');
          await schedule(AndroidScheduleMode.inexactAllowWhileIdle);
        }
      }

      if (kDebugMode) {
        final android = flutterLocalNotificationsPlugin
            ?.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final pending = await flutterLocalNotificationsPlugin
            ?.pendingNotificationRequests();
        print(
            'Scheduled id=$id @ $scheduleAt pending=${pending?.length} canExact=${await android?.canScheduleExactNotifications()}');
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('scheduleLocalNotification failed: $e');
        print(st);
      }
    }
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin?.cancel(id: id);
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin?.cancelAll();
  }

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
