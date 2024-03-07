// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/data/model/leave_request_model.dart';
import 'package:malomati/domain/entities/delegation_user_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_search_widget.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';

import '../../../domain/entities/name_id_entity.dart';
import '../utils/date_time_util.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class VacationRulesScreen extends StatelessWidget {
  static const String route = '/VacationRulesScreen';
  VacationRulesScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<List<DelegationUserEntity>> _delegationUsers =
      ValueNotifier([]);
  final ValueNotifier<List<NameIdEntity>> _delegationTypes = ValueNotifier([]);
  final ValueNotifier<List<NameIdEntity>> _delegationCategories =
      ValueNotifier([]);
  DelegationUserEntity? selectedEmployee;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final dateFormat = 'yyyy-MM-dd';
  final timeFormat = 'hh:mm a';
  String userName = '';
  String selectedEmpUserName = '';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final ValueNotifier<int> _ruleAccess = ValueNotifier(0);
  final ValueNotifier<int> _subRuleType = ValueNotifier(0);
  final ValueNotifier<NameIdEntity?> selectedVNType = ValueNotifier(null);
  String selectedVNSubType = '';

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

  onVNTypeSelected(NameIdEntity? vnType) {
    selectedVNType.value = vnType;
  }

  onVNSubTypeSelected(NameIdEntity? vnType) {
    selectedVNSubType = '';
  }

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitVacationRequest();
    }
  }

  _submitVacationRequest() {
    final vrRequestModel = {
      'ruleId': '104024',
      'userName': userName,
      'action': 'FORWARD',
      'beginDate': _startDateController.text,
      'endDate': _endDateController.text,
      'messageType': '',
      'messageName': '',
      'delagatedUser': 'TAREK.MAGDY',
      'ruleComment': _commentController.text,
      'securityGroupId': ''
    };
    _servicesBloc.submitServicesRequest(
        apiUrl: delegationRequestApiUrl, requestParams: vrRequestModel);
  }

  @override
  Widget build(BuildContext context) {
    userName = context.userDB.get(userNameKey, defaultValue: '');
    resources = context.resources;
    _startDateController.addListener(
      () {
        _endDateController.text = '';
      },
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      _servicesBloc.getDelegationTypes(requestParams: {
        'USER_NAME': userName,
        'USER_ID': context.userDB.get(userPersonIdKey, defaultValue: ''),
      }, showLoading: false);
      _servicesBloc.getDelegationUsers(requestParams: {}, showLoading: false);
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                Dialogs.loader(context);
                isLoading = true;
              } else if (state is OnDelegationUsers) {
                _delegationUsers.value = state.delegationUsers;
              } else if (state is OnDelegationTypes) {
                _delegationTypes.value = state.delegationTypes;
              } else if (state is OnServicesRequestSubmitSuccess) {
                if (isLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                  isLoading = false;
                }
                if (state.servicesRequestSuccessResponse.isSuccess ?? false) {
                  Dialogs.showInfoDialog(
                          context,
                          PopupType.success,
                          state.servicesRequestSuccessResponse
                              .getDisplayMessage(resources))
                      .then((value) => Navigator.pop(context));
                } else {
                  Dialogs.showInfoDialog(
                      context,
                      PopupType.fail,
                      state.servicesRequestSuccessResponse
                          .getDisplayMessage(resources));
                }
              } else if (state is OnServicesError) {
                if (isLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                  isLoading = false;
                }
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
                  BackAppBarWidget(title: context.string.vacationRules),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: _delegationTypes,
                                builder: (context, types, child) {
                                  return DropDownWidget<NameIdEntity>(
                                    list: types,
                                    height: resources.dimen.dp27,
                                    labelText:
                                        context.string.vactionTypeSelectTitle,
                                    hintText:
                                        context.string.vactionTypeSelectTitle,
                                    suffixIconPath:
                                        DrawableAssets.icChevronDown,
                                    callback: onVNTypeSelected,
                                  );
                                }),
                            ValueListenableBuilder(
                                valueListenable: selectedVNType,
                                builder: (context, vnType, child) {
                                  return (vnType?.id ?? 'ALL') != 'ALL'
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: resources.dimen.dp20,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _subRuleType.value = 0;
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: resources.dimen.dp5,
                                                  ),
                                                  ValueListenableBuilder(
                                                      valueListenable:
                                                          _subRuleType,
                                                      builder: (context,
                                                          subRule, child) {
                                                        return Transform.scale(
                                                          scale: 0.7,
                                                          child: SizedBox(
                                                            width: 6,
                                                            height: 6,
                                                            child: Radio<int>(
                                                                materialTapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                                value: 0,
                                                                groupValue:
                                                                    subRule,
                                                                onChanged: (int?
                                                                    value) {
                                                                  _subRuleType
                                                                          .value =
                                                                      value ??
                                                                          0;
                                                                }),
                                                          ),
                                                        );
                                                      }),
                                                  SizedBox(
                                                    width: resources.dimen.dp7,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'All',
                                                      style: context
                                                          .textFontWeight600
                                                          .onColor(context
                                                              .resources
                                                              .color
                                                              .textColor)
                                                          .onFontSize(context
                                                              .resources
                                                              .fontSize
                                                              .dp10)
                                                          .copyWith(height: 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: resources.dimen.dp10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _subRuleType.value = 1;
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: resources.dimen.dp5,
                                                  ),
                                                  ValueListenableBuilder(
                                                      valueListenable:
                                                          _subRuleType,
                                                      builder: (context,
                                                          subRule, child) {
                                                        return Transform.scale(
                                                          scale: 0.7,
                                                          child: SizedBox(
                                                            width: 6,
                                                            height: 6,
                                                            child: Radio<int>(
                                                                materialTapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                                value: 1,
                                                                groupValue:
                                                                    subRule,
                                                                onChanged: (int?
                                                                    value) {
                                                                  _subRuleType
                                                                          .value =
                                                                      value ??
                                                                          0;
                                                                }),
                                                          ),
                                                        );
                                                      }),
                                                  SizedBox(
                                                    width: resources.dimen.dp7,
                                                  ),
                                                  Text(
                                                    'Select by',
                                                    style: context
                                                        .textFontWeight600
                                                        .onColor(context
                                                            .resources
                                                            .color
                                                            .textColor)
                                                        .onFontSize(context
                                                            .resources
                                                            .fontSize
                                                            .dp10)
                                                        .copyWith(height: 1),
                                                  ),
                                                  SizedBox(
                                                    width: resources.dimen.dp7,
                                                  ),
                                                  Expanded(
                                                    child: DropDownWidget<
                                                        NameIdEntity>(
                                                      list:
                                                          _delegationCategories
                                                              .value,
                                                      height:
                                                          resources.dimen.dp27,
                                                      callback:
                                                          onVNSubTypeSelected,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox();
                                }),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            InkWell(
                              onTap: () {
                                _selectDate(context, _startDateController,
                                    initialDate:
                                        _startDateController.text.isNotEmpty
                                            ? getDateTimeByString(dateFormat,
                                                _startDateController.text)
                                            : DateTime.now());
                              },
                              child: RightIconTextWidget(
                                height: resources.dimen.dp27,
                                labelText: context.string.startDate,
                                hintText: context.string.chooseStartDate,
                                errorMessage: context.string.chooseStartDate,
                                fontFamily: fontFamilyEN,
                                suffixIconPath: DrawableAssets.icCalendar,
                                textController: _startDateController,
                              ),
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            InkWell(
                              onTap: () {
                                _selectDate(context, _endDateController,
                                    firstDate: getDateTimeByString(
                                        dateFormat, _startDateController.text));
                              },
                              child: RightIconTextWidget(
                                height: resources.dimen.dp27,
                                labelText: context.string.endDate,
                                hintText: context.string.chooseEndDate,
                                errorMessage: context.string.chooseEndDate,
                                fontFamily: fontFamilyEN,
                                suffixIconPath: DrawableAssets.icCalendar,
                                textController: _endDateController,
                              ),
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              height: resources.dimen.dp100,
                              isEnabled: true,
                              maxLines: 8,
                              labelText: context.string.message,
                              textController: _commentController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            ValueListenableBuilder(
                                valueListenable: _delegationUsers,
                                builder: (context, employeesList, widget) {
                                  return DropDownSearchWidget<
                                      DelegationUserEntity>(
                                    list: employeesList,
                                    labelText:
                                        context.string.reassignEmployeeName,
                                    hintText: 'Select employee',
                                    callback: (employee) {
                                      selectedEmployee = employee;
                                    },
                                  );
                                }),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            ValueListenableBuilder(
                                valueListenable: _ruleAccess,
                                builder: (context, ruleAccess, widget) {
                                  return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _ruleAccess.value = 0;
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: resources.dimen.dp5,
                                                ),
                                                Transform.scale(
                                                  scale: 0.7,
                                                  child: SizedBox(
                                                    width: 6,
                                                    height: 6,
                                                    child: Radio<int>(
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        value: 0,
                                                        groupValue: ruleAccess,
                                                        onChanged:
                                                            (int? value) {
                                                          _ruleAccess.value =
                                                              value ?? 0;
                                                        }),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: resources.dimen.dp7,
                                                ),
                                                Expanded(
                                                  child: RichText(
                                                      text: TextSpan(
                                                    text:
                                                        '${context.string.delegateYourResponse}\n',
                                                    style: context
                                                        .textFontWeight600
                                                        .onColor(context
                                                            .resources
                                                            .color
                                                            .textColor)
                                                        .onFontSize(context
                                                            .resources
                                                            .fontSize
                                                            .dp10)
                                                        .copyWith(height: 1),
                                                    children: [
                                                      TextSpan(
                                                        text: context.string
                                                            .delegateYourResponseDes,
                                                        style: context
                                                            .textFontWeight600
                                                            .onColor(context
                                                                .resources
                                                                .color
                                                                .textColor)
                                                            .onFontSize(context
                                                                .resources
                                                                .fontSize
                                                                .dp10),
                                                      )
                                                    ],
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: resources.dimen.dp20,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _ruleAccess.value = 1;
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Transform.scale(
                                                  scale: 0.7,
                                                  child: SizedBox(
                                                    width: 6,
                                                    height: 6,
                                                    child: Radio<int>(
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        value: 1,
                                                        groupValue: ruleAccess,
                                                        onChanged:
                                                            (int? value) {
                                                          _ruleAccess.value =
                                                              value ?? 0;
                                                        }),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: resources.dimen.dp7,
                                                ),
                                                Expanded(
                                                  child: RichText(
                                                      text: TextSpan(
                                                    text:
                                                        '${context.string.transferNotificationOwnership}\n',
                                                    style: context
                                                        .textFontWeight600
                                                        .onColor(context
                                                            .resources
                                                            .color
                                                            .textColor)
                                                        .onFontSize(context
                                                            .resources
                                                            .fontSize
                                                            .dp10)
                                                        .copyWith(height: 1),
                                                    children: [
                                                      TextSpan(
                                                        text: context.string
                                                            .transferNotificationOwnershipDes,
                                                        style: context
                                                            .textFontWeight600
                                                            .onColor(context
                                                                .resources
                                                                .color
                                                                .textColor)
                                                            .onFontSize(context
                                                                .resources
                                                                .fontSize
                                                                .dp10),
                                                      )
                                                    ],
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]);
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  SubmitCancelWidget(callBack: onSubmit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
