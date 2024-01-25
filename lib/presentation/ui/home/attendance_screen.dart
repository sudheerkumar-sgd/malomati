// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/utils/location.dart';
import 'package:malomati/presentation/ui/widgets/alert_dialog_widget.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import '../../../injection_container.dart';
import '../../../res/drawables/background_box_decoration.dart';
import '../../../res/drawables/drawable_assets.dart';
import '../../../res/resources.dart';
import '../widgets/back_app_bar.dart';

enum AttendanceType {
  punchIn,
  punchOut,
}

String getPunchTypeValue(BuildContext context, String spfid) {
  switch (spfid) {
    case '1':
      return context.string.officialIn;
    case '2':
      return context.string.officialOut;
    case '3':
      return context.string.shortLeaveIn;
    case '4':
      return context.string.shortLeaveOut;
    case '5':
      return context.string.regularIn;
    case '6':
      return context.string.regularOut;
    case '7':
      return context.string.lunchIn;
    case '8':
      return context.string.lunchOut;
    case '9':
      return context.string.overtimeIn;
    case '10':
      return context.string.overtimeOut;
    default:
      return context.string.regularIn;
  }
}

class AttendanceScreen extends StatelessWidget {
  final AttendanceType attendanceType;
  late Resources resources;
  final ValueNotifier _timeString =
      ValueNotifier<String>(getCurrentDateByformat('hh:mm:ss aa'));
  List<Map> attendanceOptions = [];
  AttendanceEntity? attendanceEntity;
  //Position? position;
  Map department = {};
  final viewTransformationController = TransformationController();
  final _attendanceBloc = sl<AttendanceBloc>();
  Map? selectedOption;
  Position? position;

  AttendanceScreen(
      {required this.attendanceType,
      required this.attendanceEntity,
      super.key});
  void _setTime() {
    _timeString.value = getCurrentDateByformat('hh:mm:ss aa');
  }

  _setZoomToMapview() {
    viewTransformationController.value.setEntry(0, 0, 2);
    viewTransformationController.value.setEntry(1, 1, 2);
    viewTransformationController.value.setEntry(2, 2, 2);
    viewTransformationController.value.setEntry(0, 3, -160);
    viewTransformationController.value.setEntry(1, 3, -80);
  }

  String _getWorkingHours() {
    var fromTime = DateTime.parse(
        '${getCurrentDateByformat('yyyy-MM-dd')} ${attendanceEntity?.punch1Time ?? ''}');
    return getHoursMinutesFormat(fromTime, DateTime.now());
  }

  String _getReamainingHours() {
    if ((attendanceEntity?.punch1Time ?? '').isNotEmpty) {
      var fromTime = DateTime.parse(
          '${getCurrentDateByformat('yyyy-MM-dd')} ${attendanceEntity?.punch1Time ?? ''}');
      return getRemainingHoursMinutesFormat(fromTime, DateTime.now());
    } else {
      return '';
    }
  }

  _getLocationDetails(BuildContext context) async {
    var isLocationOn = await Location.checkGps();
    if (!isLocationOn && context.mounted) {
      Dialogs.showInfoDialog(
        context,
        PopupType.fail,
        'please Enable Location to submit attendance',
      );
    }
  }

  bool canPunchInEnable() {
    return true;
    // return ((attendanceEntity?.punch2Time?.isNotEmpty ?? true) ||
    //     (attendanceEntity?.punch4Time?.isNotEmpty ?? true) ||
    //     (attendanceEntity?.punch6Time?.isNotEmpty ?? true) ||
    //     (attendanceEntity?.punch8Time?.isNotEmpty ?? true) ||
    //     (attendanceEntity?.punch10Time?.isNotEmpty ?? true));
  }

  bool canPunchOutEnable() {
    return true;
    // return ((attendanceEntity?.punch1Time?.isNotEmpty ?? false) ||
    //     (attendanceEntity?.punch3Time?.isNotEmpty ?? false) ||
    //     (attendanceEntity?.punch5Time?.isNotEmpty ?? false) ||
    //     (attendanceEntity?.punch7Time?.isNotEmpty ?? false) ||
    //     (attendanceEntity?.punch9Time?.isNotEmpty ?? false));
  }

  bool canUserShortLeaveIn() {
    return canPunchInEnable() &&
        (attendanceEntity?.punch1Time?.isEmpty ?? true);
  }

