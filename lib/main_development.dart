import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/injection_container.dart' as di;
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:malomati/app.dart';

import 'config/base_url_config.dart';
import 'config/firbase_config.dart';
import 'config/flavor_config.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz1;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initTimezone();
  await FirbaseConfig().initFirbaseMessaging();
  await Hive.initFlutter();
  await Hive.openBox(appSettingsDb);
  FlavorConfig(
    flavor: Flavor.DEVELOPMENT,
    values: FlavorValues(baseUrl: baseUrlProduction),
  );
  await di.init();
  // await Workmanager().initialize(
  //   callbackDispatcher,
  // );
  runApp(Phoenix(child: const App()));
}

void _initTimezone() {
  tz1.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Dubai'));
}

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     WidgetsFlutterBinding.ensureInitialized();
//     if (Platform.isAndroid) {
//       // Must await: returning early kills the BG isolate before show() finishes.
//       await FirbaseConfig.showLocalNotification(
//         'Working Hours Completed',
//         'Your scheduled working hours for today have been completed successfully.',
//       );
//     }
//     return true;
//   });
// }
