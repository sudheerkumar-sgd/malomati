// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/text_input_widget.dart';

import '../../../../core/constants/data_constants.dart';
import '../../../../data/model/department_model.dart';
import '../../../../domain/entities/department_entity.dart';
import '../../../../domain/entities/employee_entity.dart';
import '../../../../injection_container.dart';
import '../../../../res/drawables/background_box_decoration.dart';
import '../../../../res/drawables/drawable_assets.dart';
import '../../../bloc/services/services_bloc.dart';
import '../../utils/dialogs.dart';
import '../../widgets/dropdown_widget.dart';

class DialogRequestAnswerMoreInfo extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final String questionText;
  DialogRequestAnswerMoreInfo(
      {this.questionText = '', this.workFlowUserList, super.key});
  final _formKey = GlobalKey<FormState>();
  final List<EmployeeEntity>? workFlowUserList;
  final ValueNotifier<int> _selectedEmployeeType = ValueNotifier(0);
  final ValueNotifier<List<EmployeeEntity>> _allEmployeesList =
      ValueNotifier([]);
  List<DepartmentEntity> _departments = [];
  String selectedEmpUserName = '';
  EmployeeEntity? selectedEmployee;
  DepartmentEntity? department;
  final _servicesBloc = sl<ServicesBloc>();

  onDepartmentSelected(DepartmentEntity? value) {
    selectedEmployee = null;
    department = value;
    _servicesBloc.getEmployeesByDepartment(
        requestParams: {'DEPARTMENT_NUMBER': value?.pAYROLLID ?? ''});
  }

  onEmployeeSelected(EmployeeEntity? employeeEntity) {
    selectedEmployee = employeeEntity;
    selectedEmpUserName = selectedEmployee?.uSERNAME ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    _departments = departments
        .map((departmentJson) =>
            DepartmentModel.fromJson(departmentJson).toDepartmentEntity())
        .toList();
    return BlocProvider(
      create: (context) => _servicesBloc,
      child: BlocListener<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is OnServicesLoading) {
            Dialogs.loader(context);
          } else if (state is OnEmployeesSuccess) {
            Navigator.of(context, rootNavigator: true).pop();
            _allEmployeesList.value = state.employeesList;
          }
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(resources.dimen.dp15))),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: resources.dimen.dp20,
                vertical: resources.dimen.dp15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (questionText.isEmpty) ...[
                  Center(
                    child: Text(
                      context.string.requestInformation,
                      style: context.textFontWeight600
                          .onFontSize(resources.fontSize.dp17),
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  if (workFlowUserList?.isNotEmpty == true) ...[
                    Text(
                      context.string.informationRequestedFrom,
                      style: context.textFontWeight600
                          .onFontSize(resources.fontSize.dp12),
                    ),
                    SizedBox(
                      height: resources.dimen.dp20,
                    ),
                    ValueListenableBuilder(
                        valueListenable: _selectedEmployeeType,
                        builder: (context, type, child) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  selectedEmployee = null;
                                  department = null;
                                  _selectedEmployeeType.value = 0;
                                },
                                child: Row(
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
                                            value: 0,
                                            groupValue: type,
                                            onChanged: (int? value) {
                                              _selectedEmployeeType.value =
                                                  value ?? 0;
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      width: resources.dimen.dp10,
                                    ),
                                    Text(
                                      context.string.workflowParticipant,
                                      style: context.textFontWeight600
                                          .onColor(
                                              context.resources.color.textColor)
                                          .onFontSize(
                                              context.resources.fontSize.dp10)
                                          .copyWith(height: 1),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: resources.dimen.dp7,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: isLocalEn ? 15.0 : 0.0,
                                    right: isLocalEn ? 0.0 : 15.0),
                                child: DropDownWidget<EmployeeEntity>(
                                  isEnabled: type == 0,
                                  list: workFlowUserList ?? [],
                                  height: resources.dimen.dp27,
                                  hintText: context.string.selectEmployee,
                                  suffixIconPath: DrawableAssets.icChevronDown,
                                  fillColor:
                                      context.resources.color.colorLightBg,
                                  callback: onEmployeeSelected,
                                ),
                              ),
                              SizedBox(
                                height: resources.dimen.dp20,
                              ),
                              InkWell(
                                onTap: () {
                                  selectedEmployee = null;
                                  department = null;
                                  _selectedEmployeeType.value = 1;
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: resources.dimen.dp1,
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
                                            value: 1,
                                            groupValue: type,
                                            onChanged: (int? value) {
                                              _selectedEmployeeType.value =
                                                  value ?? 0;
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      width: resources.dimen.dp10,
                                    ),
                                    Text(
                                      context.string.anyUser,
                                      style: context.textFontWeight600
                                          .onColor(
                                              context.resources.color.textColor)
                                          .onFontSize(
                                              context.resources.fontSize.dp10)
                                          .copyWith(height: 1),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: resources.dimen.dp5,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: isLocalEn ? 15.0 : 0.0,
                                    right: isLocalEn ? 0.0 : 15.0),
                                child: DropDownWidget<DepartmentEntity>(
                                  isEnabled: type == 1,
                                  list: _departments,
                                  height: resources.dimen.dp27,
                                  hintText: context.string.department,
                                  suffixIconPath: DrawableAssets.icChevronDown,
                                  fillColor:
                                      context.resources.color.colorLightBg,
                                  selectedValue: department,
                                  callback: onDepartmentSelected,
                                ),
                              ),
                              SizedBox(
                                height: resources.dimen.dp5,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: _allEmployeesList,
                                  builder: (context, employeesList, child) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: isLocalEn ? 15.0 : 0.0,
                                          right: isLocalEn ? 0.0 : 15.0),
                                      child: DropDownWidget<EmployeeEntity>(
                                        isEnabled: type == 1,
                                        list: employeesList,
                                        height: resources.dimen.dp27,
                                        hintText: context.string.selectEmployee,
                                        suffixIconPath:
                                            DrawableAssets.icChevronDown,
                                        fillColor: context
                                            .resources.color.colorLightBg,
                                        callback: onEmployeeSelected,
                                      ),
                                    );
                                  }),
                              SizedBox(
                                height: resources.dimen.dp20,
                              ),
                            ],
                          );
                        }),
                  ]
                ],
                if (questionText.isNotEmpty) ...[
                  Text(
                    '${context.string.question}: $questionText',
                    style: context.textFontWeight400
                        .onFontSize(context.resources.fontSize.dp12),
                  ),
                  SizedBox(
                    height: context.resources.dimen.dp8,
                  ),
                ],
                Text(
                  questionText.isNotEmpty
                      ? context.string.answer
                      : context.string.informationRequested,
                  style: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp12),
                ),
                SizedBox(
                  height: resources.dimen.dp5,
                ),
                Form(
                  key: _formKey,
                  child: TextInputWidget(
                          maxLines: 3,
                          textController: controller,
                          textStyle: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp12),
                          fillColor: resources.color.colorLightBg,
                          boarderRadius: resources.dimen.dp8,
                          errorMessage: context.string.question)
                      .textInputFiled,
                ),
                SizedBox(
                  height: context.resources.dimen.dp15,
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: context.resources.dimen.dp80,
                          padding: EdgeInsets.symmetric(
                              horizontal: context.resources.dimen.dp10,
                              vertical: context.resources.dimen.dp5),
                          decoration: BackgroundBoxDecoration(
                                  boxColor:
                                      context.resources.color.textColorLight,
                                  radious: context.resources.dimen.dp15)
                              .roundedCornerBox,
                          child: Text(
                            context.string.cancel,
                            style: context.textFontWeight400
                                .onFontSize(context.resources.fontSize.dp12)
                                .onColor(context.resources.color.colorWhite)
                                .copyWith(height: 1),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: context.resources.dimen.dp10,
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(
                              context,
                              {
                                'user_name': selectedEmpUserName,
                                'question': controller.text
                              },
                            );
                          }
                        },
                        child: Container(
                          width: context.resources.dimen.dp80,
                          padding: EdgeInsets.symmetric(
                              horizontal: context.resources.dimen.dp10,
                              vertical: context.resources.dimen.dp5),
                          decoration: BackgroundBoxDecoration(
                                  boxColor:
                                      context.resources.color.viewBgColorLight,
                                  radious: context.resources.dimen.dp15)
                              .roundedCornerBox,
                          child: Text(
                            context.string.submit,
                            style: context.textFontWeight400
                                .onFontSize(context.resources.fontSize.dp12)
                                .onColor(context.resources.color.colorWhite)
                                .copyWith(height: 1),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