  bool canUserRegularIn() {
    var hour = DateTime.now().hour;
    var minute = DateTime.now().minute;
    return ((hour < 8 || (hour == 8 && minute < 1)) &&
        (attendanceEntity?.punch1Time ?? '').isEmpty);
  }

  List<Map> _getAttendanceOptions(BuildContext context) {
    if (attendanceType == AttendanceType.punchIn) {
      return [
        {
          'name': context.string.regularIn,
          'id': '5',
          'isEnabled': canUserRegularIn()
        },
        {
          'name': context.string.shortLeaveIn,
          'id': '3',
          'isEnabled': canPunchInEnable()
        },
        {
          'name': context.string.officialIn,
          'id': '1',
          'isEnabled': canPunchInEnable()
        },
        {
          'name': context.string.overtimeIn,
          'id': '9',
          'isEnabled': canPunchInEnable()
        },
      ];
    } else {
      return [
        {
          'name': context.string.regularOut,
          'id': '6',
          'isEnabled': canPunchOutEnable()
        },
        {
          'name': context.string.shortLeaveOut,
          'id': '4',
          'isEnabled': canPunchOutEnable()
        },
        {
          'name': context.string.officialWorkOut,
          'id': '2',
          'isEnabled': canPunchOutEnable()
        },
        {
          'name': context.string.overtimeOut,
          'id': '10',
          'isEnabled': canPunchOutEnable()
        },
      ];
    }
  }

  _submitAttendance(BuildContext context, Map option) async {
    selectedOption = option;
    //printLog(message: 'position $position');
    // if (position != null) {
    //   var department = getDepartmentByLocation(
    //       (position?.latitude ?? 0), position?.longitude ?? 0);
    //   if ((department['name'] ?? '').isEmpty) {
    //     Dialogs.showInfoDialog(context, PopupType.fail,
    //         context.string.attendancelocationErrorMessage);
    //   } else {
    //     Map<String, dynamic> requestParams = {
    //       "userid": context.userDB.get(oracleLoginIdKey),
    //       "date": getCurrentDateByformat('ddMMyyyyHHmmss'),
    //       "latitude": department['latitude'],
    //       "longitude": department['longitude'],
    //       "method": option['id'],
    //       "isInOut": attendanceType == AttendanceType.punchIn ? "0" : "1",
    //     };
    //     //printLog(message: requestParams.toString());
    //     _attendanceBloc.submitAttendance(requestParams: requestParams);
    //   }
    // } else {
    if (context.mounted) {
      Dialogs.showInfoLoader(
        context,
        context.string.fetchingLocationDetails,
      );
    }
    var isLocationOn = await Location.checkGps();
    if (isLocationOn) {
      Location.getLocation().then((value) {
        Navigator.of(context, rootNavigator: true).pop();
        position = value;
        var department = getDepartmentByLocation(
            (position?.latitude ?? 0.0), position?.longitude ?? 0.0);
        if ((department['name'] ?? '').isEmpty) {
          if (context.mounted) {
            Dialogs.showInfoLoader(
              context,
              context.string.checkingRemoteWorkDetails,
            );
          }
          _getUserDetails();
        } else {
          _submitAttendanceToServer(context, department: department);
        }
      });
    } else if (context.mounted) {
      Dialogs.showInfoDialog(
        context,
        PopupType.fail,
        context.string.locationErrorText,
      );
    }
    // }
  }

  _getUserDetails() {
    _attendanceBloc.getUserDetails(requestParams: {});
  }

  _submitAttendanceToServer(BuildContext context, {Map? department}) {
    Map<String, dynamic> requestParams = {
      "userid": context.userDB.get(oracleLoginIdKey),
      "date": getCurrentDateByformat('ddMMyyyyHHmmss'),
      "latitude": department?['latitude'] ??
          '+${(position?.latitude ?? 0.0).toStringAsFixed(4)}',
      "longitude": department?['longitude'] ??
          '+${(position?.longitude ?? 0.0).toStringAsFixed(4)}',
      "method": selectedOption?['id'],
      "isInOut": attendanceType == AttendanceType.punchIn ? "0" : "1",
    };
    //printLog(message: requestParams.toString());
    _attendanceBloc.submitAttendance(requestParams: requestParams);
  }

