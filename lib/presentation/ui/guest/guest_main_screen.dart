// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/home/requests_screen.dart';
import 'package:malomati/presentation/ui/more/more_navigator_screen.dart';
import 'package:malomati/presentation/ui/services/services_navigator_screen.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import '../../../core/common/common_utils.dart';
import '../utils/NavbarNotifier.dart';

class GuestMainScreen extends StatefulWidget {
  const GuestMainScreen({super.key});
  @override
  State<StatefulWidget> createState() => _GuestMainScreenState();
}

class _GuestMainScreenState extends State<GuestMainScreen> {
  final NavbarNotifier _navbarNotifier = NavbarNotifier();
  int backpressCount = 0;
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  void _onItemTapped(int index) {
    if (_selectedIndex.value == index) {
      _navbarNotifier.onGustBackButtonPressed(_selectedIndex.value);
    }
    if (index == 1 || index == 2) {
      logout(context);
    } else {
      _selectedIndex.value = index;
    }
  }

  Widget getScreen(int index) {
    switch (index) {
      case 1:
        return const ServicesNavigatorScreen();
      case 2:
        return RequestsScreen();
      case 3:
        return const MoreNavigatorScreen();
      default:
        return const ServicesNavigatorScreen();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: context.resources.color.appScaffoldBg,
        statusBarIconBrightness: Brightness.dark));
    return WillPopScope(
      onWillPop: () async {
        final bool isExitingApp =
            await _navbarNotifier.onBackButtonPressed(_selectedIndex.value);
        if (isExitingApp) {
          if (backpressCount > 1) {
            return isExitingApp;
          } else {
            backpressCount++;
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Center(child: Text("press again to exit app")),
              ));
            }
            return false;
          }
        } else {
          return isExitingApp;
        }
      },
      child: Container(
        color: context.resources.color.appScaffoldBg,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: gradient,
        //     stops: stops,
        //     end: Alignment.bottomCenter,
        //     begin: Alignment.topCenter,
        //   ),
        // ),
        child: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: _selectedIndex,
              builder: (context, value, widget) {
                return Scaffold(
                  body: getScreen(value),
                  //_widgetOptions(context),
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
                              color: _selectedIndex.value == 0
                                  ? context
                                      .resources.color.bottomSheetIconSelected
                                  : context.resources.color
                                      .bottomSheetIconUnSelected,
                            ),
                            label: context.string.home,
                          ),
                          BottomNavigationBarItem(
                            icon: SvgPicture.asset(
                              DrawableAssets.icSelfService,
                              width: 24,
                              height: 24,
                              fit: BoxFit.fill,
                              color: _selectedIndex.value == 1
                                  ? context
                                      .resources.color.bottomSheetIconSelected
                                  : context.resources.color
                                      .bottomSheetIconUnSelected,
                            ),
                            label: context.string.services,
                          ),
                          BottomNavigationBarItem(
                            icon: SvgPicture.asset(
                              DrawableAssets.icRequest,
                              width: 24,
                              height: 24,
                              fit: BoxFit.fill,
                              color: _selectedIndex.value == 2
                                  ? context
                                      .resources.color.bottomSheetIconSelected
                                  : context.resources.color
                                      .bottomSheetIconUnSelected,
                            ),
                            label: context.string.requests,
                          ),
                          BottomNavigationBarItem(
                            icon: SvgPicture.asset(
                              DrawableAssets.icMore,
                              width: 24,
                              height: 24,
                              fit: BoxFit.fill,
                              color: _selectedIndex.value == 3
                                  ? context
                                      .resources.color.bottomSheetIconSelected
                                  : context.resources.color
                                      .bottomSheetIconUnSelected,
                            ),
                            label: context.string.more,
                          ),
                        ],
                        type: BottomNavigationBarType.fixed,
                        currentIndex: _selectedIndex.value,
                        selectedItemColor:
                            context.resources.color.bottomSheetIconSelected,
                        unselectedItemColor:
                            context.resources.color.bottomSheetIconUnSelected,
                        backgroundColor: Colors.white,
                        selectedFontSize: context.resources.fontSize.dp12,
                        unselectedFontSize: context.resources.fontSize.dp12,
                        onTap: _onItemTapped,
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
