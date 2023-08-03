import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/home/home_bloc.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/item_dashboard_events.dart';
import 'package:malomati/presentation/ui/widgets/item_dashboard_leaves.dart';
import 'package:malomati/presentation/ui/widgets/item_dashboard_service.dart';
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
  ValueNotifier eventBannerChange = ValueNotifier<int>(0);
  final services = [
    {'name': 'Leaves', 'icon': DrawableAssets.icServiceLeave},
    {'name': 'Permission', 'icon': DrawableAssets.icServicePermission},
    {'name': 'Attendance', 'icon': DrawableAssets.icServiceAttendance},
    {'name': 'Certificate', 'icon': DrawableAssets.icServiceCertificate},
    {'name': 'Thankyou', 'icon': DrawableAssets.icServiceThankyou},
    {'name': favoriteAdd, 'icon': DrawableAssets.icServiceAdd},
  ];
  final _currentDate = DateFormat('EEE, dd MMMM yyyy').format(DateTime.now());
  final ValueNotifier _timeString =
      ValueNotifier<String>(DateFormat('hh:mm:ss aa').format(DateTime.now()));

  void _getTime() {
    _timeString.value = DateFormat('hh:mm:ss aa').format(DateTime.now());
  }

  void _getAttendance() {
    var date = DateFormat('ddMMyyyy').format(DateTime.now());
    Map<String, dynamic> requestParams = {
      'date-range': '$date-$date',
    };
    _homeBloc.getAttendance(requestParams: requestParams);
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    _getAttendance();
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
                        state.attendanceEntity.entity ?? AttendanceEntity();
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
                                    ImageWidget(path: DrawableAssets.icWeather)
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
                                            attendanceEntity.punch1Time ??
                                                '00:00:00',
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
                                            attendanceEntity.punch2Time ??
                                                '00:00:00',
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
                            GridView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.resources.dimen.dp25,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 22 / 30,
                                crossAxisSpacing: context.resources.dimen.dp10,
                              ),
                              itemBuilder: (ctx, i) {
                                return const ItemDashboardLeaves();
                              },
                            ),
                            SizedBox(
                              height: context.resources.dimen.dp20,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: context.resources.dimen.dp15),
                              height: context.resources.dimen.dp75,
                              child: PageView(
                                clipBehavior: Clip.none,
                                children: const [
                                  ItemDashboardEvent(),
                                  ItemDashboardEvent(),
                                  ItemDashboardEvent(),
                                ],
                                onPageChanged: (value) {
                                  eventBannerChange.value = value;
                                },
                              ),
                            ),
                            SizedBox(
                              height: context.resources.dimen.dp10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < 3; i++) ...[
                                  PageIndicator(
                                      size: context.resources.dimen.dp5,
                                      position: i,
                                      eventBannerChange: eventBannerChange)
                                ]
                              ],
                            ),
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
                                  Text(
                                    'Edit',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColorLight)
                                        .onFontFamily(fontFamily: fontFamilyEN)
                                        .onFontSize(
                                            context.resources.dimen.dp12),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: context.resources.dimen.dp20,
                            ),
                            GridView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.resources.dimen.dp25,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: services.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.2,
                                mainAxisSpacing: context.resources.dimen.dp20,
                              ),
                              itemBuilder: (ctx, i) {
                                return ItemDashboardService(
                                  title: (services[i])['name'] ?? '',
                                  iconPath: (services[i])['icon'] ?? '',
                                );
                              },
                            ),
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
