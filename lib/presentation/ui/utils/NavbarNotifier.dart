import 'dart:async';

import 'package:flutter/material.dart';

import '../home/home_navigator_screen.dart';

class NavbarNotifier extends ChangeNotifier {
  int _index = 0;
  int get index => _index;
  bool _hideBottomNavBar = false;

  set index(int x) {
    _index = x;
    notifyListeners();
  }

  bool get hideBottomNavBar => _hideBottomNavBar;
  set hideBottomNavBar(bool x) {
    _hideBottomNavBar = x;
    notifyListeners();
  }

  // pop routes from the nested navigator stack and not the main stack
  // this is done based on the currentIndex of the bottom navbar
  // if the backButton is pressed on the initial route the app will be terminated
  FutureOr<bool> onBackButtonPressed(int index) async {
    bool exitingApp = true;
    switch (index) {
      case 0:
        if (HomeNavigatorScreen.homeKey.currentState != null &&
            HomeNavigatorScreen.homeKey.currentState!.canPop()) {
          HomeNavigatorScreen.homeKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      default:
        return false;
    }
    if (exitingApp) {
      return true;
    } else {
      return false;
    }
  }

  // pops all routes except first, if there are more than 1 route in each navigator stack
  void popAllRoutes(int index) {
    switch (index) {
      case 0:
        if (HomeNavigatorScreen.homeKey.currentState!.canPop()) {
          HomeNavigatorScreen.homeKey.currentState!
              .popUntil((route) => route.isFirst);
        }
        return;
      default:
        break;
    }
  }
}