  Future<String> _getPunchlocation() async {
    if ((department['name'] ?? '').isEmpty) {
      return await Location.getPlaceByLocation(
          double.parse(attendanceEntity?.gpsLatitude ?? '0.0'),
          double.parse(attendanceEntity?.gpsLongitude ?? '0.0'));
    }
    return department['name'] ?? '';
  }

  _getAttendance() {
    var date = getDateByformat('ddMMyyyy', DateTime.now());
    Map<String, dynamic> attendanceRequestParams = {
      'date-range': '$date-$date',
    };
    _attendanceBloc.getAttendance(requestParams: attendanceRequestParams);
    _attendanceBloc.getAttendanceDetails(
        dateRange: '${date}000000-${date}235959');
  }

  @override
  Widget build(BuildContext context) {
    _setZoomToMapview();
    _getLocationDetails(context);
    resources = context.resources;
    _getAttendance();
    return SafeArea(
        child: Scaffold(
            backgroundColor: resources.color.appScaffoldBg,
            body: BlocProvider<AttendanceBloc>(
              create: (context) => _attendanceBloc,
              child: BlocListener<AttendanceBloc, AttendanceState>(
                listener: (context, state) {
                  if (state is OnAttendanceDataLoading) {
                    Dialogs.loader(context)
                        .then((value) => Navigator.pop(context));
                  } else if (state is OnUserDetailsSuccess) {
                    Navigator.of(context, rootNavigator: true).pop();
                    if (state.attendanceUserDetailsEntity.entity
                            ?.locationMandatory ==
                        "1") {
                      _submitAttendanceToServer(context);
                    } else {
                      Dialogs.showInfoDialog(context, PopupType.fail,
                          context.string.attendancelocationErrorMessage);
                    }
                  } else if (state is OnAttendanceSubmitSuccess) {
                    Navigator.of(context, rootNavigator: true).pop();
                    // Dialogs.showInfoDialog(context, PopupType.success,
                    //     state.attendanceSubmitResponse);
                  } else if (state is OnAttendanceApiError) {
                    Navigator.of(context, rootNavigator: true).pop();
                    Dialogs.showInfoDialog(
                        context, PopupType.fail, state.message);
                  }
                },
                child: StreamBuilder(
                    stream: _attendanceBloc.getAttendanceData,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        attendanceEntity = snapshot.data;
                        department = getDepartmentByLocation(
                            double.parse(
                                attendanceEntity?.gpsLatitude ?? '0.0'),
                            double.parse(
                                attendanceEntity?.gpsLongitude ?? '0.0'));
                        startTimer(
                            duration: const Duration(seconds: 1),
                            callback: _setTime);
                        attendanceOptions = _getAttendanceOptions(context);
                      }
                      return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: resources.dimen.dp20,
                              horizontal: resources.dimen.dp25),
                          child: Column(
                            children: [
                              SizedBox(
                                height: resources.dimen.dp10,
                              ),
                              BackAppBarWidget(
                                  title:
                                      attendanceType == AttendanceType.punchIn
                                          ? context.string.punchIn
                                          : context.string.punchOut),
                              SizedBox(
                                height: resources.dimen.dp25,
                              ),
                              if (snapshot.data == null) ...[
                                Expanded(
                                  child: Center(
                                    child: SizedBox(
                                      height: resources.dimen.dp40,
                                      width: resources.dimen.dp40,
                                      child: CircularProgressIndicator(
                                        strokeWidth: resources.dimen.dp4,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                              if (snapshot.data != null) ...[
                                InteractiveViewer(
                                  transformationController:
                                      viewTransformationController,
                                  panEnabled: false, // Set it to false
                                  minScale: 1,
                                  maxScale: 4,
                                  scaleFactor: 3,
                                  child: ImageWidget(
                                          width: double.infinity,
                                          height: 200,
                                          path: department['map'] ??
                                              DrawableAssets.icMap,
                                          boxType: BoxFit.cover)
                                      .loadImage,
                                ),
                                SizedBox(
                                  height: resources.dimen.dp25,
                                ),
                                ValueListenableBuilder(
                                    valueListenable: _timeString,
                                    builder: (context, value, widget) {
                                      return RichText(
                                          text: TextSpan(
                                              text: '',
                                              style: context.textFontWeight600
                                                  .onColor(context.resources
                                                      .color.textColor)
                                                  .onFontFamily(
                                                      fontFamily:
                                                          resources.isLocalEn
                                                              ? fontFamilyEN
                                                              : fontFamilyAR)
                                                  .onFontSize(context
                                                      .resources.fontSize.dp17),
                                              children: [
                                            TextSpan(
                                              text: '$value',
                                              style: context.textFontWeight600
                                                  .onColor(context.resources
                                                      .color.textColor)
                                                  .onFontFamily(
                                                      fontFamily: fontFamilyEN)
                                                  .onFontSize(context
                                                      .resources.fontSize.dp20),
                                            )
                                          ]));
                                    }),
                                SizedBox(
                                  height: resources.dimen.dp5,
                                ),
                                FutureBuilder(
                                    future: _getPunchlocation(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        '${context.string.location}: ${snapshot.data ?? ''}',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.visible,
                                        maxLines: 1,
                                        style: context.textFontWeight400
                                            .onColor(context
                                                .resources.color.textColor)
                                            .onFontSize(context
                                                .resources.fontSize.dp13),
                                      );
                                    }),
                                SizedBox(
                                  height: resources.dimen.dp10,
                                ),
                                Visibility(
                                  visible:
                                      attendanceType == AttendanceType.punchOut,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        visible: canPunchOutEnable(),
                                        child: Row(
                                          children: [
                                            ImageWidget(
                                                    height: 25,
                                                    path: DrawableAssets
                                                        .icPunchIn,
                                                    backgroundTint: resources
                                                        .color.viewBgColor)
                                                .loadImage,
                                            SizedBox(
                                              width: resources.dimen.dp5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getPunchTypeValue(
                                                      context,
                                                      attendanceEntity
                                                              ?.spfid1 ??
                                                          ''),
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: context
                                                      .textFontWeight400
                                                      .onColor(context.resources
                                                          .color.textColor)
                                                      .onFontSize(context
                                                          .resources
                                                          .fontSize
                                                          .dp12),
                                                ),
                                                Text(
                                                  (attendanceEntity
                                                                  ?.punch1Time ??
                                                              '')
                                                          .isNotEmpty
                                                      ? attendanceEntity
                                                              ?.punch1Time ??
                                                          ''
                                                      : '00:00:00',
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: context
                                                      .textFontWeight600
                                                      .onColor(context.resources
                                                          .color.textColor)
                                                      .onFontFamily(
                                                          fontFamily:
                                                              fontFamilyEN)
                                                      .onFontSize(context
                                                          .resources
                                                          .fontSize
                                                          .dp12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Row(
                                          children: [
                                            ImageWidget(
                                                    height: 23,
                                                    path: DrawableAssets
                                                        .icServiceAttendance,
                                                    backgroundTint: resources
                                                        .color.viewBgColor)
                                                .loadImage,
                                            SizedBox(
                                              width: resources.dimen.dp5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  context.string.remaining,
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: context
                                                      .textFontWeight400
                                                      .onColor(context.resources
                                                          .color.textColor)
                                                      .onFontSize(context
                                                          .resources
                                                          .fontSize
                                                          .dp10),
                                                ),
                                                Text(
                                                  _getReamainingHours(),
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: context
                                                      .textFontWeight600
                                                      .onColor(context.resources
                                                          .color.textColor)
                                                      .onFontSize(context
                                                          .resources
                                                          .fontSize
                                                          .dp10),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: resources.dimen.dp30,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        for (var option
                                            in attendanceOptions) ...[
                                          InkWell(
                                            onTap: () {
                                              if (option['isEnabled']) {
                                                _submitAttendance(
                                                    context, option);
                                              }
                                            },
                                            child: Container(
                                              width: 180,
                                              margin: EdgeInsets.only(
                                                  bottom: resources.dimen.dp20),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: context
                                                      .resources.dimen.dp8,
                                                  horizontal: context
                                                      .resources.dimen.dp10),
                                              decoration:
                                                  BackgroundBoxDecoration(
                                                boxColor: option['isEnabled']
                                                    ? resources
                                                        .color.viewBgColorLight
                                                    : resources
                                                        .color.colorF5C3C3,
                                                radious: context
                                                    .resources.dimen.dp10,
                                              ).roundedCornerBox,
                                              child: Text(
                                                option['name'],
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.textFontWeight400
                                                    .onColor(context.resources
                                                        .color.colorWhite)
                                                    .onFontSize(context
                                                        .resources
                                                        .fontSize
                                                        .dp14),
                                              ),
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ));
                    }),
              ),
            )));
  }
}
