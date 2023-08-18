import 'package:flutter/widgets.dart';
import 'package:malomati/presentation/ui/home/home_screen.dart';
import 'package:malomati/presentation/ui/home/main_screen.dart';
import 'package:malomati/presentation/ui/login/login_screen.dart';

import '../presentation/ui/splash/splash_screen.dart';

class AppRoutes {
  static String initialRoute = '/splash';
  static String loginRoute = '/login';
  static String mainRoute = '/main';
  static String homeRoute = '/home';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.initialRoute: (context) => const SplashScreen(),
      AppRoutes.loginRoute: (context) => LoginScreen(),
      AppRoutes.mainRoute: (context) => MainScreen(),
      AppRoutes.homeRoute: (context) => HomeScreen(),
    };
  }
}
