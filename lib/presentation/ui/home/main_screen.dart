import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/home/more_screen.dart';
import 'package:malomati/presentation/ui/home/requests_screen.dart';
import 'package:malomati/presentation/ui/home/services_screen.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../utils/NavbarNotifier.dart';
import 'home_navigator_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainScreen> {
  int _selectedIndex = 0;
  final NavbarNotifier _navbarNotifier = NavbarNotifier();
  int backpressCount = 0;
  final _screens = <Widget>[
    const HomeNavigatorScreen(),
    const ServicesScreen(),
    RequestsScreen(),
    MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool isExitingApp =
            await _navbarNotifier.onBackButtonPressed(_selectedIndex);
        // if (isExitingApp) {
        //   if (backpressCount > 1) {
        //     return isExitingApp;
        //   } else {
        //     backpressCount++;
        //     if (mounted) {
        //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //         content: Center(child: Text("press again to exit app")),
        //       ));
        //     }
        //     return false;
        //   }
        // } else {
        return isExitingApp;
        // }
      },
      child: SafeArea(
        child: Scaffold(
          body: IndexedStack(
              index: _selectedIndex,
              children: _screens), //_widgetOptions(context),
          backgroundColor: context.resources.color.appScaffoldBg,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(context.resources.dimen.dp20)),
              boxShadow: kElevationToShadow[4],
            ),
            margin: EdgeInsets.all(context.resources.dimen.dp10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(context.resources.dimen.dp20),
              ),
              child: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      DrawableAssets.icHome,
                      width: 24,
                      height: 24,
                      fit: BoxFit.fill,
                      color: _selectedIndex == 0
                          ? context.resources.color.bottomSheetIconSelected
                          : context.resources.color.bottomSheetIconUnSelected,
                    ),
                    label: context.string.home,
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      DrawableAssets.icSelfService,
                      width: 24,
                      height: 24,
                      fit: BoxFit.fill,
                      color: _selectedIndex == 1
                          ? context.resources.color.bottomSheetIconSelected
                          : context.resources.color.bottomSheetIconUnSelected,
                    ),
                    label: context.string.services,
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      DrawableAssets.icRequest,
                      width: 24,
                      height: 24,
                      fit: BoxFit.fill,
                      color: _selectedIndex == 2
                          ? context.resources.color.bottomSheetIconSelected
                          : context.resources.color.bottomSheetIconUnSelected,
                    ),
                    label: context.string.requests,
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      DrawableAssets.icMore,
                      width: 24,
                      height: 24,
                      fit: BoxFit.fill,
                      color: _selectedIndex == 3
                          ? context.resources.color.bottomSheetIconSelected
                          : context.resources.color.bottomSheetIconUnSelected,
                    ),
                    label: context.string.more,
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                selectedItemColor:
                    context.resources.color.bottomSheetIconSelected,
                unselectedItemColor:
                    context.resources.color.bottomSheetIconUnSelected,
                backgroundColor: Colors.white,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                onTap: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
