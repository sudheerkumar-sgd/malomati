import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';
import 'package:malomati/domain/entities/weather_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:malomati/presentation/bloc/home/home_bloc.dart';
import 'package:malomati/presentation/ui/home/attendance_screen.dart';
import 'package:malomati/presentation/ui/home/services_screen.dart';
import 'package:malomati/presentation/ui/home/widgets/services_list.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_events.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_leaves.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_service.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/page_indicator.dart';
import 'package:malomati/presentation/ui/widgets/user_app_bar.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:page_transition/page_transition.dart';

import '../../../core/common/common_utils.dart';
import '../../../core/constants/data_constants.dart';
import '../../../core/enum.dart';
import '../../../res/drawables/background_box_decoration.dart';

import '../utils/location.dart';

class HomeScreen extends StatelessWidget {
  static String anualLeaveBalance = '';
  static String sickLeaveBalance = '';
  static String permissionBalance = '';
  HomeScreen({super.key});
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
  // final ValueNotifier _timeString =
  //     ValueNotifier<String>(DateFormat('hh:mm:ss aa').format(DateTime.now()));
  final ValueNotifier<int> _punchStatus = ValueNotifier<int>(-1);
  final ValueNotifier<int> _onAttendanceRespose = ValueNotifier<int>(-1);
  // void _getTime() {
  //   _timeString.value = DateFormat('hh:mm:ss aa').format(DateTime.now());
  // }

