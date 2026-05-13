import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/config/firbase_config.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/force_value_notifier.dart';
import 'package:malomati/core/managers/location_access_manager.dart';
import 'package:malomati/core/network/api_urls.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';
import 'package:malomati/domain/entities/weather_entity.dart';
import 'package:malomati/features/home/presentation/home_session_side_effects.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:malomati/presentation/bloc/home/home_bloc.dart';
import 'package:malomati/presentation/ui/home/attendance_screen.dart';
import 'package:malomati/presentation/ui/home/services_screen.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_events.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_leaves.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_service.dart';
import 'package:malomati/presentation/ui/home/widgets/services_list.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/alert_dialog_widget.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/page_indicator.dart';
import 'package:malomati/presentation/ui/widgets/user_app_bar.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:workmanager/workmanager.dart';

import '../../../core/common/common_utils.dart';
import '../../../core/constants/data_constants.dart';
import '../../../core/enum.dart';
import '../../../res/drawables/background_box_decoration.dart';
import '../utils/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _homeBloc = sl<HomeBloc>();
  final _attendanceBloc = sl<AttendanceBloc>();
  final ValueNotifier<DashboardEntity> _dashboardEntity =
      ValueNotifier<DashboardEntity>(DashboardEntity());
  final ValueNotifier<List<EventsEntity>> _eventsListEntity =
      ValueNotifier<List<EventsEntity>>([]);
  final ValueNotifier<List<FavoriteEntity>> _favoriteEntity =
      ValueNotifier<List<FavoriteEntity>>([]);
  final ValueNotifier<WeatherEntity> _weatherEntity =
      ValueNotifier<WeatherEntity>(WeatherEntity());
  final ValueNotifier _eventBannerChange = ValueNotifier<int>(0);
  final ValueNotifier _isFavoriteEdited = ValueNotifier<bool>(false);

  final ValueNotifier<int> _punchStatus = ValueNotifier<int>(-1);
  final ValueNotifier<int> _onAttendanceRespose = ValueNotifier<int>(-1);

  final ForceValueNotifier<String> _remainingTimeValue =
      ForceValueNotifier<String>('00:00:00');
  Timer? _punchRemainingTimer;
  Timer? _eventBannerTimer;
  final _locationAccessManager = sl<LocationAccessManager>();
  final PageController _eventsPageController = PageController(initialPage: 0);
  Future<AttendanceState>? _userPunchDetailsFuture;
  final ValueNotifier<AttendanceEntity> _liveAttendance =
      ValueNotifier<AttendanceEntity>(AttendanceEntity());
  bool _didInitHomeDependencies = false;
  bool _wasPaused = false;

  // notification state for work‑hour completion
  bool _workNotificationScheduled = false;
  static const int _workNotificationId = 100;

  void _setRemainingTimeValue(String value) {
    _remainingTimeValue.setAndNotify(value);
  }

  void _onAttendanceResponseTick() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      _punchStatus.value = _onAttendanceRespose.value;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      _locationAccessManager.loadLocationAccessDepartments();
    });
    _onAttendanceRespose.addListener(_onAttendanceResponseTick);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasPaused = true;
    } else if (state == AppLifecycleState.resumed && _wasPaused) {
      _wasPaused = false;
      if (mounted) {
        _refreshAttendance(notifyOnFailure: false);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitHomeDependencies) return;
    _didInitHomeDependencies = true;

    final userDB = context.userDB;
    final userName = userDB.get(userNameKey, defaultValue: '');

    _weatherEntity.value = WeatherEntity(
      temperature: userDB.get(lastTemperature, defaultValue: 0),
      weathercode: userDB.get(lastWeathercode, defaultValue: 1),
    );

    // After first frame so route + inherited scope (e.g. user DB) are stable; also
    // avoids races when the home tab is rebuilt after switching bottom tabs.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshAttendance(notifyOnFailure: false);
    });
    _homeBloc.getDashboardData(userName: userName);
    _homeBloc.getEventsData(
      departmentId: userDB.get(departmentIdKey, defaultValue: ''),
    );
    _homeBloc.getFavoritesdData(userDB: userDB);
    _homeBloc.getRequestsCount(requestParams: {'USER_NAME': userName});

    _userPunchDetailsFuture = _attendanceBloc.getUserDetails(
      apiUrl: attendanceUserPunchDetailsApiUrl,
      requestParams: {},
      emitResult: false,
    );

    Future.delayed(const Duration(milliseconds: 100), () async {
      if (!mounted) return;
      final ctx = context;
      _homeBloc.getNotificationsList(requestParams: {
        'USER_NAME': userName,
        'START_DATE': getDateByformat(
            'yyy-MM-dd', DateTime.now().subtract(const Duration(days: 2))),
        'END_DATE': getDateByformat(
            'yyy-MM-dd', DateTime.now().add(const Duration(days: 1))),
      });
      if (ctx.userDB.get(lastWeatherCheckDate) == null ||
          getMinutes(ctx.userDB.get(lastWeatherCheckDate), DateTime.now()) >
              120) {
        _getWeatherDetails();
      }
      _homeBloc.getFCMAccessToken(userDB: ctx.userDB);
    });

    if (context.userDB.get(showRatingMonth, defaultValue: -1) !=
        DateTime.now().month) {
      Future.delayed(const Duration(milliseconds: 2000), () async {
        final InAppReview inAppReview = InAppReview.instance;
        if (await inAppReview.isAvailable()) {
          inAppReview.requestReview();
          if (mounted) {
            context.userDB.put(showRatingMonth, DateTime.now().month);
          }
        }
      });
    }

    _eventBannerTimer?.cancel();
    _eventBannerTimer = startTimer(
      duration: const Duration(seconds: 4),
      callback: () {
        if (!mounted) return;
        if (_eventsListEntity.value.length <= 1) return;
        final nextIndex =
            _eventBannerChange.value == _eventsListEntity.value.length - 1
                ? 0
                : _eventBannerChange.value + 1;
        if (nextIndex > 0) {
          _eventsPageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          );
        } else {
          _eventsPageController.jumpToPage(nextIndex);
        }
      },
    );

    _userPunchDetailsFuture = _attendanceBloc.getUserDetails(
      apiUrl: attendanceUserPunchDetailsApiUrl,
      requestParams: {},
      emitResult: false,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _onAttendanceRespose.removeListener(_onAttendanceResponseTick);
    _eventBannerTimer?.cancel();
    _punchRemainingTimer?.cancel();
    _eventsPageController.dispose();
    _dashboardEntity.dispose();
    _eventsListEntity.dispose();
    _favoriteEntity.dispose();
    _weatherEntity.dispose();
    _eventBannerChange.dispose();
    _isFavoriteEdited.dispose();
    _punchStatus.dispose();
    _onAttendanceRespose.dispose();
    _remainingTimeValue.dispose();
    _liveAttendance.dispose();
    _attendanceBloc.close();
    super.dispose();
  }

  _calculateRemainingTime(
      BuildContext context, String? punch1Time, String? punch2Time) async {
    if (punch1Time == null ||
        punch1Time.isEmpty ||
        (punch2Time != null && punch2Time.isNotEmpty)) {
      _setRemainingTimeValue('00:00:00');
      _punchRemainingTimer?.cancel();
      _punchRemainingTimer = null;
      await Workmanager().cancelAll();
      FirbaseConfig.cancelNotification(_workNotificationId);
      _workNotificationScheduled = false;
      return;
    }

    if (_punchRemainingTimer != null) return;

    // compute target time once and schedule notification
    final now = DateTime.now();
    final punchInParts = punch1Time.split(':');
    if (punchInParts.length >= 3) {
      final punchInToday = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(punchInParts[0]),
          int.parse(punchInParts[1]),
          int.parse(punchInParts[2]));

      var targetTime = punchInToday.add(now.weekday == DateTime.friday
          ? const Duration(hours: 4, minutes: 30)
          : const Duration(hours: 8));
      final limitTime = now.weekday == DateTime.friday
          ? DateTime(now.year, now.month, now.day, 12, 30, 0)
          : DateTime(now.year, now.month, now.day, 16, 0, 0);
      if (targetTime.isAfter(limitTime)) {
        targetTime = limitTime;
      }
      final diff = targetTime.difference(now);
      if (!diff.isNegative && !_workNotificationScheduled) {
        if (Platform.isAndroid) {
          await Workmanager().cancelAll();
          initWorkmanagerTask(diff);
        } else {
          FirbaseConfig.cancelNotification(_workNotificationId);
          FirbaseConfig.scheduleLocalNotification(
            id: _workNotificationId,
            title: context.string.workNotificationTitle,
            body: context.string.workNotificationBody,
            scheduledDate: targetTime,
          );
        }
        _workNotificationScheduled = true;
      }
    }

    _punchRemainingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final now = DateTime.now();
      final punchInParts = punch1Time.split(':');
      if (punchInParts.length < 3) return;

      final punchInToday = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(punchInParts[0]),
          int.parse(punchInParts[1]),
          int.parse(punchInParts[2]));

      var targetTime = punchInToday.add(now.weekday == DateTime.friday
          ? const Duration(hours: 4, minutes: 30)
          : const Duration(hours: 8));
      final limitTime = now.weekday == DateTime.friday
          ? DateTime(now.year, now.month, now.day, 12, 30, 0)
          : DateTime(now.year, now.month, now.day, 16, 0, 0);

      if (targetTime.isAfter(limitTime)) {
        targetTime = limitTime;
      }

      final diff = targetTime.difference(now);
      if (diff.isNegative) {
        _setRemainingTimeValue('00:00:00');
        timer.cancel();
        _punchRemainingTimer = null;
      } else {
        String twoDigits(int n) => n.toString().padLeft(2, "0");
        String twoDigitMinutes = twoDigits(diff.inMinutes.remainder(60));
        String twoDigitSeconds = twoDigits(diff.inSeconds.remainder(60));
        _setRemainingTimeValue(
            "${twoDigits(diff.inHours)}:$twoDigitMinutes:$twoDigitSeconds");
      }
    });
  }

  void _refreshAttendance({bool notifyOnFailure = false}) {
    var date = getDateByformat('ddMMyyyy', DateTime.now());
    Map<String, dynamic> attendanceRequestParams = {
      'date-range': '$date-$date',
    };
    _attendanceBloc
        .getUserAttendance(requestParams: attendanceRequestParams)
        .then((state) {
      if (state is OnAttendanceSuccess) {
        final entity =
            state.attendanceEntity.entity?.attendanceList.firstOrNull ??
                AttendanceEntity();
        if (!mounted) return;
        _liveAttendance.value = entity;
        if ((entity.punch2Time ?? '').isNotEmpty) {
          _onAttendanceRespose.value = 2;
        } else if ((entity.punch1Time ?? '').isNotEmpty) {
          _onAttendanceRespose.value = 1;
        } else {
          _onAttendanceRespose.value = 0;
        }
        _calculateRemainingTime(context, entity.punch1Time, entity.punch2Time);
      } else if (state is OnAttendanceApiError) {
        if (!mounted) return;
        _liveAttendance.value = AttendanceEntity();
        _onAttendanceRespose.value = -1;
        _setRemainingTimeValue('00:00:00');
        _punchRemainingTimer?.cancel();
        _punchRemainingTimer = null;
        if (notifyOnFailure) {
          final message = state.message.isNotEmpty
              ? state.message
              : context.string.noInternet;
          Dialogs.showInfoDialog(
            context,
            PopupType.fail,
            message,
          );
        }
      }
    }, onError: (_) {
      if (!mounted) return;
      _liveAttendance.value = AttendanceEntity();
      _onAttendanceRespose.value = -1;
      _setRemainingTimeValue('00:00:00');
      _punchRemainingTimer?.cancel();
      _punchRemainingTimer = null;
      if (notifyOnFailure) {
        Dialogs.showInfoDialog(
          context,
          PopupType.fail,
          context.string.noInternet,
        );
      }
    });
  }

  _addFavorite(BuildContext context, FavoriteEntity favoriteEntity) {
    Navigator.pop(context);
    _homeBloc.saveFavoritesdData(
        userDB: context.userDB, favoriteEntity: favoriteEntity);
  }

  _removeFavorite(BuildContext context, FavoriteEntity favoriteEntity) {
    _homeBloc.removeFavoritesdData(
        userDB: context.userDB, favoriteEntity: favoriteEntity);
  }

  String _getPunchTextByStatus(BuildContext context, int status) {
    if (status == -1) {
      return '';
    } else if (status == 0) {
      return context.string.youDidntPunchYet;
    } else if (status == 1) {
      return context.string.thankYouForPunchIn;
    } else {
      return context.string.thankYouForPunchOut;
    }
  }

  _getWeatherDetails() async {
    var isLocationOn = await Location.checkGps();
    if (isLocationOn) {
      Location.getLocation().then((value) {
        if (!mounted) return;
        _homeBloc.getWeatherReport(requestParams: {
          'latitude': value.latitude,
          'longitude': value.longitude,
          'current_weather': true,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final currentDayName = getDateByformat('EEEE', currentDate);
    final currentDay = getDateByformat('dd', currentDate);
    final currentMonth = getDateByformat('MMMM', DateTime.now());
    final currentYear = DateTime.now().year;
    return SafeArea(
      child: Scaffold(
          backgroundColor: context.resources.color.appScaffoldBg,
          body: BlocProvider<HomeBloc>(
            create: (context) => _homeBloc,
            child: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  HomeSessionSideEffects.applyFromHomeState(
                    context,
                    state,
                    dashboardEntity: _dashboardEntity,
                    eventsListEntity: _eventsListEntity,
                    favoriteEntity: _favoriteEntity,
                    weatherEntity: _weatherEntity,
                  );
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: context.resources.dimen.dp30,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.resources.dimen.dp25),
                      child: UserAppBarWidget(
                        title: context.userDB
                            .get(
                                context.resources.isLocalEn
                                    ? userFullNameUsKey
                                    : userFullNameArKey,
                                defaultValue: '')
                            .toString(),
                      ),
                    ),
                    SizedBox(
                      height: context.resources.dimen.dp20,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: context.resources.dimen.dp15,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: context.resources.dimen.dp25,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(context.resources.dimen.dp20)),
                          gradient: LinearGradient(
                            colors: [
                              context.resources.color.bgGradientStart,
                              context.resources.color.bgGradientEnd,
                            ],
                          ),
                          image: const DecorationImage(
                            alignment: Alignment.topRight,
                            image: AssetImage(DrawableAssets.icHomeCoverRing),
                          )),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 74,
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(text: '\n', children: [
                                          TextSpan(
                                            text:
                                                '${context.resources.isLocalEn ? currentDayName : getArabicDayName(currentDayName)}\n',
                                            style: context.textFontWeight600
                                                .onFontFamily(
                                                    fontFamily: isLocalEn
                                                        ? fontFamilyEN
                                                        : fontFamilyAR)
                                                .onColor(context
                                                    .resources.color.colorWhite)
                                                .onFontSize(context
                                                    .resources.fontSize.dp16),
                                          ),
                                          TextSpan(
                                            text: '$currentDay ',
                                            style: context.textFontWeight600
                                                .onFontFamily(
                                                    fontFamily: fontFamilyEN)
                                                .onColor(context
                                                    .resources.color.colorWhite)
                                                .onFontSize(context
                                                    .resources.fontSize.dp16),
                                          ),
                                          TextSpan(
                                            text:
                                                '${context.resources.isLocalEn ? currentMonth : getArabicMonthName(currentMonth)}, ',
                                            style: context.textFontWeight600
                                                .onColor(context
                                                    .resources.color.colorWhite)
                                                .onFontSize(context
                                                    .resources.fontSize.dp16),
                                          ),
                                          TextSpan(
                                            text: '$currentYear',
                                            style: context.textFontWeight600
                                                .onColor(context
                                                    .resources.color.colorWhite)
                                                .onFontFamily(
                                                    fontFamily: fontFamilyEN)
                                                .onFontSize(context
                                                    .resources.fontSize.dp16),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: 74,
                                      height: 61,
                                      padding: EdgeInsets.only(
                                          top: context.resources.dimen.dp7,
                                          right: isLocalEn
                                              ? context.resources.dimen.dp12
                                              : 0,
                                          left: isLocalEn
                                              ? 0
                                              : context.resources.dimen.dp12),
                                      transform: Matrix4.translationValues(
                                          isLocalEn ? 2.0 : -2.0, -1, 0.0),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                          isLocalEn
                                              ? DrawableAssets.bgWeather
                                              : DrawableAssets.bgWeatherAr,
                                        ),
                                      )),
                                      child: ValueListenableBuilder(
                                          valueListenable: _weatherEntity,
                                          builder: (context, value, child) {
                                            String iconPath = getWeatherIcon(
                                                value.weathercode ?? 0);
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                ImageWidget(
                                                        path: iconPath,
                                                        backgroundTint: context
                                                            .resources
                                                            .iconBgColor)
                                                    .loadImage,
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  '${(value.temperature ?? 0).round()}\u2103',
                                                  style: context
                                                      .textFontWeight600
                                                      .onFontSize(context
                                                          .resources
                                                          .fontSize
                                                          .dp11)
                                                      .onColor(context.resources
                                                          .iconBgColor)
                                                      .onFontFamily(
                                                          fontFamily:
                                                              fontFamilyEN),
                                                ),
                                              ],
                                            );
                                          })),
                                  // const Spacer(),
                                  // ImageWidget(
                                  //         path: DrawableAssets.icWeather,
                                  //         backgroundTint:
                                  //             context.resources.iconBgColor)
                                  //     .loadImage
                                ],
                              ),
                              ValueListenableBuilder(
                                  valueListenable: _punchStatus,
                                  builder: (context, punchStatus, widget) {
                                    return Text(
                                      _getPunchTextByStatus(
                                          context, punchStatus),
                                      style: context.textFontWeight400
                                          .onColor(context
                                              .resources.color.colorWhite)
                                          .onFontSize(
                                              context.resources.fontSize.dp14),
                                    );
                                  }),
                              SizedBox(
                                height: context.resources.dimen.dp10,
                              ),
                              ValueListenableBuilder<AttendanceEntity>(
                                valueListenable: _liveAttendance,
                                builder: (context, attendanceEntity, _) {
                                  return FutureBuilder<AttendanceState>(
                                    future: _userPunchDetailsFuture,
                                    builder: (context, asyncSnapshot) {
                                      final state = asyncSnapshot.data;
                                      bool isPunchAccessDisabled = false;
                                      if (state is OnUserDetailsSuccess) {
                                        isPunchAccessDisabled = (state
                                                    .attendanceUserDetailsEntity
                                                    .entity
                                                    ?.usersData ??
                                                [])
                                            .where(
                                                (e) => e.punchApiAccess == '0')
                                            .toList()
                                            .isNotEmpty;
                                      }
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                width: context
                                                    .resources.dimen.dp15,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints(
                                                        minWidth:
                                                            double.infinity,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (!isPunchAccessDisabled) {
                                                            Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                type: PageTransitionType
                                                                    .rightToLeft,
                                                                child: AttendanceScreen(
                                                                    attendanceType:
                                                                        AttendanceType
                                                                            .punchIn,
                                                                    attendanceEntity:
                                                                        attendanceEntity),
                                                              ),
                                                            ).then((value) {
                                                              if (value ==
                                                                  true) {
                                                                _refreshAttendance();
                                                              }
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: context
                                                                  .resources
                                                                  .dimen
                                                                  .dp5,
                                                              horizontal:
                                                                  context
                                                                      .resources
                                                                      .dimen
                                                                      .dp10),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: context
                                                                      .resources
                                                                      .dimen
                                                                      .dp10),
                                                          decoration: BackgroundBoxDecoration(
                                                                  boxColor: context
                                                                      .resources
                                                                      .color
                                                                      .colorWhite,
                                                                  radious: context
                                                                      .resources
                                                                      .dimen
                                                                      .dp25,
                                                                  shadowColor: context
                                                                      .resources
                                                                      .color
                                                                      .textColorLight,
                                                                  shadowBlurRadius:
                                                                      context
                                                                          .resources
                                                                          .dimen
                                                                          .dp5)
                                                              .roundedBoxWithShadow,
                                                          child: Text(
                                                            context
                                                                .string.punchIn,
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: context
                                                                .textFontWeight600
                                                                .onColor(isPunchAccessDisabled
                                                                    ? Colors
                                                                        .grey
                                                                    : context
                                                                        .resources
                                                                        .color
                                                                        .textColor)
                                                                .onFontSize(context
                                                                    .resources
                                                                    .fontSize
                                                                    .dp14)
                                                                .copyWith(
                                                                    decoration: isPunchAccessDisabled
                                                                        ? TextDecoration
                                                                            .lineThrough
                                                                        : null),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: context
                                                          .resources.dimen.dp8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ImageWidget(
                                                                path: DrawableAssets
                                                                    .icPunchIn,
                                                                backgroundTint:
                                                                    context
                                                                        .resources
                                                                        .color
                                                                        .colorWhite)
                                                            .loadImage,
                                                        SizedBox(
                                                          width: context
                                                              .resources
                                                              .dimen
                                                              .dp10,
                                                        ),
                                                        Text(
                                                          (attendanceEntity
                                                                          .punch1Time ??
                                                                      '')
                                                                  .isNotEmpty
                                                              ? attendanceEntity
                                                                  .punch1Time!
                                                              : '00:00:00',
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontFamily(
                                                                  fontFamily:
                                                                      fontFamilyEN)
                                                              .onColor(context
                                                                  .resources
                                                                  .color
                                                                  .colorWhite)
                                                              .onFontSize(
                                                                  context
                                                                      .resources
                                                                      .fontSize
                                                                      .dp14),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints(
                                                        minWidth:
                                                            double.infinity,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (!isPunchAccessDisabled) {
                                                            Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                type: PageTransitionType
                                                                    .rightToLeft,
                                                                child:
                                                                    AttendanceScreen(
                                                                  attendanceType:
                                                                      AttendanceType
                                                                          .punchOut,
                                                                  attendanceEntity:
                                                                      attendanceEntity,
                                                                ),
                                                              ),
                                                            ).then((value) {
                                                              if (value ==
                                                                  true) {
                                                                _refreshAttendance();
                                                              }
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: context
                                                                  .resources
                                                                  .dimen
                                                                  .dp5,
                                                              horizontal:
                                                                  context
                                                                      .resources
                                                                      .dimen
                                                                      .dp20),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: context
                                                                      .resources
                                                                      .dimen
                                                                      .dp10),
                                                          decoration: BackgroundBoxDecoration(
                                                                  boxColor: context
                                                                      .resources
                                                                      .color
                                                                      .colorWhite,
                                                                  radious: context
                                                                      .resources
                                                                      .dimen
                                                                      .dp25,
                                                                  shadowColor: context
                                                                      .resources
                                                                      .color
                                                                      .textColorLight,
                                                                  shadowBlurRadius:
                                                                      context
                                                                          .resources
                                                                          .dimen
                                                                          .dp5)
                                                              .roundedBoxWithShadow,
                                                          child: Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            context.string
                                                                .punchOut,
                                                            style: context
                                                                .textFontWeight600
                                                                .onColor(isPunchAccessDisabled
                                                                    ? Colors
                                                                        .grey
                                                                    : context
                                                                        .resources
                                                                        .color
                                                                        .textColor)
                                                                .onFontSize(context
                                                                    .resources
                                                                    .fontSize
                                                                    .dp14)
                                                                .copyWith(
                                                                    decoration: isPunchAccessDisabled
                                                                        ? TextDecoration
                                                                            .lineThrough
                                                                        : null),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: context
                                                          .resources.dimen.dp10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ImageWidget(
                                                                path: DrawableAssets
                                                                    .icPunchOut,
                                                                backgroundTint:
                                                                    context
                                                                        .resources
                                                                        .color
                                                                        .colorWhite)
                                                            .loadImage,
                                                        SizedBox(
                                                          width: context
                                                              .resources
                                                              .dimen
                                                              .dp5,
                                                        ),
                                                        Text(
                                                          (attendanceEntity
                                                                          .punch2Time ??
                                                                      '')
                                                                  .isNotEmpty
                                                              ? attendanceEntity
                                                                  .punch2Time!
                                                              : '00:00:00',
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontFamily(
                                                                  fontFamily:
                                                                      fontFamilyEN)
                                                              .onColor(context
                                                                  .resources
                                                                  .color
                                                                  .colorWhite)
                                                              .onFontSize(
                                                                  context
                                                                      .resources
                                                                      .fontSize
                                                                      .dp14),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: context
                                                    .resources.dimen.dp15,
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable: _remainingTimeValue,
                        builder: (context, remainingTime, widget) {
                          if (remainingTime == '00:00:00' &&
                              (_onAttendanceRespose.value == 0 ||
                                  _onAttendanceRespose.value == 2)) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: context.resources.dimen.dp5,
                                horizontal: context.resources.dimen.dp20),
                            margin: EdgeInsets.symmetric(
                                horizontal: context.resources.dimen.dp50),
                            decoration: BackgroundBoxDecoration(
                              radious: context.resources.dimen.dp10,
                              gradientBegin: Alignment.topLeft,
                              gradientEnd: Alignment.topRight,
                              gradientColors: [
                                context.resources.color.colorTimerGradientStart,
                                context.resources.color.colorTimerGradientEnd,
                              ],
                            ).bottomCornerGradientBox,
                            child: Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                  text:
                                      '${context.string.remainingWorkTime} - ',
                                  style: context.textFontWeight600
                                      .onColor(
                                          context.resources.color.colorWhite)
                                      .onFontSize(
                                          context.resources.fontSize.dp10),
                                  children: [
                                    TextSpan(
                                        text: remainingTime,
                                        style: context.textFontWeight600
                                            .onColor(context
                                                .resources.color.colorWhite)
                                            .onFontSize(
                                                context.resources.fontSize.dp10)
                                            .onFontFamily(
                                                fontFamily: fontFamilyEN))
                                  ]),
                            ),
                          );
                        }),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: context.resources.dimen.dp20,
                            ),
                            ValueListenableBuilder(
                                valueListenable: _dashboardEntity,
                                builder: (context, dashboardEntity, widget) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            context.resources.dimen.dp25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: ItemDashboardLeaves(
                                            balanceCount:
                                                dashboardEntity.aNNUALACCRUAL ??
                                                    '0',
                                            balancetype: context.string.days,
                                            title: context.string.balanceLeaves,
                                          ),
                                        ),
                                        Flexible(
                                          child: ItemDashboardLeaves(
                                            balanceCount:
                                                dashboardEntity.sICKACCRUAL ??
                                                    '0',
                                            balancetype: context.string.days,
                                            title: context
                                                .string.balanceSickLeaves,
                                          ),
                                        ),
                                        Flexible(
                                          child: ItemDashboardLeaves(
                                            balanceCount:
                                                '${(dashboardEntity.pERMISSIONACCRUAL is double) ? (dashboardEntity.pERMISSIONACCRUAL ?? 0).toStringAsFixed(1) : dashboardEntity.pERMISSIONACCRUAL ?? 0}',
                                            balancetype: context.string.hours,
                                            title: context
                                                .string.balancePermission,
                                          ),
                                        ),
                                        Flexible(
                                          child: ItemDashboardLeaves(
                                            balanceCount: dashboardEntity
                                                    .tHANKYOUINYEAR ??
                                                '0',
                                            balancetype: context.string.star,
                                            title: context.string.totalThankYou,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                            ValueListenableBuilder(
                                valueListenable: _eventsListEntity,
                                builder: (context, eventsList, widget) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: context.resources.dimen.dp20,
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                context.resources.dimen.dp15),
                                        height: context.resources.dimen.dp80,
                                        child: eventsList.isEmpty
                                            ? ImageWidget(
                                                path: isLocalEn
                                                    ? DrawableAssets
                                                        .appmenubannnerEnglish
                                                    : DrawableAssets
                                                        .appmenubannnerArabic,
                                              ).loadImage
                                            : PageView(
                                                clipBehavior: Clip.none,
                                                controller:
                                                    _eventsPageController,
                                                children: [
                                                  for (int i = 0;
                                                      i < eventsList.length;
                                                      i++) ...[
                                                    ItemDashboardEvent(
                                                      eventsEntity:
                                                          eventsList[i],
                                                    )
                                                  ]
                                                ],
                                                onPageChanged: (value) {
                                                  _eventBannerChange.value =
                                                      value;
                                                },
                                              ),
                                      ),
                                      SizedBox(
                                        height: context.resources.dimen.dp10,
                                      ),
                                      if (eventsList.isNotEmpty) ...{
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            for (int i = 0;
                                                i < eventsList.length;
                                                i++) ...[
                                              PageIndicator(
                                                  size: context
                                                      .resources.dimen.dp5,
                                                  position: i,
                                                  eventBannerChange:
                                                      _eventBannerChange)
                                            ]
                                          ],
                                        )
                                      }
                                    ],
                                  );
                                }),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: context.resources.dimen.dp25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context.string.myFavoriteService,
                                    style: context.textFontWeight700.onFontSize(
                                        context.resources.fontSize.dp18),
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: _isFavoriteEdited,
                                      builder:
                                          (context, isFavoriteEdited, widget) {
                                        return InkWell(
                                          onTap: () {
                                            _isFavoriteEdited.value =
                                                !isFavoriteEdited;
                                            var favoraties =
                                                _favoriteEntity.value;
                                            _favoriteEntity.value = [];
                                            _favoriteEntity.value = favoraties;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              isFavoriteEdited
                                                  ? context.string.done
                                                  : context.string.edit,
                                              style: context.textFontWeight400
                                                  .onColor(context.resources
                                                      .color.textColorLight)
                                                  .onFontSize(context
                                                      .resources.fontSize.dp12),
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: context.resources.dimen.dp20,
                            ),
                            ValueListenableBuilder(
                                valueListenable: _favoriteEntity,
                                builder: (context, favoriteEntity, widget) {
                                  return LayoutBuilder(
                                      builder: (context, constraints) {
                                    final crossAxisCount =
                                        (constraints.maxWidth / 170)
                                            .floor()
                                            .clamp(3, 6);
                                    return GridView.builder(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            context.resources.dimen.dp25,
                                      ),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: favoriteEntity.length,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        childAspectRatio: context.resources
                                                    .getUserSelcetedFontSize() ==
                                                FontSizeEnum.bigSize
                                            ? 1.0
                                            : context.resources
                                                        .getUserSelcetedFontSize() ==
                                                    FontSizeEnum.smallSize
                                                ? 1.2
                                                : 1.1,
                                        mainAxisSpacing:
                                            context.resources.dimen.dp20,
                                      ),
                                      itemBuilder: (ctx, i) {
                                        return InkWell(
                                          onTap: () {
                                            if (!_isFavoriteEdited.value) {
                                              if (favoriteEntity[i].name ==
                                                  favoriteAdd) {
                                                final services = sl<
                                                        ConstantConfig>()
                                                    .getServicesByManager(
                                                        isManager: context
                                                            .userDB
                                                            .get(isMaangerKey,
                                                                defaultValue:
                                                                    false))
                                                    .where((element) =>
                                                        !favoriteEntity
                                                            .contains(element))
                                                    .toList();
                                                Dialogs.showBottomSheetDialog(
                                                    context,
                                                    ServicesList(
                                                        services: services,
                                                        callback:
                                                            _addFavorite));
                                              } else {
                                                ServicesScreen.onServiceClick(
                                                    context, favoriteEntity[i]);
                                              }
                                            }
                                          },
                                          child: ItemDashboardService(
                                            data: favoriteEntity[i],
                                            callback: _removeFavorite,
                                            showDelete: _isFavoriteEdited.value,
                                          ),
                                        );
                                      },
                                    );
                                  });
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          )),
    );
  }
}
