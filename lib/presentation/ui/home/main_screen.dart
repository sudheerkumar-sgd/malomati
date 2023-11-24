// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:malomati/config/firbase_config.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';
import 'package:malomati/presentation/ui/home/services_screen.dart';
import 'package:malomati/presentation/ui/more/more_navigator_screen.dart';
import 'package:malomati/presentation/ui/services/services_navigator_screen.dart';
import 'package:malomati/presentation/ui/widgets/notification_dialog_widget.dart';
import 'package:malomati/presentation/ui/widgets/update_dialog_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import '../../../config/constant_config.dart';
import '../../../core/constants/data_constants.dart';
import '../requests/requests_navigator_screen.dart';
import '../utils/NavbarNotifier.dart';
import '../widgets/image_widget.dart';
import 'home_navigator_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:update_available/update_available.dart';

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
    if (path.toLowerCase().contains('http://') || path.contains('https://')) {
      _player.setUrl(path);
    } else {
      _player.setAsset(path);
    }
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
        return const RequestsNavigatorScreen();
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
      final message = initialMessage.data;
      _handleMessage(
          {'notification': initialMessage.notification, 'data': message});
    }

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      final message = remoteMessage.data;
      _handleMessage(
          {'notification': remoteMessage.notification, 'data': message});
    });

    FirbaseConfig.onFirbaseMessageOpened.addListener(() {
      _handleMessage({'data': FirbaseConfig.onFirbaseMessageOpened.value});
    });
  }

  void _handleMessage(Map<String, dynamic>? message) {
    if (message != null) {
      if (message['data']['type'] == fcmTypeHRApprovals) {
        ServicesScreen.onServiceClick(
            context, FavoriteEntity(name: 'HR APPROVALS'));
      } else if (message['data']['type'] == fcmTypeFinanceApprovals) {
        ServicesScreen.onServiceClick(
            context, FavoriteEntity(name: 'Finance Approvals'));
      } else if (message['data']['type'] == 'POPUP') {
        if (message['data']['audio_url'].isNotEmpty) {
          initAudio(message['data']['audio_url']);
        }
        showDialog(
            context: context,
            builder: (context) {
              return NotificationDialogWidget(
                title:
                    message['notification']?.title ?? message['data']['title'],
                message:
                    message['notification']?.body ?? message['data']['body'],
                imageUrl: Platform.isAndroid
                    ? message['notification']?.android?.imageUrl ??
                        message['data']['image_url']
                    : message['notification']?.apple?.imageUrl ??
                        message['data']['image_url'],
              );
            });
      }
    }
  }

  _checkIsUpdateAvailabe() {
    getUpdateAvailability().then((availability) {
      if (availability == const UpdateAvailable()) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                  onWillPop: () async => false,
                  child: const UpdateDialogWidget());
            });
      }
    });
  }

  @override
  void initState() {
    ConstantConfig.badgeCount = 0;
    Future.delayed(const Duration(seconds: 1), () {
      setupFirebaseNotificationMessage();
      FlutterAppBadger.isAppBadgeSupported()
          .then((value) => FlutterAppBadger.removeBadge());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: context.resources.color.appScaffoldBg,
        statusBarIconBrightness: Brightness.dark));
    Future.delayed(const Duration(milliseconds: 500), () {
      _showBirthday(context);
      ConstantConfig.onFCMMessageReceived.addListener(() {
        if (!notificationUser.contains(context.userDB
            .get(userNameKey, defaultValue: '')
            .toString()
            .toUpperCase())) {
          _handleMessage(ConstantConfig.onFCMMessageReceived.value);
          ConstantConfig.onFCMMessageReceived.value = null;
        }
      });
      _checkIsUpdateAvailabe();
    });
    return WillPopScope(
      onWillPop: () async {
        final bool isExitingApp =
            await _navbarNotifier.onBackButtonPressed(_selectedIndex.value);
        if (isExitingApp) {
          if (backpressCount >= 1) {
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
