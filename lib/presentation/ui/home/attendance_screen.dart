import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:malomati/config/flavor_config.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/managers/location_access_manager.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:malomati/presentation/ui/home/widgets/official_in_widget.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/utils/location.dart';
import 'package:malomati/presentation/ui/widgets/alert_dialog_widget.dart';
import 'package:malomati/presentation/ui/widgets/back_app_bar.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';

import '../../../res/drawables/background_box_decoration.dart';
import '../../../res/drawables/drawable_assets.dart';
import '../../../res/resources.dart';

enum AttendanceType {
  punchIn,
  punchOut,
}

class AttendanceScreen extends StatelessWidget {
  final AttendanceType attendanceType;
  final AttendanceEntity? attendanceEntity;

  const AttendanceScreen({
    super.key,
    required this.attendanceType,
    required this.attendanceEntity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AttendanceBloc>(),
      child: AttendanceView(
        attendanceType: attendanceType,
        attendanceEntity: attendanceEntity,
      ),
    );
  }
}

class AttendanceView extends StatefulWidget {
  final AttendanceType attendanceType;
  final AttendanceEntity? attendanceEntity;

  const AttendanceView({
    super.key,
    required this.attendanceType,
    required this.attendanceEntity,
  });

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  late final AttendanceBloc _attendanceBloc;
  late final LocationAccessManager _locationAccessManager;

  late final TransformationController _mapController;

  late final ValueNotifier<String> _timeNotifier;

  Timer? _timer;

  AttendanceEntity? attendanceEntity;

  Position? currentPosition;

  Map<String, dynamic> department = {};

  Map<String, dynamic>? selectedOption;

  List<Map<String, dynamic>> attendanceOptions = [];

  Resources get resources => context.resources;

  @override
  void initState() {
    super.initState();

    _attendanceBloc = context.read<AttendanceBloc>();

    _locationAccessManager = sl<LocationAccessManager>();

    attendanceEntity = widget.attendanceEntity;

    _mapController = TransformationController();

    _timeNotifier = ValueNotifier(
      getCurrentDateByformat('hh:mm:ss aa'),
    );

    _initialize();
  }

  Future<void> _initialize() async {
    _setZoom();

    _startClock();

    await _checkLocationStatus();

    _loadAttendance();
  }

