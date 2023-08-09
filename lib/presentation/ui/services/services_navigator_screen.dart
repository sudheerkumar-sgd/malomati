import 'package:flutter/material.dart';
import 'package:malomati/presentation/ui/home/home_screen.dart';
import 'package:malomati/presentation/ui/home/more_screen.dart';
import 'package:malomati/presentation/ui/home/services_screen.dart';
import 'package:malomati/presentation/ui/more/hr_government_law.dart';

class ServicesNavigatorScreen extends StatelessWidget {
  const ServicesNavigatorScreen({Key? key}) : super(key: key);
  static final moreKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: moreKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext _) => const ServicesScreen();
              break;
            case HRGovernmentLaw.route:
              builder = (BuildContext _) {
                return const ServicesScreen();
              };
            // break;
            default:
              builder = (BuildContext _) => HomeScreen();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        });
  }
}
