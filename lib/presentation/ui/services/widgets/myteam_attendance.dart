import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/presentation/bloc/attendance/attendance_bloc.dart';

import '../../../../domain/entities/employee_entity.dart';
import '../../../../injection_container.dart';
import '../../../bloc/services/services_bloc.dart';
import '../../widgets/dashed_progress_indicator.dart';

class MyTeamAttendance extends StatefulWidget {
  MyTeamAttendance({super.key});

  @override
  State<StatefulWidget> createState() => _MyTeamAttendanceState();
}

class _MyTeamAttendanceState extends State<MyTeamAttendance>
    with SingleTickerProviderStateMixin {
  final _servicesBloc = sl<ServicesBloc>();
  final _attendanceBloc = sl<AttendanceBloc>();
  final ValueNotifier<List<EmployeeEntity>> _employeesList = ValueNotifier([]);
  final ValueNotifier<List<EmployeeEntity>> _notPunchedemployeesList =
      ValueNotifier([]);
  final ValueNotifier<bool> _isnotPunchedemployeesExpanded =
      ValueNotifier(false);
  String userName = '';
  ValueNotifier<double> _fraction = ValueNotifier(0.0);
  int loggedInEmployees = 0;
  late Animation<double> _animation;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  _startAnimation(double end) {
    printLog(message: 'OnAttendanceSuccess $end');
    _animation = Tween(begin: 0.0, end: end).animate(_controller)
      ..addListener(() {
        _fraction.value = _animation.value;
      });

    _controller.forward();
  }

  _getAttendanceByEmployee() async {
    var date = DateFormat('ddMMyyyy').format(DateTime.now());
    for (int i = 0; i < _employeesList.value.length; i++) {
      Map<String, dynamic> requestParams = {
        'date-range': '$date-$date',
        'oracle_id': _employeesList.value[i].pERSONID
      };
      await _attendanceBloc.getAttendance(
          requestParams: requestParams, returnValue: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    userName = context.userDB.get(userNameKey, defaultValue: '');
    final resources = context.resources;
    var percentage = 0.0;
    _servicesBloc.getEmployeesByManager(requestParams: {'USER_NAME': userName});
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _servicesBloc),
        BlocProvider(create: (context) => _attendanceBloc)
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnEmployeesSuccess) {
                _employeesList.value = state.employeesList;
                _getAttendanceByEmployee();
              }
            },
          ),
          BlocListener<AttendanceBloc, AttendanceState>(
            listener: (context, state) {
              if (state is OnAttendanceSuccess) {
                if (state.attendanceEntity.entity?.attendanceList.isNotEmpty ??
                    false) {
                  if (state.attendanceEntity.entity?.attendanceList[0]
                          .punch1Time?.isNotEmpty ??
                      false) {
                    loggedInEmployees++;
                    percentage =
                        loggedInEmployees / _employeesList.value.length;
                    _fraction.value = percentage;
                  } else {
                    final employee = _employeesList.value
                        .where((element) =>
                            element.pERSONID ==
                            (state.attendanceEntity.entity?.attendanceList[0]
                                    .userid ??
                                ''))
                        .first;
                    final list = _notPunchedemployeesList.value;
                    list.add(employee);
                    _notPunchedemployeesList.value = [];
                    _notPunchedemployeesList.value = list;
                  }
                }
              }
            },
          )
        ],
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: _fraction,
                builder: (context, value, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      value > 0
                          ? CustomPaint(
                              painter: DashedProgressIndicator(
                                  percent: value,
                                  strokeWidth: resources.dimen.dp15,
                                  color: percentage == 1
                                      ? resources.color.colorGreen26B757
                                      : resources.color.bgGradientStart),
                              size: const Size(200, 200))
                          : const SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                              ),
                            ),
                      Text(
                        '${(value * 100).round()}%',
                        style: context.textFontWeight600
                            .onFontSize(35)
                            .onFontFamily(fontFamily: fontFamilyEN),
                      ),
                    ],
                  );
                }),
            SizedBox(
              height: resources.dimen.dp20,
            ),
            Text(
              context.string.teamStatusText,
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp15),
            ),
            SizedBox(
              height: resources.dimen.dp5,
            ),
            Text(
              getCurrentDateByformat('dd/MM/yyyy'),
              style: context.textFontWeight400
                  .onFontSize(resources.fontSize.dp15)
                  .onFontFamily(fontFamily: fontFamilyEN)
                  .onColor(resources.color.bgGradientStart),
            ),
            SizedBox(
              height: resources.dimen.dp30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.string.numberOfEmployee,
                  style: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp15),
                ),
                ValueListenableBuilder(
                    valueListenable: _employeesList,
                    builder: (context, employeesList, child) {
                      return Text(
                        '${employeesList.length}',
                        style: context.textFontWeight600
                            .onFontFamily(fontFamily: fontFamilyEN)
                            .onFontSize(resources.fontSize.dp15),
                      );
                    }),
              ],
            ),
            SizedBox(
              height: resources.dimen.dp15,
            ),
            Divider(
              height: resources.dimen.dp1,
              color: resources.color.bottomSheetIconUnSelected,
            ),
            SizedBox(
              height: resources.dimen.dp15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.string.employeesPunchedIn,
                  style: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp15),
                ),
                ValueListenableBuilder(
                    valueListenable: _fraction,
                    builder: (context, value, child) {
                      return Text(
                        '$loggedInEmployees',
                        style: context.textFontWeight600
                            .onFontFamily(fontFamily: fontFamilyEN)
                            .onFontSize(resources.fontSize.dp15),
                      );
                    }),
              ],
            ),
            SizedBox(
              height: resources.dimen.dp15,
            ),
            Divider(
              height: resources.dimen.dp1,
              color: resources.color.bottomSheetIconUnSelected,
            ),
            InkWell(
              onTap: () {
                _isnotPunchedemployeesExpanded.value =
                    !_isnotPunchedemployeesExpanded.value;
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: resources.dimen.dp15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.string.employeesNotPunchedIn,
                      style: context.textFontWeight400
                          .onFontSize(resources.fontSize.dp15),
                    ),
                    ValueListenableBuilder(
                        valueListenable: _fraction,
                        builder: (context, value, child) {
                          return Text(
                            '${_employeesList.value.length - loggedInEmployees}',
                            style: context.textFontWeight600
                                .onFontFamily(fontFamily: fontFamilyEN)
                                .onFontSize(resources.fontSize.dp15),
                          );
                        }),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: _notPunchedemployeesList,
                builder: (context, list, child) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        list.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            isLocalEn
                                ? list[index].empNameEN ?? ''
                                : list[index].empNameAR ?? '',
                            textAlign: TextAlign.left,
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp15),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            Divider(
              height: resources.dimen.dp1,
              color: resources.color.bottomSheetIconUnSelected,
            ),
            SizedBox(
              height: resources.dimen.dp15,
            ),
          ],
        ),
      ),
    );
  }
}
