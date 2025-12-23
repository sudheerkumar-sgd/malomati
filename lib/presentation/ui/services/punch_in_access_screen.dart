// ignore_for_file: must_be_immutable
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/item_thankyou_month.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/action_button_widget.dart';
import 'package:malomati/presentation/ui/widgets/alert_dialog_widget.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';

import '../widgets/back_app_bar.dart';

class PunchInAccessScreen extends StatelessWidget {
  static const String route = '/PunchInAccessScreen';
  PunchInAccessScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String? leave;
  bool isLoading = false;
  final List<EmployeeEntity> _employeesList = [];
  final ValueNotifier<int> _selectedTabIndex = ValueNotifier(1);
  final ValueNotifier<bool> _doRefresh = ValueNotifier(false);
  final _attendanceBloc = sl<AttendanceBloc>();
  int loggedInEmployees = 0;
  final List<EmployeeEntity> _disabledmployeesList = [];
  EmployeeEntity? _selectedEmployee;
  final ScrollController _monthScrollController = ScrollController();
  ValueNotifier<int> selectedMonth = ValueNotifier(0);
  List<Map> monthYearList = [];
  void _getYearMonth() {
    int currentDate = DateTime.now().day;
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;

    var date = DateTime.now();
    for (int i = 1; i <= currentDate; i++) {
      monthYearList.add({
        'index': i - 1,
        'year': getDateByformat('MMM', date),
        'month': '$i',
        'start_date': getDateByformat(
            'yyyy-MM-dd', DateTime(currentYear, currentMonth, 1)),
        'end_date': getDateByformat(
            'yyyy-MM-dd', DateTime(currentYear, currentMonth, currentDate))
      });
    }
    selectedMonth.value = currentDate - 1;
  }

