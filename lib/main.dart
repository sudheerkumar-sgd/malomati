import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:malomati/config/firbase_config.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/injection_container.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:malomati/app.dart';

import 'config/base_url_config.dart';
import 'config/flavor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirbaseConfig().initFirbaseMessaging();
  await Hive.initFlutter();
  await Hive.openBox(appSettingsDb);
  FlavorConfig(
    flavor: Flavor.DEVELOPMENT,
    values: FlavorValues(baseUrl: BaseUrlConfig().baseUrlDevelopment),
  );
  await di.init();
  runApp(Phoenix(child: const App()));
}
