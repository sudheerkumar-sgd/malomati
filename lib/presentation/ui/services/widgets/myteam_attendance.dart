import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/presentation/bloc/attendance/attendance_bloc.dart';

import '../../../../domain/entities/employee_entity.dart';
import '../../../../injection_container.dart';
import '../../../bloc/services/services_bloc.dart';
import '../../widgets/dashed_progress_indicator.dart';

class MyTeamAttendance extends StatefulWidget {
  const MyTeamAttendance({super.key});

  @override
  State<StatefulWidget> createState() => _MyTeamAttendanceState();
}

class _MyTeamAttendanceState extends State<MyTeamAttendance> {
  final _servicesBloc = sl<ServicesBloc>();
  final _attendanceBloc = sl<AttendanceBloc>();
  final ValueNotifier<List<EmployeeEntity>> _employeesList = ValueNotifier([]);
  final ValueNotifier<List<EmployeeEntity>> _notPunchedemployeesList =
      ValueNotifier([]);
  final ValueNotifier<bool> _isnotPunchedemployeesExpanded =
      ValueNotifier(false);
  String userName = '';
  final ValueNotifier<double> _fraction = ValueNotifier(-1.0);
  int loggedInEmployees = 0;
  bool _didInit = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _getAttendanceByEmployee() async {
    loggedInEmployees = 0;
    _notPunchedemployeesList.value = [];
    _fraction.value = -1.0;
    var date = DateFormat('ddMMyyyy').format(DateTime.now());
    //for (int i = 0; i < _employeesList.value.length; i++) {
    Map<String, dynamic> requestParams = {
      'date-range': '$date-$date',
      'ids': _employeesList.value.map((e) => e.pERSONID).join(',')
    };
    final result = await _attendanceBloc.getEmployeesAttendance(
        requestParams: requestParams, returnValue: true);
    if (result is OnAttendanceSuccess) {
      final loggedEmployees = result.attendanceEntity.entity?.attendanceList
          .where((e) => e.punch1Time?.isNotEmpty ?? false)
          .map((e) => e.userid)
          .toList();
      loggedInEmployees = loggedEmployees?.length ?? 0;
      final notPunchedEmployees = _employeesList.value
          .where((e) => !loggedEmployees!.contains(e.pERSONID))
          .toList();
      _notPunchedemployeesList.value = notPunchedEmployees;
      final total = _employeesList.value.length;
      final percentage = total == 0 ? 0.0 : loggedInEmployees / total;
      for (int i = 1; i < loggedInEmployees + 1; i++) {
        _fraction.value = percentage * (i / loggedInEmployees);
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } else {
      final total = _employeesList.value.length;
      _fraction.value = total == 0 ? 0.0 : loggedInEmployees / total;
    }
    //}
  }

  void _loadMyTeamAttendance() {
    _servicesBloc.getEmployeesByManager(requestParams: {'USER_NAME': userName});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    _loadMyTeamAttendance();
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    var percentage = _fraction.value < 0 ? 0.0 : _fraction.value;
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
                _employeesList.value = state.employeesList
                    .where((element) => element.uSERNAME != userName)
                    .toList();
                _getAttendanceByEmployee();
              }
            },
          ),
          BlocListener<AttendanceBloc, AttendanceState>(
            listener: (context, state) async {
              if (state is OnAttendanceSuccess) {
                if (state.attendanceEntity.entity?.attendanceList.isNotEmpty ??
                    false) {
                  if (state.attendanceEntity.entity?.attendanceList[0]
                          .punch1Time?.isNotEmpty ??
                      false) {
                    loggedInEmployees++;
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
                final total = _employeesList.value.length;
                percentage = total == 0 ? 0.0 : loggedInEmployees / total;
              } else if (state is OnAttendanceApiError) {
                final total = _employeesList.value.length;
                percentage = total == 0 ? 0.0 : loggedInEmployees / total;
                _fraction.value = percentage;
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
                      value > -1
                          ? CustomPaint(
                              painter: DashedProgressIndicator(
                                  percent: value,
                                  strokeWidth: resources.dimen.dp15,
                                  color: percentage == 1
                                      ? resources.color.colorGreen26B757
                                      : resources.color.viewBgColorLight),
                              size: const Size(200, 200))
                          : const SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                              ),
                            ),
                      Text(
                        '${(value < 0 ? 0 : value * 100).round()}%',
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
                  .onColor(resources.color.viewBgColorLight),
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
            ValueListenableBuilder<bool>(
                valueListenable: _isnotPunchedemployeesExpanded,
                builder: (context, isExpanded, child) {
                  if (!isExpanded) {
                    return const SizedBox.shrink();
                  }
                  final list = _notPunchedemployeesList.value;
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

  @override
  void dispose() {
    _employeesList.dispose();
    _notPunchedemployeesList.dispose();
    _isnotPunchedemployeesExpanded.dispose();
    _fraction.dispose();
    _servicesBloc.close();
    _attendanceBloc.close();
    super.dispose();
  }
}