  void _setScrollByDirection(double offset) {
    _monthScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<void> _disableOrEnablePunchAccess(BuildContext context,
      String employeeId, String userName, int accessValue) async {
    Dialogs.loader(context);
    final response = await _attendanceBloc.getUserDetails(
        apiUrl:
            '$setUserPunchAccessApiUrl;id=$employeeId;punch-api=$accessValue',
        requestParams: {});
    if (!context.mounted) {
      return;
    }
    Dialogs.dismiss(context);
    if (response is OnAttendanceApiError) {
      Dialogs.showInfoDialog(context, PopupType.fail, response.message);
    } else if (response is OnUserDetailsSuccess) {
      _servicesBloc.sendPushNotifications(
          requestParams: getFCMMessageData(
              to: userName.toUpperCase(),
              title: accessValue == 0
                  ? 'Punch Access Disabled'
                  : 'Punch Access Enabled',
              body: accessValue == 0
                  ? 'Your punch access has been disabled. Please use the office machine to punch in.'
                  : 'Your punch access has been enabled. You can now punch in via the mobile app.',
              type: '',
              notificationId: 'AB3CDEFG76HIJK'));
      Dialogs.showInfoDialog(context, PopupType.success, context.string.success)
          .then((value) {
        _doRefresh.value = !_doRefresh.value;
        if (context.mounted && accessValue == 0) {
          Dialogs.dismiss(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    _getYearMonth();
    _servicesBloc
        .getEmployeesByDepartment(requestParams: {'DEPARTMENT_NUMBER': 63});
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => _servicesBloc),
            BlocProvider(create: (context) => _attendanceBloc)
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<ServicesBloc, ServicesState>(
                listener: (context, state) {
                  if (state is OnEmployeesSuccess) {
                    _employeesList.addAll(state.employeesList);
                    _doRefresh.value = !_doRefresh.value;
                  }
                },
              ),
              BlocListener<AttendanceBloc, AttendanceState>(
                listener: (context, state) {
                  if (state is OnUserDetailsSuccess) {
                    // _disabledmployeesList =
                    //     state.attendanceUserDetailsEntity.entity?.usersData ??
                    //         [];
                  } else if (state is OnAttendanceApiError) {}
                },
              )
            ],
            child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: context.resources.dimen.dp20,
                    horizontal: context.resources.dimen.dp25),
                child: Column(
                  children: [
                    SizedBox(
                      height: context.resources.dimen.dp10,
                    ),
                    BackAppBarWidget(
                        title: isLocalEn
                            ? 'Mobile Punch Access'
                            : 'صلاحية بصمة الموبايل'),
                    SizedBox(
                      height: context.resources.dimen.dp20,
                    ),
                    ValueListenableBuilder(
                        valueListenable: _selectedTabIndex,
                        builder: (context, selectedTabIndex, child) {
                          return Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (selectedTabIndex == 1) {
                                      Dialogs.showDialogWithClose(
                                          context,
                                          maxWidth:
                                              getScrrenSize(context).width * .8,
                                          Column(
                                            children: [
                                              Form(
                                                key: _formKey,
                                                child: DropDownWidget<
                                                    EmployeeEntity>(
                                                  list: _employeesList,
                                                  height: context
                                                      .resources.dimen.dp27,
                                                  labelText: context
                                                      .string.selectEmployee,
                                                  hintText: context
                                                      .string.selectEmployee,
                                                  errorMessage: context
                                                      .string.selectEmployee,
                                                  suffixIconPath: DrawableAssets
                                                      .icChevronDown,
                                                  fillColor: context.resources
                                                      .color.colorLightBg,
                                                  callback: (value) {
                                                    _selectedEmployee = value;
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: context
                                                    .resources.dimen.dp20,
                                              ),
                                              InkWell(
                                                  onTap: () async {
                                                    if (_formKey.currentState
                                                            ?.validate() ==
                                                        true) {
                                                      _disableOrEnablePunchAccess(
                                                          context,
                                                          _selectedEmployee
                                                                  ?.eMPLOYEENUMBER ??
                                                              '',
                                                          _selectedEmployee
                                                                  ?.uSERNAME ??
                                                              '',
                                                          0);
                                                    }
                                                  },
                                                  child: ActionButtonWidget(
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
                                                    text: isLocalEn
                                                        ? 'Disable Access'
                                                        : 'تعطيل الصلاحية',
                                                    textStyle: context
                                                        .textFontWeight600
                                                        .onFontSize(resources
                                                            .fontSize.dp12),
                                                  )),
                                            ],
                                          ));
                                    } else {
                                      _selectedTabIndex.value = 1;
                                      _doRefresh.value = !_doRefresh.value;
                                    }
                                  },
                                  child: ActionButtonWidget(
                                    padding: EdgeInsets.symmetric(
                                        vertical: context.resources.dimen.dp5,
                                        horizontal:
                                            context.resources.dimen.dp15),
                                    color: context.resources.color.viewBgColor
                                        .withAlpha(
                                            selectedTabIndex == 2 ? 100 : 255),
                                    text:
                                        isLocalEn ? 'Add User' : 'إضافة مستخدم',
                                    textStyle: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: context.resources.dimen.dp20,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (selectedTabIndex == 1) {
                                      Timer(const Duration(milliseconds: 100),
                                          () {
                                        _setScrollByDirection(
                                            _monthScrollController
                                                    .position.maxScrollExtent +
                                                100);
                                      });
                                      _selectedTabIndex.value = 2;
                                      _doRefresh.value = !_doRefresh.value;
                                    }
                                  },
                                  child: ActionButtonWidget(
                                    padding: EdgeInsets.symmetric(
                                        vertical: context.resources.dimen.dp5,
                                        horizontal:
                                            context.resources.dimen.dp15),
                                    text: isLocalEn
                                        ? 'Late Door Report'
                                        : 'تقرير تأخير',
                                    color: context.resources.color.viewBgColor
                                        .withAlpha(
                                            selectedTabIndex == 1 ? 100 : 255),
                                    textStyle: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp10),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                    SizedBox(
                      height: context.resources.dimen.dp40,
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: _doRefresh,
                          builder: (context, doRefresh, child) {
                            final employees = _employeesList
                                .map((e) => e.eMPLOYEENUMBER)
                                .join(',');
                            return _employeesList.isEmpty
                                ? Center(
                                    child: Text(
                                      isLocalEn
                                          ? 'No employees'
                                          : 'لا يوجد موظفين',
                                      style: context.textFontWeight600,
                                    ),
                                  )
                                : _selectedTabIndex.value == 1
                                    ? FutureBuilder(
                                        future: _attendanceBloc.getUserDetails(
                                            apiUrl:
                                                '${attendanceUserPunchDetailsApiUrl}id=$employees',
                                            requestParams: {},
                                            emitResult: false),
                                        builder: (context, asyncSnapshot) {
                                          if (asyncSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            _disabledmployeesList.clear();
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          final state = asyncSnapshot.data;
                                          if (state is OnAttendanceApiError) {
                                            return Center(
                                                child: Text(
                                              state.message,
                                              style: context.textFontWeight600,
                                            ));
                                          } else if (state
                                              is OnUserDetailsSuccess) {
                                            _disabledmployeesList.addAll(
                                                (state.attendanceUserDetailsEntity
                                                            .entity?.usersData ??
                                                        [])
                                                    .where((e) =>
                                                        e.punchApiAccess ==
                                                        '0'));
                                          }
                                          return _disabledmployeesList.isEmpty
                                              ? Center(
                                                  child: Text(
                                                    isLocalEn
                                                        ? 'No disabled employees'
                                                        : 'لا يوجد موظفين معطلين',
                                                    style: context
                                                        .textFontWeight600,
                                                  ),
                                                )
                                              : ListView.separated(
                                                  itemCount:
                                                      _disabledmployeesList
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            _disabledmployeesList[
                                                                        index]
                                                                    .empNameEN ??
                                                                '',
                                                            style: context
                                                                .textFontWeight600
                                                                .onFontSize(
                                                                    resources
                                                                        .fontSize
                                                                        .dp12)
                                                                .onFontFamily(
                                                                    fontFamily:
                                                                        fontFamilyEN),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: context
                                                              .resources
                                                              .dimen
                                                              .dp10,
                                                        ),
                                                        InkWell(
                                                            onTap: () {
                                                              _disableOrEnablePunchAccess(
                                                                  context,
                                                                  _disabledmployeesList[
                                                                              index]
                                                                          .pERSONID ??
                                                                      '',
                                                                  _disabledmployeesList[
                                                                              index]
                                                                          .uSERNAME ??
                                                                      '',
                                                                  1);
                                                            },
                                                            child: ImageWidget(
                                                                    path: DrawableAssets
                                                                        .icDelete)
                                                                .loadImage),
                                                      ],
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5.0),
                                                      child: Divider(
                                                        color: const Color(
                                                            0xFFD6D6D6),
                                                      ),
                                                    );
                                                  },
                                                );
                                        })
                                    : ValueListenableBuilder(
                                        valueListenable: selectedMonth,
                                        builder: (context, value, child) {
                                          final dateTime = DateTime.now();
                                          var date = getDateByformat(
                                              'ddMMyyyy',
                                              DateTime(dateTime.year,
                                                  dateTime.month, value + 1));
                                          final dateRange =
                                              '${date}000000-${date}235959';
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 70,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        _setScrollByDirection(
                                                            _monthScrollController
                                                                .position
                                                                .minScrollExtent);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 8.0,
                                                                right: 8.0,
                                                                bottom: 8.0),
                                                        child: ImageWidget(
                                                          path: DrawableAssets
                                                              .icChevronLeft,
                                                          isLocalEn: resources
                                                              .isLocalEn,
                                                        ).loadImage,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: ListView.separated(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        shrinkWrap: true,
                                                        controller:
                                                            _monthScrollController,
                                                        separatorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return const SizedBox(
                                                              width: 20);
                                                        },
                                                        itemCount: monthYearList
                                                            .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return ItemThankyouMonth(
                                                              data:
                                                                  monthYearList[
                                                                      index],
                                                              selectedMonth:
                                                                  selectedMonth);
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    InkWell(
                                                      onTap: () {
                                                        _setScrollByDirection(
                                                            _monthScrollController
                                                                    .position
                                                                    .maxScrollExtent +
                                                                50);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 8.0,
                                                          top: 8.0,
                                                          right: 8.0,
                                                        ),
                                                        child: ImageWidget(
                                                          path: DrawableAssets
                                                              .icChevronRight,
                                                          isLocalEn: resources
                                                              .isLocalEn,
                                                        ).loadImage,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: resources.dimen.dp25,
                                              ),
                                              FutureBuilder(
                                                  future: _attendanceBloc
                                                      .getLateDoorReport(
                                                    apiUrl:
                                                        'date-range=$dateRange;userid=$employees',
                                                  ),
                                                  builder:
                                                      (context, asyncSnapshot) {
                                                    if (asyncSnapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }
                                                    final lateEmployee =
                                                        asyncSnapshot.data ??
                                                            [];

                                                    return lateEmployee.isEmpty
                                                        ? Center(
                                                            child: Text(
                                                              isLocalEn
                                                                  ? 'No employees'
                                                                  : 'لا يوجد موظفين معطلين',
                                                              style: context
                                                                  .textFontWeight600,
                                                            ),
                                                          )
                                                        : Expanded(
                                                            child: ListView
                                                                .separated(
                                                              itemCount:
                                                                  lateEmployee
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      lateEmployee[index]
                                                                              .username ??
                                                                          '',
                                                                      style: context
                                                                          .textFontWeight600
                                                                          .onFontFamily(
                                                                              fontFamily: fontFamilyEN),
                                                                    ),
                                                                    SizedBox(
                                                                      height: context
                                                                          .resources
                                                                          .dimen
                                                                          .dp5,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text.rich(TextSpan(
                                                                            text: lateEmployee[index].specialfunctionid ??
                                                                                '',
                                                                            style:
                                                                                context.textFontWeight400.onFontSize(10),
                                                                            children: [
                                                                              TextSpan(
                                                                                text: '\n${(lateEmployee[index].taEventIn ?? '').substring(11, (lateEmployee[index].taEventIn ?? '').length)}',
                                                                                style: context.textFontWeight400.onFontSize(10).onFontFamily(fontFamily: fontFamilyEN),
                                                                              )
                                                                            ])),
                                                                        SizedBox(
                                                                          width: context
                                                                              .resources
                                                                              .dimen
                                                                              .dp10,
                                                                        ),
                                                                        Text.rich(TextSpan(
                                                                            text: isLocalEn
                                                                                ? 'Door In'
                                                                                : 'دخول الباب',
                                                                            style:
                                                                                context.textFontWeight400.onFontSize(10),
                                                                            children: [
                                                                              TextSpan(
                                                                                text: '\n${(lateEmployee[index].acsEventIn ?? '').substring(11, (lateEmployee[index].acsEventIn ?? '').length)}',
                                                                                style: context.textFontWeight400.onFontSize(10).onFontFamily(fontFamily: fontFamilyEN),
                                                                              )
                                                                            ])),
                                                                        SizedBox(
                                                                          width: context
                                                                              .resources
                                                                              .dimen
                                                                              .dp10,
                                                                        ),
                                                                        Expanded(
                                                                          child: Text.rich(
                                                                              textAlign: TextAlign.end,
                                                                              TextSpan(text: isLocalEn ? 'Late Time' : 'الوقت التأخير', style: context.textFontWeight400.onFontSize(10), children: [
                                                                                TextSpan(
                                                                                  text: '\n${minutesToHHmm(lateEmployee[index].taToAcsInDiff)}',
                                                                                  style: context.textFontWeight400.onFontSize(10).onFontFamily(fontFamily: fontFamilyEN),
                                                                                )
                                                                              ])),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                              separatorBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5.0),
                                                                  child:
                                                                      Divider(
                                                                    color: const Color(
                                                                        0xFFD6D6D6),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                  }),
                                            ],
                                          );
                                        });
                          }),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