  _refreshAttendance() {
    var date = getDateByformat('ddMMyyyy', DateTime.now());
    Map<String, dynamic> attendanceRequestParams = {
      'date-range': '$date-$date',
    };
    _attendanceBloc.getAttendance(requestParams: attendanceRequestParams);
    _attendanceBloc.getAttendanceDetails(
        dateRange: '${date}000000-${date}235959');
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
      return context.string.morningPunch;
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
    final userName = context.userDB.get(userNameKey, defaultValue: '');
    _refreshAttendance();
    _homeBloc.getDashboardData(
        userName: context.userDB.get(userNameKey, defaultValue: ''));
    _homeBloc.getEventsData(
        departmentId: context.userDB.get(departmentIdKey, defaultValue: ''));
    _homeBloc.getFavoritesdData(userDB: context.userDB);
    Future.delayed(const Duration(milliseconds: 100), () {
      _homeBloc.getNotificationsList(requestParams: {
        'USER_NAME': userName,
        'START_DATE': getDateByformat(
            'yyy-MM-dd', DateTime.now().subtract(const Duration(days: 2))),
        'END_DATE': getDateByformat(
            'yyy-MM-dd', DateTime.now().add(const Duration(days: 1)))
      });
      if (context.userDB.get(lastWeatherCheckDate) == null ||
          getMinutes(context.userDB.get(lastWeatherCheckDate), DateTime.now()) >
              120) {
        _getWeatherDetails();
      }
    });
    _onAttendanceRespose.addListener(
      () {
        Timer(const Duration(milliseconds: 200), () {
          _punchStatus.value = _onAttendanceRespose.value;
        });
      },
    );
    _homeBloc.getRequestsCount(requestParams: {'USER_NAME': userName});
    final currentDate = DateTime.now();
    final currentDayName = getDateByformat('EEEE', currentDate);
    final currentDay = getDateByformat('dd', currentDate);
    final currentMonth = getDateByformat('MMMM', DateTime.now());
    final currentYear = DateTime.now().year;
    _weatherEntity.value = WeatherEntity(
        temperature: context.userDB.get(lastTemperature, defaultValue: 0),
        weathercode: context.userDB.get(lastWeathercode, defaultValue: 1));
    final pageController = PageController(
      initialPage: 0,
    );
    startTimer(
        duration: const Duration(seconds: 4),
        callback: () {
          int nextIndex =
              _eventBannerChange.value == _eventsListEntity.value.length - 1
                  ? 0
                  : (_eventBannerChange.value + 1);
          if (nextIndex > 0) {
            pageController.animateToPage(nextIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
          } else {
            pageController.jumpTo(nextIndex.toDouble());
          }
        });
    return SafeArea(
      child: Scaffold(
          backgroundColor: context.resources.color.appScaffoldBg,
          body: BlocProvider<HomeBloc>(
            create: (context) => _homeBloc,
            child: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is OnLoading) {
                    Dialogs.loader(context);
                  } else if (state is OnDashboardSuccess) {
                    _dashboardEntity.value =
                        state.dashboardEntity.entity ?? DashboardEntity();
                  } else if (state is OnEventsSuccess) {
                    _eventsListEntity.value =
                        state.eventsListEntity.entity?.eventsList ?? [];
                  } else if (state is OnFavoriteSuccess) {
                    _favoriteEntity.value = [];
                    _favoriteEntity.value = state.favoriteEntity;
                  } else if (state is OnRequestsCountSuccess) {
                    ConstantConfig.hrApprovalCount =
                        state.requestsCountEntity.hRCOUNT ?? 0;
                    ConstantConfig.financePOApprovalCount =
                        state.requestsCountEntity.pOCOUNT ?? 0;
                    ConstantConfig.financePRApprovalCount =
                        state.requestsCountEntity.pRCOUNT ?? 0;
                    ConstantConfig.financeINVApprovalCount =
                        state.requestsCountEntity.iNVCOUNT ?? 0;
                    ConstantConfig.requestsApprovalCount =
                        state.requestsCountEntity.requestsApprovalCount ?? 0;
                    ConstantConfig.requestsRejectCount =
                        state.requestsCountEntity.requestsRejectCount ?? 0;
                    ConstantConfig.requestsPendingCount =
                        state.requestsCountEntity.requestsPendingCount ?? 0;
                    ConstantConfig.isApprovalCountChange.value =
                        !(ConstantConfig.isApprovalCountChange.value);
                  } else if (state is OnNotificationsListSuccess) {
                    String openedNotifications = context.userDB
                        .get(openedNotificationsKey, defaultValue: '');
                    final list = state.notificationsList
                        .where((element) => !openedNotifications
                            .contains('${element.nOTIFICATIONID}'))
                        .toList();
                    ConstantConfig.notificationsCount = list.length;
                    ConstantConfig.isApprovalCountChange.value =
                        !(ConstantConfig.isApprovalCountChange.value);
                  } else if (state is OnWeatherReportSuccess) {
                    context.userDB
                        .put(lastTemperature, state.weatherEntity.temperature);
                    context.userDB
                        .put(lastWeathercode, state.weatherEntity.weathercode);
                    context.userDB.put(lastWeatherCheckDate, DateTime.now());
                    _weatherEntity.value = state.weatherEntity;
                  } else if (state is OnApiError) {
                    printLog(message: state.message);
                  }
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
                              StreamBuilder(
                                  stream: _attendanceBloc.getAttendanceData,
                                  builder: (context, attendanceData) {
                                    var attendanceEntity =
                                        attendanceData.data ??
                                            AttendanceEntity();
                                    if ((attendanceEntity.punch2Time ?? '')
                                        .isNotEmpty) {
                                      _onAttendanceRespose.value = 2;
                                    } else if ((attendanceEntity.punch1Time ??
                                            '')
                                        .isNotEmpty) {
                                      _onAttendanceRespose.value = 1;
                                    } else {
                                      _onAttendanceRespose.value = 0;
                                    }
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: context.resources.dimen.dp15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: double.infinity,
                                                ),
                                                child: InkWell(
                                                  onTap: () {
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
                                                      _refreshAttendance();
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: context
                                                                .resources
                                                                .dimen
                                                                .dp5,
                                                            horizontal: context
                                                                .resources
                                                                .dimen
                                                                .dp10),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: context
                                                                .resources
                                                                .dimen
                                                                .dp10),
                                                    decoration: BackgroundBoxDecoration(
                                                            boxColor: context
                                                                .resources
                                                                .color
                                                                .appScaffoldBg,
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
                                                      context.string.punchIn,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: context
                                                          .textFontWeight400
                                                          .onFontSize(context
                                                              .resources
                                                              .fontSize
                                                              .dp14),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    context.resources.dimen.dp8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                        .resources.dimen.dp10,
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
                                                        .onFontSize(context
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
                                                  minWidth: double.infinity,
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .rightToLeft,
                                                        child: AttendanceScreen(
                                                          attendanceType:
                                                              AttendanceType
                                                                  .punchOut,
                                                          attendanceEntity:
                                                              attendanceEntity,
                                                        ),
                                                      ),
                                                    ).then((value) {
                                                      _refreshAttendance();
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: context
                                                                .resources
                                                                .dimen
                                                                .dp5,
                                                            horizontal: context
                                                                .resources
                                                                .dimen
                                                                .dp20),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: context
                                                                .resources
                                                                .dimen
                                                                .dp10),
                                                    decoration: BackgroundBoxDecoration(
                                                            boxColor: context
                                                                .resources
                                                                .color
                                                                .appScaffoldBg,
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      context.string.punchOut,
                                                      style: context
                                                          .textFontWeight400
                                                          .onFontSize(context
                                                              .resources
                                                              .fontSize
                                                              .dp14),
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
                                                    MainAxisAlignment.center,
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
                                                        .resources.dimen.dp5,
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
                                                        .onFontSize(context
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
                                          width: context.resources.dimen.dp15,
                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                                  anualLeaveBalance =
                                      '${dashboardEntity.aNNUALACCRUAL ?? '0'} ${context.string.days}';
                                  sickLeaveBalance =
                                      '${dashboardEntity.sICKACCRUAL ?? '0'} ${context.string.days}';
                                  permissionBalance =
                                      '${dashboardEntity.pERMISSIONACCRUAL ?? '0'} ${context.string.hours}';
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
                                                controller: pageController,
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
                                  return GridView.builder(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.resources.dimen.dp25,
                                    ),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: favoriteEntity.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
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
                                              final services =
                                                  sl<ConstantConfig>()
                                                      .getServicesByManager(
                                                          isManager: context
                                                              .userDB
                                                              .get(isMaangerKey,
                                                                  defaultValue:
                                                                      false))
                                                      .where((element) =>
                                                          !favoriteEntity
                                                              .contains(
                                                                  element))
                                                      .toList();
                                              Dialogs.showBottomSheetDialog(
                                                  context,
                                                  ServicesList(
                                                      services: services,
                                                      callback: _addFavorite));
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
