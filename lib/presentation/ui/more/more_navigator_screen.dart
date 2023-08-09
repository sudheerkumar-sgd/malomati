import 'package:flutter/material.dart';
import 'package:malomati/presentation/ui/home/home_screen.dart';
import 'package:malomati/presentation/ui/home/more_screen.dart';
import 'package:malomati/presentation/ui/more/hr_government_law.dart';
import 'package:malomati/presentation/ui/more/privacy_and_policy.dart';

import 'about_malomati.dart';

class MoreNavigatorScreen extends StatelessWidget {
  const MoreNavigatorScreen({Key? key}) : super(key: key);
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
              builder = (BuildContext _) => MoreScreen();
              break;
            case HRGovernmentLaw.route:
              builder = (BuildContext _) {
                return const HRGovernmentLaw();
              };
              break;
            case PrivacyAndPolicy.route:
              builder = (BuildContext _) {
                return const PrivacyAndPolicy();
              };
              break;
            case AboutMalomati.route:
              builder = (BuildContext _) {
                return const AboutMalomati();
              };
              break;
            default:
              builder = (BuildContext _) => HomeScreen();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        });
  }
}