  void _startClock() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _timeNotifier.value = getCurrentDateByformat('hh:mm:ss aa');
      },
    );
  }

  void _setZoom() {
    _mapController.value.setEntry(0, 0, 2);
    _mapController.value.setEntry(1, 1, 2);
    _mapController.value.setEntry(2, 2, 2);
    _mapController.value.setEntry(0, 3, -160);
    _mapController.value.setEntry(1, 3, -80);
  }

  Future<void> _checkLocationStatus() async {
    final isLocationEnabled = await Location.checkGps();

    if (!isLocationEnabled && mounted) {
      Dialogs.showInfoDialog(
        context,
        PopupType.fail,
        context.string.locationErrorText,
      );
    }
  }

  void _loadAttendance() {
    final date = getDateByformat(
      'ddMMyyyy',
      DateTime.now(),
    );

    _attendanceBloc.getAttendance(
      requestParams: {
        'date-range': '$date-$date',
      },
    );

    _attendanceBloc.getAttendanceDetails(
      dateRange: '${date}000000-${date}235959',
    );
  }

  bool _isRamadanMonth() {
    final now = DateTime.now();

    return (now.day > 18 && now.month == 2) || (now.day < 21 && now.month == 3);
  }

  bool _canRegularIn() {
    final hour = DateTime.now().hour;
    final minute = DateTime.now().minute;

    if (_isRamadanMonth()) {
      return (((hour == 7 && minute > 30) ||
              ((hour > 7 && hour < 10) || (hour == 10 && minute < 1))) &&
          (attendanceEntity?.punch1Time ?? '').isEmpty);
    }

    return ((hour < 8) && (attendanceEntity?.punch1Time ?? '').isEmpty);
  }

  bool _canOvertimeIn() {
    final now = DateTime.now();

    switch (now.weekday) {
      case 5:
        return (now.hour < 6 || (now.hour == 6 && now.minute <= 30)) ||
            (now.hour > 12 || (now.hour == 12 && now.minute >= 30));

      case 6:
      case 7:
        return true;

      default:
        return (now.hour < 6 || (now.hour == 6 && now.minute <= 30)) ||
            now.hour >= 16;
    }
  }

  bool _canOvertimeOut() {
    final now = DateTime.now();

    switch (now.weekday) {
      case 5:
        return (now.hour < 6 || (now.hour == 6 && now.minute <= 59)) ||
            now.hour >= 13;

      case 6:
      case 7:
        return true;

      default:
        return (now.hour < 6 || (now.hour == 6 && now.minute <= 59)) ||
            (now.hour > 16 || (now.hour == 16 && now.minute >= 30));
    }
  }

  List<Map<String, dynamic>> _attendanceOptions() {
    if (widget.attendanceType == AttendanceType.punchIn) {
      return [
        {
          'name': context.string.regularIn,
          'id': '5',
          'isEnabled': _canRegularIn(),
        },
        {
          'name': context.string.shortLeaveIn,
          'id': '3',
          'isEnabled': true,
        },
        {
          'name': context.string.officialIn,
          'id': '1',
          'isEnabled': true,
        },
        {
          'name': context.string.overtimeIn,
          'id': '9',
          'isEnabled': _canOvertimeIn(),
        },
      ];
    }

    return [
      {
        'name': context.string.regularOut,
        'id': '6',
        'isEnabled': true,
      },
      {
        'name': context.string.shortLeaveOut,
        'id': '4',
        'isEnabled': true,
      },
      {
        'name': context.string.officialWorkOut,
        'id': '2',
        'isEnabled': true,
      },
      {
        'name': context.string.overtimeOut,
        'id': '10',
        'isEnabled': _canOvertimeOut(),
      },
    ];
  }

  Future<void> _submitAttendance(
    Map<String, dynamic> option,
  ) async {
    selectedOption = option;

    if (mounted) {
      Dialogs.showInfoLoader(
        context,
        context.string.fetchingLocationDetails,
      );
    }

    final isLocationEnabled = await Location.checkGps();

    if (!isLocationEnabled) {
      if (mounted) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();

        Dialogs.showInfoDialog(
          context,
          PopupType.fail,
          context.string.locationErrorText,
        );
      }

      return;
    }

    currentPosition = await Location.getLocation();

    if (mounted) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop();
    }

    department = await _locationAccessManager.getAllowedDepartmentByLocation(
      currentPosition?.latitude ?? 0,
      currentPosition?.longitude ?? 0,
    );

    if ((department['name'] ?? '').isEmpty) {
      _attendanceBloc.getUserDetails(
        showLoading: true,
        requestParams: {},
      );
    } else {
      _submitToServer();
    }
  }

  void _submitToServer() {
    final requestParams = {
      "userid": context.userDB.get(
        oracleLoginIdKey,
      ),
      "date": getCurrentDateByformat(
        'ddMMyyyyHHmmss',
      ),
      "latitude": department['latitude'] ??
          '+${(currentPosition?.latitude ?? 0.0).toStringAsFixed(4)}',
      "longitude": department['longitude'] ??
          '+${(currentPosition?.longitude ?? 0.0).toStringAsFixed(4)}',
      "method": selectedOption?['id'],
      "isInOut": widget.attendanceType == AttendanceType.punchIn ? "0" : "1",
    };

    final isOfficial = ['1', '2', '9', '10'].contains(selectedOption?['id']);

    if (isOfficial) {
      _showOfficialReasonDialog(
        requestParams,
      );
      return;
    }

    if (FlavorConfig.isProduction()) {
      _attendanceBloc.submitAttendance(
        requestParams: requestParams,
      );
    }
  }

  void _showOfficialReasonDialog(
    Map<String, dynamic> requestParams,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final datetime = DateTime.now();

        requestParams['date'] = DateFormat(
          'ddMMyyyyHHmmss',
        ).format(datetime);

        return OfficialInWidgetWidget(
          title: selectedOption?['name'],
          type: selectedOption?['id'],
          callBack: (value) {
            _attendanceBloc.submitOfficialInReason(
              requestParams: {
                "punchTime": DateFormat('HH:mm:ss').format(datetime),
                "punshDate": DateFormat('dd-MMM-yy').format(datetime),
                "punchType": selectedOption?['id'],
                "ioType": "0",
                "userRefCode": context.userDB.get(
                  userPersonIdKey,
                ),
                "userName": context.userDB.get(
                  userFullNameUsKey,
                ),
                "creationDate": DateFormat('dd/MM/yyyy').format(datetime),
                "flag": "",
                "errorMsg": "",
                "info1": context.userDB.get(
                  oracleLoginIdKey,
                ),
                "info2": "",
                "requestId": "",
                "reason": value,
              },
            );

            if (FlavorConfig.isProduction()) {
              _attendanceBloc.submitAttendance(
                requestParams: requestParams,
              );
            }
          },
        );
      },
    );
  }

  Future<String> _getLocationName() async {
    if ((department['name'] ?? '').isNotEmpty) {
      return department['name'];
    }

    return Location.getPlaceByLocation(
      double.parse(
        attendanceEntity?.gpsLatitude ?? '0.0',
      ),
      double.parse(
        attendanceEntity?.gpsLongitude ?? '0.0',
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeNotifier.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    attendanceOptions = _attendanceOptions();
    return SafeArea(
      child: Scaffold(
        backgroundColor: resources.color.appScaffoldBg,
        body: BlocListener<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is OnAttendanceDataLoading) {
              Dialogs.loader(context);
            }

            if (state is OnAttendanceSubmitSuccess) {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop();
              Navigator.of(context).pop(true);
            }

            if (state is OnAttendanceApiError) {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop();

              Dialogs.showInfoDialog(
                context,
                PopupType.fail,
                state.message,
              );
            }

            if (state is OnUserDetailsSuccess) {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop();

              if (state.attendanceUserDetailsEntity.entity?.locationMandatory ==
                  "1") {
                _submitToServer();
              } else {
                Dialogs.showInfoDialog(
                  context,
                  PopupType.fail,
                  context.string.attendancelocationErrorMessage,
                );
              }
            }
          },
          child: StreamBuilder(
            stream: _attendanceBloc.getAttendanceData,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                attendanceEntity = snapshot.data;

                department = getDepartmentByLocation(
                  double.parse(
                    attendanceEntity?.gpsLatitude ?? '0.0',
                  ),
                  double.parse(
                    attendanceEntity?.gpsLongitude ?? '0.0',
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp20,
                  horizontal: resources.dimen.dp25,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: resources.dimen.dp10,
                    ),
                    BackAppBarWidget(
                      title: widget.attendanceType == AttendanceType.punchIn
                          ? context.string.punchIn
                          : context.string.punchOut,
                    ),
                    SizedBox(
                      height: resources.dimen.dp25,
                    ),
                    if (snapshot.data == null) ...[
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                    if (snapshot.data != null) ...[
                      InteractiveViewer(
                        transformationController: _mapController,
                        panEnabled: false,
                        minScale: 1,
                        maxScale: 4,
                        child: ImageWidget(
                          width: double.infinity,
                          height: 200,
                          path: department['map'] ?? DrawableAssets.icMap,
                          boxType: BoxFit.cover,
                        ).loadImage,
                      ),
                      SizedBox(
                        height: resources.dimen.dp25,
                      ),
                      ValueListenableBuilder(
                        valueListenable: _timeNotifier,
                        builder: (
                          context,
                          value,
                          child,
                        ) {
                          return Text(
                            value,
                            style: context.textFontWeight600
                                .onFontSize(
                                  context.resources.fontSize.dp20,
                                )
                                .onFontFamily(fontFamily: fontFamilyEN),
                          );
                        },
                      ),
                      SizedBox(
                        height: resources.dimen.dp10,
                      ),
                      FutureBuilder<String>(
                        future: _getLocationName(),
                        builder: (context, location) {
                          return Text(
                            '${context.string.location}: ${location.data ?? ''}',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          );
                        },
                      ),
                      SizedBox(
                        height: resources.dimen.dp30,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (final option in attendanceOptions)
                                InkWell(
                                  onTap: () {
                                    if (option['isEnabled']) {
                                      _submitAttendance(
                                        option,
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 180,
                                    margin: EdgeInsets.only(
                                      bottom: resources.dimen.dp20,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: resources.dimen.dp8,
                                      horizontal: resources.dimen.dp10,
                                    ),
                                    decoration: BackgroundBoxDecoration(
                                      boxColor: option['isEnabled']
                                          ? resources.color.viewBgColorLight
                                          : resources.color.colorF5C3C3,
                                      radious: resources.dimen.dp10,
                                    ).roundedCornerBox,
                                    child: Text(
                                      option['name'],
                                      textAlign: TextAlign.center,
                                      style: context.textFontWeight400.onColor(
                                        context.resources.color.colorWhite,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
