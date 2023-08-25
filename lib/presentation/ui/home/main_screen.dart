// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/home/requests_screen.dart';
import 'package:malomati/presentation/ui/more/more_navigator_screen.dart';
import 'package:malomati/presentation/ui/services/services_navigator_screen.dart';
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
  final _screens = <Widget>[
    const HomeNavigatorScreen(),
    const ServicesNavigatorScreen(),
    RequestsScreen(),
    const MoreNavigatorScreen(),
  ];
  final AudioPlayer _player = AudioPlayer();

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  void initAudio() {
    _player.setLoopMode(LoopMode.off);
    _player.setAsset(DrawableAssets.audioBirthday);
    _player.play();
  }

  _showBirthday(BuildContext context) async {
    initAudio();
    showDialog(
        context: context,
        builder: (context) => Dialog(
            child: ImageWidget(
                    path: context.resources.isLocalEn
                        ? DrawableAssets.gifBirthdayEn
                        : DrawableAssets.gifBirthdayAr)
                .loadImage)).then((value) => _player.dispose());
  }

  @override
  Widget build(BuildContext context) {
    // Timer(const Duration(seconds: 3), () {
    //   _showBirthday(context);
    // });
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
      child: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: _selectedIndex,
            builder: (context, value, widget) {
              return Scaffold(
                body: IndexedStack(
                    index: _selectedIndex.value, children: _screens),
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
                                : context
                                    .resources.color.bottomSheetIconUnSelected,
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
                                : context
                                    .resources.color.bottomSheetIconUnSelected,
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
                                : context
                                    .resources.color.bottomSheetIconUnSelected,
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
                                : context
                                    .resources.color.bottomSheetIconUnSelected,
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
                      selectedFontSize: 12,
                      unselectedFontSize: 12,
                      onTap: _onItemTapped,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
