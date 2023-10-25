import 'package:flutter/material.dart';
import 'package:malomati/presentation/ui/home/requests_screen.dart';

class RequestsNavigatorScreen extends StatelessWidget {
  const RequestsNavigatorScreen({Key? key}) : super(key: key);
  static var requestKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    requestKey = GlobalKey<NavigatorState>();
    return Navigator(
        key: requestKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext _) => RequestsScreen();
              break;
            default:
              builder = (BuildContext _) => RequestsScreen();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        });
  }
}
