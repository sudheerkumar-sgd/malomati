// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/presentation/ui/home/requests_screen.dart';
import 'package:malomati/presentation/ui/more/more_navigator_screen.dart';
import 'package:malomati/presentation/ui/services/services_navigator_screen.dart';
import 'package:malomati/presentation/ui/widgets/notification_dialog_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import '../utils/NavbarNotifier.dart';
import '../widgets/image_widget.dart';
import 'home_navigator_screen.dart';
import 'package:just_audio/just_audio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final NavbarNotifier _navbarNotifier = NavbarNotifier();
  int backpressCount = 0;
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  // final _screens = <Widget>[
  //   const HomeNavigatorScreen(),
  //   const ServicesNavigatorScreen(),
  //   RequestsScreen(),
  //   const MoreNavigatorScreen(),
  // ];
  final AudioPlayer _player = AudioPlayer();

  void _onItemTapped(int index) {
    if (_selectedIndex.value == index) {
      _navbarNotifier.onBackButtonPressed(_selectedIndex.value);
    }
    _selectedIndex.value = index;
  }

  void initAudio(String path) {
    _player.setLoopMode(LoopMode.off);
    _player.setAsset(path);
    _player.play();
  }

  _showBirthday(BuildContext context) async {
    if ((context.userDB
            .get(userDateOfBirthKey, defaultValue: '')
            .contains(getDateByformat('dd-MMM', DateTime.now()))) &&
        !(context.userDB.get('$isDateOfBirthShowedKey${DateTime.now().year}',
            defaultValue: false))) {
      context.userDB.put('$isDateOfBirthShowedKey${DateTime.now().year}', true);
      initAudio(DrawableAssets.audioBirthday);
      showDialog(
          context: context,
          builder: (context) => Dialog(
              child: ImageWidget(
                      path: context.resources.isLocalEn
                          ? DrawableAssets.gifBirthdayEn
                          : DrawableAssets.gifBirthdayAr)
                  .loadImage)).then((value) => _player.dispose());
    } else if ((context.userDB
            .get(userJoiningDateEnKey, defaultValue: '')
            .contains(getDateByformat('dd-MMM', DateTime.now()))) &&
        !(context.userDB.get('$isAnniversaryShowedKey${DateTime.now().year}',
            defaultValue: false))) {
      context.userDB.put('$isAnniversaryShowedKey${DateTime.now().year}', true);
      initAudio(DrawableAssets.audioAnniversay);
      showDialog(
          context: context,
          builder: (context) => Dialog(
              child: ImageWidget(
                      path: context.resources.isLocalEn
                          ? DrawableAssets.gifAnniversayEn
                          : DrawableAssets.gifAnniversayAr)
                  .loadImage)).then((value) => _player.dispose());
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
        return const HomeNavigatorScreen();
    }
  }

  Future<void> setupFirebaseNotificationMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage? message) {
    if (message != null) {
      showDialog(
          context: context,
          builder: (context) {
            return NotificationDialogWidget(
              title: message.notification?.title ?? '',
              message: message.notification?.body ?? '',
              imageUrl: Platform.isAndroid
                  ? message.notification?.android?.imageUrl ?? ''
                  : message.notification?.apple?.imageUrl ?? '',
            );
          });
    }
  }

  initNotificationListeners() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        showDialog(
            context: context,
            builder: (context) {
              return NotificationDialogWidget(
                title: message.notification?.title ?? '',
                message: message.notification?.body ?? '',
                imageUrl: Platform.isAndroid
                    ? message.notification?.android?.imageUrl ?? ''
                    : message.notification?.apple?.imageUrl ?? '',
              );
            });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showDialog(
          context: context,
          builder: (context) {
            return NotificationDialogWidget(
              title: message.notification?.title ?? '',
              message: message.notification?.body ?? '',
              imageUrl: Platform.isAndroid
                  ? message.notification?.android?.imageUrl ?? ''
                  : message.notification?.apple?.imageUrl ?? '',
            );
          });
    });
  }

  @override
  void initState() {
    setupFirebaseNotificationMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Timer(const Duration(seconds: 3), () {
    //   _showBirthday(context);
    // });
    // final Color background = context.resources.color.appScaffoldBg;
    // final Color fill = context.resources.color.appScaffoldBg;
    // final List<Color> gradient = [
    //   background,
    //   background,
    //   fill,
    //   fill,
    // ];
    // const double fillPercent = 80; // fills 56.23% for container from bottom
    // const double fillStop = (100 - fillPercent) / 100;
    // final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: context.resources.color.appScaffoldBg,
        statusBarIconBrightness: Brightness.dark));
    Future.delayed(const Duration(milliseconds: 500), () {
      _showBirthday(context);
    });
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
