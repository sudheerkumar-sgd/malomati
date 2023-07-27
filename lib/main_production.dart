import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:malomati/app.dart';
import 'package:malomati/core/common/common.dart';

import 'config/base_url_config.dart';
import 'config/flavor_config.dart';
import 'package:malomati/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(appSettingsDb);
  FlavorConfig(
    flavor: Flavor.PRODUCTION,
    values: FlavorValues(baseUrl: BaseUrlConfig().baseUrlProduction),
  );
  await di.init();
  runApp(const App());
}
