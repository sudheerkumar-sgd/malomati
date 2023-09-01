import 'package:flutter/material.dart';
import 'package:malomati/presentation/ui/home/services_screen.dart';

class ServicesNavigatorScreen extends StatelessWidget {
  const ServicesNavigatorScreen({Key? key}) : super(key: key);
  static var servicesKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    servicesKey = GlobalKey<NavigatorState>();
    return Navigator(
        key: servicesKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext _) => const ServicesScreen();
              break;
            default:
              builder = (BuildContext _) => const ServicesScreen();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        });
  }
}
