// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/data/model/api_request_model.dart';
import 'package:malomati/data/model/department_model.dart';
import 'package:malomati/domain/entities/department_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/resources.dart';
import '../../../core/constants/data_constants.dart';
import '../../../data/model/response_models.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class CreateWarningScreen extends StatelessWidget {
  static const String route = '/CreateWarningScreen';
  CreateWarningScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  List<DepartmentEntity> _departments = [];
  List<NameIdEntity> _reasons = [];
  final ValueNotifier _employees = ValueNotifier<List<EmployeeEntity>>([]);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();
  DepartmentEntity? department;
  EmployeeEntity? employee;
  NameIdEntity? reason;
  ValueNotifier<int> selectedMonth = ValueNotifier(0);
  List<Map> monthYearList = [];
  String userName = '';
  String personId = '';

  onDepartmentSelected(DepartmentEntity? value) {
    employee = null;
    department = value;
    _servicesBloc.getEmployeesByDepartment(
        requestParams: {'DEPARTMENT_NUMBER': department?.pAYROLLID ?? ''});
  }

  onEmployeeSelected(EmployeeEntity? value) {
    employee = value;
  }

  onReasonSelected(NameIdEntity? value) {
    reason = value;
  }

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitThankyouRequest();
    }
  }

  _submitThankyouRequest() {
    final warningRequestModel = ApiRequestModel();
    warningRequestModel.uSERNAME = employee?.uSERNAME ?? '';
    warningRequestModel.cREATORUSERNAME = userName;
    warningRequestModel.rEASON = reason?.name ?? '';
    warningRequestModel.nOTE = _noteController.text;
    _servicesBloc.submitServicesRequest(
        apiUrl: submitWarningsApiUrl,
        requestParams: warningRequestModel.toWarningRequest());
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    personId = context.userDB.get(userPersonIdKey, defaultValue: '');
    _departments = departments
        .map((departmentJson) =>
            DepartmentModel.fromJson(departmentJson).toDepartmentEntity())
        .toList();
    _reasons = warningReasons
        .map((warningReasonsJson) =>
            WarningReasonsModel.fromJson(warningReasonsJson).toNameIdEntity())
        .toList();
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
                  if ((employee?.uSERNAME ?? '').isNotEmpty) {
                    _servicesBloc.sendPushNotifications(
                        requestParams: getFCMMessageData(
                            to: employee?.uSERNAME ?? '',
                            title: 'Warning!',
                            body:
                                '${context.userDB.get(userFullNameUsKey)}  has Warned You!\n${reason?.name ?? ''}',
                            type: '',
                            notificationId: state.servicesRequestSuccessResponse
                                    .entity?.nTFID ??
                                ''));
                  }
                } else {
                  Dialogs.showInfoDialog(
                      context,
                      PopupType.fail,
                      state.servicesRequestSuccessResponse.entity?.sTATUS ??
                          '');
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
                  BackAppBarWidget(title: context.string.warnings),
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
                          DropDownWidget<DepartmentEntity>(
                            list: _departments,
                            height: resources.dimen.dp27,
                            labelText: context.string.department,
                            errorMessage: context.string.department,
                            selectedValue: department,
                            callback: onDepartmentSelected,
                          ),
                          SizedBox(
                            height: resources.dimen.dp20,
                          ),
                          ValueListenableBuilder(
                              valueListenable: _employees,
                              builder: (context, employees, widget) {
                                return DropDownWidget<EmployeeEntity>(
                                  list: employees,
                                  height: resources.dimen.dp27,
                                  labelText: context.string.employee,
                                  errorMessage: context.string.employee,
                                  selectedValue: employee,
                                  callback: onEmployeeSelected,
                                );
                              }),
                          SizedBox(
                            height: resources.dimen.dp20,
                          ),
                          DropDownWidget<NameIdEntity>(
                            list: _reasons,
                            height: resources.dimen.dp27,
                            labelText: context.string.reason,
                            errorMessage: context.string.reason,
                            selectedValue: reason,
                            callback: onReasonSelected,
                          ),
                          SizedBox(
                            height: resources.dimen.dp20,
                          ),
                          RightIconTextWidget(
                            isEnabled: true,
                            height: resources.dimen.dp27,
                            labelText: context.string.note,
                            maxLines: 5,
                            textController: _noteController,
                          ),
                          SizedBox(
                            height: resources.dimen.dp20,
                          ),
                        ],
                      ),
                    ),
                  )),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  SubmitCancelWidget(callBack: onSubmit),
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
