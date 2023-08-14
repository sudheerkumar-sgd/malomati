import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/home/home_bloc.dart';
import 'package:malomati/presentation/ui/home/widgets/services_list.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_events.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_leaves.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_service.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/page_indicator.dart';
import 'package:malomati/presentation/ui/widgets/user_app_bar.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../res/drawables/background_box_decoration.dart';
import '../widgets/custom_bg_widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _homeBloc = sl<HomeBloc>();
  final ValueNotifier<AttendanceEntity> _attendanceEntity =
      ValueNotifier<AttendanceEntity>(AttendanceEntity());
  final ValueNotifier<DashboardEntity> _dashboardEntity =
      ValueNotifier<DashboardEntity>(DashboardEntity());
  final ValueNotifier<List<FavoriteEntity>> _favoriteEntity =
      ValueNotifier<List<FavoriteEntity>>([]);
  final ValueNotifier _eventBannerChange = ValueNotifier<int>(0);
  final ValueNotifier _isFavoriteEdited = ValueNotifier<bool>(false);
  final _currentDate = DateFormat('EEE, dd MMMM yyyy').format(DateTime.now());
  final ValueNotifier _timeString =
      ValueNotifier<String>(DateFormat('hh:mm:ss aa').format(DateTime.now()));

  void _getTime() {
    _timeString.value = DateFormat('hh:mm:ss aa').format(DateTime.now());
  }

  _addFavorite(BuildContext context, FavoriteEntity favoriteEntity) {
    _homeBloc.saveFavoritesdData(
        userDB: context.userDB, favoriteEntity: favoriteEntity);
  }

  _removeFavorite(BuildContext context, FavoriteEntity favoriteEntity) {
    _homeBloc.removeFavoritesdData(
        userDB: context.userDB, favoriteEntity: favoriteEntity);
  }

  @override
  Widget build(BuildContext context) {
    var date = DateFormat('ddMMyyyy').format(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    _homeBloc.getAttendance(dateRange: '$date-$date');
    _homeBloc.getDashboardData(
        userName: context.userDB.get(userNameKey, defaultValue: ''));
    _homeBloc.getFavoritesdData(userDB: context.userDB);
    return SafeArea(
      child: Scaffold(
          backgroundColor: context.resources.color.appScaffoldBg,
          body: BlocProvider<HomeBloc>(
            create: (context) => _homeBloc,
            child: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is OnLoading) {
                    Dialogs.loader(context);
                  } else if (state is OnAttendanceSuccess) {
                    _attendanceEntity.value =
                        state.attendanceEntity.entity?.attendanceList[0] ??
                            AttendanceEntity();
                  } else if (state is OnDashboardSuccess) {
                    _dashboardEntity.value =
                        state.dashboardEntity.entity ?? DashboardEntity();
                  } else if (state is OnFavoriteSuccess) {
                    _favoriteEntity.value = [];
                    _favoriteEntity.value = state.favoriteEntity;
                  } else if (state is OnApiError) {}
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.resources.color.bgGradientStart,
                              context.resources.color.bgGradientEnd,
                            ],
                          ),
                          image: const DecorationImage(
                            image: AssetImage(DrawableAssets.icHomeCoverRing),
                          )),
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
                          CustomBgWidgets().roundedCornerWidget(
                            padding: EdgeInsets.only(
                              left: context.resources.dimen.dp15,
                              top: context.resources.dimen.dp15,
                              right: context.resources.dimen.dp20,
                              bottom: context.resources.dimen.dp5,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: context.resources.dimen.dp25,
                            ),
                            widget: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _currentDate,
                                          style: context.textFontWeight600
                                              .onFontFamily(
                                                  fontFamily: fontFamilyEN)
                                              .onFontSize(
                                                  context.resources.dimen.dp17),
                                        ),
                                        SizedBox(
                                          height: context.resources.dimen.dp5,
                                        ),
                                        ValueListenableBuilder(
                                            valueListenable: _timeString,
                                            builder: (context, value, widget) {
                                              return Text(
                                                value,
                                                style: context.textFontWeight400
                                                    .onFontFamily(
                                                        fontFamily:
                                                            fontFamilyEN)
                                                    .onFontSize(context
                                                        .resources.dimen.dp14),
                                              );
                                            }),
                                      ],
                                    ),
                                    const Spacer(),
                                    ImageWidget(
                                            path: DrawableAssets.icWeather,
                                            backgroundTint:
                                                context.resources.iconBgColor)
                                        .loadImage
                                  ],
                                ),
                                SizedBox(
                                  height: context.resources.dimen.dp20,
                                ),
                                Text(
                                  context.string.morningPunch,
                                  style: context.textFontWeight400
                                      .onFontSize(context.resources.dimen.dp14),
                                ),
                              ],
                            ),
                            boxDecoration: BackgroundBoxDecoration(
                                    boxColor:
                                        context.resources.color.colorWhite,
                                    radious: context.resources.dimen.dp20)
                                .topCornersBox,
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable: _attendanceEntity,
                        builder: (context, attendanceEntity, widget) {
                          return Container(
                            padding: EdgeInsets.only(
                              left: context.resources.dimen.dp15,
                              top: context.resources.dimen.dp5,
                              right: context.resources.dimen.dp20,
                              bottom: context.resources.dimen.dp15,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: context.resources.dimen.dp25,
                            ),
                            decoration: BackgroundBoxDecoration(
                              boxColor: context.resources.color.colorWhite,
                              radious: context.resources.dimen.dp20,
                            ).bottomCornersBoxWithShadow,
                            transform:
                                Matrix4.translationValues(0.0, -1.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          minWidth: double.infinity,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  context.resources.dimen.dp5,
                                              horizontal:
                                                  context.resources.dimen.dp10),
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  context.resources.dimen.dp10),
                                          decoration: BackgroundBoxDecoration(
                                                  boxColor: context.resources
                                                      .color.viewBgColor,
                                                  radious: context
                                                      .resources.dimen.dp25,
                                                  shadowColor: context.resources
                                                      .color.textColorLight,
                                                  shadowBlurRadius: context
                                                      .resources.dimen.dp5)
                                              .roundedBoxWithShadow
                                              .copyWith(
                                                  gradient: LinearGradient(
                                                colors: [
                                                  context.resources.color
                                                      .bgGradientStart,
                                                  context.resources.color
                                                      .bgGradientEnd,
                                                ],
                                              )),
                                          child: Text(
                                            context.string.punchIn,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: context.textFontWeight400
                                                .onColor(context
                                                    .resources.color.colorWhite)
                                                .onFontSize(context
                                                    .resources.dimen.dp14),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: context.resources.dimen.dp8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ImageWidget(
                                                  path:
                                                      DrawableAssets.icPunchIn)
                                              .loadImage,
                                          SizedBox(
                                            width: context.resources.dimen.dp5,
                                          ),
                                          Text(
                                            (attendanceEntity.punch1Time ?? '')
                                                    .isNotEmpty
                                                ? attendanceEntity.punch1Time!
                                                : '00:00:00',
                                            style: context.textFontWeight400
                                                .onFontFamily(
                                                    fontFamily: fontFamilyEN)
                                                .onFontSize(context
                                                    .resources.dimen.dp12),
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
                                        constraints: const BoxConstraints(
                                          minWidth: double.infinity,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  context.resources.dimen.dp5,
                                              horizontal:
                                                  context.resources.dimen.dp20),
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  context.resources.dimen.dp10),
                                          decoration: BackgroundBoxDecoration(
                                                  boxColor: context.resources
                                                      .color.viewBgColor,
                                                  radious: context
                                                      .resources.dimen.dp25,
                                                  shadowColor: context.resources
                                                      .color.textColorLight,
                                                  shadowBlurRadius: context
                                                      .resources.dimen.dp5)
                                              .roundedBoxWithShadow
                                              .copyWith(
                                                  gradient: LinearGradient(
                                                colors: [
                                                  context.resources.color
                                                      .bgGradientStart,
                                                  context.resources.color
                                                      .bgGradientEnd,
                                                ],
                                              )),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            context.string.punchOut,
                                            style: context.textFontWeight400
                                                .onColor(context
                                                    .resources.color.colorWhite)
                                                .onFontSize(context
                                                    .resources.dimen.dp14),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: context.resources.dimen.dp8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ImageWidget(
                                                  path:
                                                      DrawableAssets.icPunchOut)
                                              .loadImage,
                                          SizedBox(
                                            width: context.resources.dimen.dp5,
                                          ),
                                          Text(
                                            (attendanceEntity.punch2Time ?? '')
                                                    .isNotEmpty
                                                ? attendanceEntity.punch2Time!
                                                : '00:00:00',
                                            style: context.textFontWeight400
                                                .onFontFamily(
                                                    fontFamily: fontFamilyEN)
                                                .onFontSize(context
                                                    .resources.dimen.dp12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: context.resources.dimen.dp20,
                            ),
                            ValueListenableBuilder(
                                valueListenable: _dashboardEntity,
                                builder: (context, dashboardEntity, widget) {
                                  return Column(
                                    children: [
                                      GridView.builder(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              context.resources.dimen.dp25,
                                        ),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 4,
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          childAspectRatio: 22 / 30,
                                          crossAxisSpacing:
                                              context.resources.dimen.dp10,
                                        ),
                                        itemBuilder: (ctx, i) {
                                          switch (i) {
                                            case 0:
                                              {
                                                return ItemDashboardLeaves(
                                                  balanceCount: dashboardEntity
                                                          .aNNUALACCRUAL ??
                                                      '0',
                                                  balancetype:
                                                      context.string.days,
                                                  title: context
                                                      .string.balanceLeaves,
                                                );
                                              }
                                            case 1:
                                              {
                                                return ItemDashboardLeaves(
                                                  balanceCount: dashboardEntity
                                                          .sICKACCRUAL ??
                                                      '0',
                                                  balancetype:
                                                      context.string.days,
                                                  title: context
                                                      .string.balanceSickLeaves,
                                                );
                                              }
                                            case 2:
                                              {
                                                return ItemDashboardLeaves(
                                                  balanceCount: dashboardEntity
                                                          .pERMISSIONACCRUAL ??
                                                      '0',
                                                  balancetype:
                                                      context.string.hours,
                                                  title: context
                                                      .string.balancePermission,
                                                );
                                              }
                                            default:
                                              {
                                                return ItemDashboardLeaves(
                                                  balanceCount: dashboardEntity
                                                          .tHANKYOUCOUNT ??
                                                      '0',
                                                  balancetype:
                                                      context.string.star,
                                                  title: context
                                                      .string.totalThankYou,
                                                );
                                              }
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: context.resources.dimen.dp20,
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                context.resources.dimen.dp15),
                                        height: context.resources.dimen.dp75,
                                        child: PageView(
                                          clipBehavior: Clip.none,
                                          children: [
                                            if (dashboardEntity.eventsEntity !=
                                                null)
                                              for (int i = 0;
                                                  i <
                                                      dashboardEntity
                                                          .eventsEntity!.length;
                                                  i++) ...[
                                                ItemDashboardEvent(
                                                  eventsEntity: dashboardEntity
                                                              .eventsEntity !=
                                                          null
                                                      ? dashboardEntity
                                                          .eventsEntity![i]
                                                      : EventsEntity(),
                                                )
                                              ]
                                          ],
                                          onPageChanged: (value) {
                                            _eventBannerChange.value = value;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: context.resources.dimen.dp10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (dashboardEntity.eventsEntity !=
                                              null)
                                            for (int i = 0;
                                                i <
                                                    dashboardEntity
                                                        .eventsEntity!.length;
                                                i++) ...[
                                              PageIndicator(
                                                  size: context
                                                      .resources.dimen.dp5,
                                                  position: i,
                                                  eventBannerChange:
                                                      _eventBannerChange)
                                            ]
                                        ],
                                      ),
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
                                        context.resources.dimen.dp17),
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
                                                  .onFontFamily(
                                                      fontFamily: fontFamilyEN)
                                                  .onFontSize(context
                                                      .resources.dimen.dp12),
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
                                      childAspectRatio: 1.2,
                                      mainAxisSpacing:
                                          context.resources.dimen.dp20,
                                    ),
                                    itemBuilder: (ctx, i) {
                                      return InkWell(
                                        onTap: () {
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
                                                            .contains(element))
                                                    .toList();
                                            Dialogs.showBottomSheetDialog(
                                                context,
                                                ServicesList(
                                                    services: services,
                                                    callback: _addFavorite));
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
