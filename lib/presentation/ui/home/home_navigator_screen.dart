import 'package:flutter/material.dart';
import 'package:malomati/presentation/ui/home/home_screen.dart';

class HomeNavigatorScreen extends StatelessWidget {
  const HomeNavigatorScreen({Key? key}) : super(key: key);

  /// Stable key so parent rebuilds (e.g. bottom bar) do not reset this navigator.
  static final GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: homeKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext _) => HomeScreen();
              break;
            default:
              builder = (BuildContext _) => HomeScreen();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        });
  }
}
