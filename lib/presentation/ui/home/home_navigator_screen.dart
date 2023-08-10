import 'package:flutter/material.dart';
import 'package:malomati/presentation/ui/home/home_screen.dart';

class HomeNavigatorScreen extends StatelessWidget {
  const HomeNavigatorScreen({Key? key}) : super(key: key);
  static var homeKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    homeKey = GlobalKey<NavigatorState>();
    return Navigator(
        key: homeKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext _) => HomeScreen();
              break;
            // case InfoListScreen.route:
            //   builder = (BuildContext _) {
            //     return InfoListScreen();
            //   };
            // break;
            default:
              builder = (BuildContext _) => HomeScreen();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        });
  }
}
