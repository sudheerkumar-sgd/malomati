// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/constants/data_constants.dart';
import 'package:malomati/core/network/api_urls.dart';
import 'package:malomati/domain/mappers/department_json_mapper.dart';
import 'package:malomati/domain/entities/department_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/date_time_util.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';

import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class ContractRenewScreen extends StatelessWidget {
  static const String route = '/BadgeScreen';
  ContractRenewScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  final TextEditingController empNumberController = TextEditingController();
  final TextEditingController _hireDateController = TextEditingController();
  final TextEditingController _lastContractDateController =
      TextEditingController();
  final TextEditingController _newContractDateController =
      TextEditingController();
  List<DepartmentEntity> _departments = [];
  final ValueNotifier _employees = ValueNotifier<List<EmployeeEntity>>([]);
  DepartmentEntity? department;
  EmployeeEntity? employee;
  final dateFormat = 'yyyy-MM-dd';

  void _onDepartmentSelected(DepartmentEntity? value) {
    employee = null;
    department = value;
    _servicesBloc.getEmployeesByDepartment(
        requestParams: {'DEPARTMENT_NUMBER': department?.pAYROLLID ?? ''});
  }

  void _onEmployeeSelected(EmployeeEntity? value) {
    employee = value;
  }

  void _onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitRequest();
    }
  }

  void _submitRequest() {
    final requestParams = {
      "employeeNumber": employee?.pERSONID,
      "hireDate": _hireDateController.text,
      "oldContractStartDate": _lastContractDateController.text,
      "newContractStartDate": _newContractDateController.text,
      "organization": "",
      "userName": userName,
      "status": "",
      "errorMsg": "",
      "requestId": "",
      "requestDate": ""
    };
    _servicesBloc.submitServicesRequest(
        apiUrl: renewContractApiUrl, requestParams: requestParams);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller,
      {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    selectDate(context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate, callBack: (dateTime) {
      controller.text = getDateByformat(dateFormat, dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    _departments = departments
        .map((departmentJson) =>
            DepartmentJsonMapper.toDepartmentEntity(departmentJson))
        .toList();
    empNumberController.text =
        context.userDB.get(userJobIdEnKey, defaultValue: '');
    _hireDateController.text = getDateByformat(
        dateFormat,
        getDateTimeByString('dd/MM/yyyy',
            context.userDB.get(userJoiningDateEnKey, defaultValue: '')));
    final lastContractDate =
        context.userDB.get(userContractDateKey, defaultValue: '');
    if (lastContractDate.isNotEmpty) {
      _lastContractDateController.text = getDateByformat(
          dateFormat, getDateTimeByString('dd/MM/yyyy', lastContractDate));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                Dialogs.loader(context);
              } else if (state is OnEmployeesSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                _employees.value = state.employeesList;
              } else if (state is OnServicesRequestSubmitSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                if (state.servicesRequestSuccessResponse.isSuccess ?? false) {
                  Dialogs.showInfoDialog(
                          context,
                          PopupType.success,
                          state.servicesRequestSuccessResponse
                              .getDisplayMessage(resources))
                      .then((value) => Navigator.pop(context));
                  for (int i = 0;
                      i <
                          (state.servicesRequestSuccessResponse.entity
                                  ?.aPPROVERSLIST.length ??
                              0);
                      i++) {
                    _servicesBloc.sendPushNotifications(
                        requestParams: getFCMMessageData(
                            to: state.servicesRequestSuccessResponse.entity
                                    ?.aPPROVERSLIST[i] ??
                                '',
                            title: 'Renew Contract',
                            body:
                                '${context.userDB.get(userFullNameUsKey)} has Renewed Contract',
                            type: '',
                            notificationId: state.servicesRequestSuccessResponse
                                    .entity?.nTFID ??
                                ''));
                  }
                } else {
                  Dialogs.showInfoDialog(
                      context,
                      PopupType.fail,
                      state.servicesRequestSuccessResponse
                          .getDisplayMessage(resources));
                }
              } else if (state is OnServicesError) {
                Navigator.of(context, rootNavigator: true).pop();
                Dialogs.showInfoDialog(context, PopupType.fail, state.message);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: context.resources.dimen.dp20,
                  horizontal: context.resources.dimen.dp25),
              child: Column(
                children: [
                  SizedBox(
                    height: context.resources.dimen.dp10,
                  ),
                  BackAppBarWidget(title: context.string.contractRenewal),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // DropDownWidget<DepartmentEntity>(
                            //   list: _departments,
                            //   height: resources.dimen.dp27,
                            //   labelText: context.string.department,
                            //   errorMessage: context.string.department,
                            //   selectedValue: department,
                            //   callback: _onDepartmentSelected,
                            // ),
                            // SizedBox(
                            //   height: resources.dimen.dp20,
                            // ),
                            // ValueListenableBuilder(
                            //     valueListenable: _employees,
                            //     builder: (context, employees, widget) {
                            //       return DropDownWidget<EmployeeEntity>(
                            //         list: employees,
                            //         height: resources.dimen.dp27,
                            //         labelText: context.string.employee,
                            //         errorMessage: context.string.employee,
                            //         selectedValue: employee,
                            //         callback: _onEmployeeSelected,
                            //       );
                            //     }),
                            // SizedBox(
                            //   height: resources.dimen.dp20,
                            // ),
                            // RightIconTextWidget(
                            //   height: resources.dimen.dp27,
                            //   isEnabled: false,
                            //   labelText: context.string.employeeNumber,
                            //   hintText: context.string.employeeNumber,
                            //   errorMessage: context.string.employeeNumber,
                            //   textController: empNumberController,
                            //   fontFamily: fontFamilyEN,
                            // ),
                            // SizedBox(
                            //   height: resources.dimen.dp20,
                            // ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // _selectDate(context, _hireDateController,
                                      //     initialDate: _hireDateController
                                      //             .text.isNotEmpty
                                      //         ? getDateTimeByString(dateFormat,
                                      //             _hireDateController.text)
                                      //         : DateTime.now());
                                    },
                                    child: RightIconTextWidget(
                                      height: resources.dimen.dp27,
                                      isEnabled: false,
                                      labelText: context.string.hireDate,
                                      hintText: context.string.hireDate,
                                      fontFamily: fontFamilyEN,
                                      suffixIconPath: DrawableAssets.icCalendar,
                                      textController: _hireDateController,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: context.resources.dimen.dp10,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // _selectDate(
                                      //     context, _lastContractDateController,
                                      //     initialDate:
                                      //         _lastContractDateController
                                      //                 .text.isNotEmpty
                                      //             ? getDateTimeByString(
                                      //                 dateFormat,
                                      //                 _lastContractDateController
                                      //                     .text)
                                      //             : DateTime.now());
                                    },
                                    child: RightIconTextWidget(
                                      height: resources.dimen.dp27,
                                      isEnabled: false,
                                      labelText:
                                          context.string.lastContractStartDate,
                                      hintText:
                                          context.string.lastContractStartDate,
                                      fontFamily: fontFamilyEN,
                                      suffixIconPath: DrawableAssets.icCalendar,
                                      textController:
                                          _lastContractDateController,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            InkWell(
                              onTap: () {
                                _selectDate(context, _newContractDateController,
                                    initialDate: _newContractDateController
                                            .text.isNotEmpty
                                        ? getDateTimeByString(dateFormat,
                                            _newContractDateController.text)
                                        : DateTime.now());
                              },
                              child: RightIconTextWidget(
                                height: resources.dimen.dp27,
                                labelText: context.string.newContractStartDate,
                                hintText: context.string.newContractStartDate,
                                fontFamily: fontFamilyEN,
                                errorMessage:
                                    context.string.newContractStartDate,
                                suffixIconPath: DrawableAssets.icCalendar,
                                textController: _newContractDateController,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  SubmitCancelWidget(callBack: _onSubmit),
                  SizedBox(
                    height: resources.dimen.dp10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
