import 'package:flutter/widgets.dart';
import 'package:malomati/presentation/ui/login/login_screen.dart';

import '../presentation/ui/splash/splash_screen.dart';

class AppRoutes {
  static String initialRoute = '/splash';
  static String loginRoute = '/login';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.initialRoute: (context) => const SplashScreen(),
      AppRoutes.loginRoute: (context) => LoginScreen(),
    };
  }
}
