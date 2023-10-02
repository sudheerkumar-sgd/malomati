// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/data/model/leave_request_model.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/item_attachment.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';
import 'package:file_picker/file_picker.dart';

import '../../utils/date_time_util.dart';
import '../../widgets/alert_dialog_widget.dart';
import '../../widgets/animated_toggle.dart';
import 'dialog_upload_attachment.dart';

enum LeaveType {
  anualLeave('Annual Leaves', '61'),
  permission('Permission', '75'),
  sickLeave('Sick Leaves', '76'),
  missionLeave('Mission Leaves', '68'),
  otherLeave('Other Leaves', '0'),
  createLeave('Create Leaves', '2');

  final String name;
  final String id;
  const LeaveType(this.name, this.id);
}

enum LeaveSubType {
  planned('PLANNED'),
  confirmed('CONFIRMED');

  final String name;
  const LeaveSubType(this.name);
}

class LeavesForm extends StatelessWidget {
  static const String route = '/Leavesform';
  final LeaveType leaveType;
  LeavesForm({required this.leaveType, super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<List<LeaveTypeEntity>> _leaveTypeList = ValueNotifier([]);
  final ValueNotifier<List<EmployeeEntity>> _employeesList = ValueNotifier([]);
  LeaveTypeEntity? selectedLeaveType;
  EmployeeEntity? selectedEmployee;
  LeaveSubType leaveSubType = LeaveSubType.planned;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final dateFormat = 'dd-MMM-yyyy';
  final timeFormat = 'hh:mm a';
  final ValueNotifier<bool> _isUploadChanged = ValueNotifier(false);
  final ValueNotifier<bool> _isleaveTypeChanged = ValueNotifier(false);
  final _uploadFiles = [];
  String currentBalanceText = '';
  String userName = '';
  String selectedEmpUserName = '';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller,
      {DateTime? startTime}) async {
    selectTime(context, startTime: startTime, callBack: (dateTime) {
      controller.text = getDateByformat(timeFormat, dateTime);
    });
  }

  Future<void> _showSelectFileOptions(BuildContext context) async {
    Dialogs.showBottomSheetDialogTransperrent(
        context, const DialogUploadAttachmentWidget(), callback: (value) {
      if (value != null) {
        _uploadFiles.add(value);
        _isUploadChanged.value = !_isUploadChanged.value;
      }
    });
  }

  Future<void> _selectFile(BuildContext context) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      final fileName = result.files.single.name;
      if (fileName.isNotEmpty) {
        File file = File(result.files.single.path ?? '');
        printLog(message: '${file.lengthSync()}');
        if (file.lengthSync() <= maxUploadFilesize) {
          final bytes = file.readAsBytesSync();
          final data = {
            'fileName': fileName,
            'fileNamebase64data': base64Encode(bytes),
          };
          _uploadFiles.add(data);
          _isUploadChanged.value = !_isUploadChanged.value;
        } else if (context.mounted) {
          Dialogs.showInfoDialog(context, PopupType.fail,
              "Upload file should not be more then 1mb");
        }
      }
    } else {
      printLog(message: 'message');
    }
  }

  _onDeleteUpload(int id) {
    _uploadFiles.removeAt(id);
    _isUploadChanged.value = !_isUploadChanged.value;
  }

  onLeaveTypeSelected(LeaveTypeEntity? leaveTypeEntity) {
    selectedLeaveType = leaveTypeEntity;
    _isleaveTypeChanged.value = !_isleaveTypeChanged.value;
  }

  onEmployeeSelected(EmployeeEntity? employeeEntity) {
    selectedEmployee = employeeEntity;
    selectedEmpUserName = selectedEmployee?.uSERNAME ?? '';
  }

  _submitLeaveRequest(BuildContext context) {
    final leaveRequestModel = LeaveRequestModel();
    leaveRequestModel.lEAVETYPE = leaveSubType.name;
    leaveRequestModel.uSERNAME = selectedEmpUserName;
    leaveRequestModel.cREATORUSERNAME = '';
    if (leaveType == LeaveType.otherLeave ||
        leaveType == LeaveType.createLeave) {
      leaveRequestModel.aBSENCETYPEID = '${selectedLeaveType?.id}';
    } else {
      leaveRequestModel.aBSENCETYPEID = leaveType.id;
    }
    leaveRequestModel.sTARTDATE = _startDateController.text;
    leaveRequestModel.eNDDATE = _endDateController.text;
    if (leaveType == LeaveType.permission) {
      leaveRequestModel.sTARTTIME = getDateByformat(
          'hh:mm',
          getDateTimeByString('$dateFormat $timeFormat',
              '${_startDateController.text} ${_startTimeController.text}'));
      leaveRequestModel.eNDTIME = getDateByformat(
          'hh:mm',
          getDateTimeByString('$dateFormat $timeFormat',
              '${_startDateController.text} ${_endTimeController.text}'));
    }
    for (int i = 0; i < _uploadFiles.length; i++) {
      switch (i) {
        case 0:
          {
            leaveRequestModel.fILENAME = _uploadFiles[i]['fileName'];
            leaveRequestModel.bLOBFILE = _uploadFiles[i]['fileNamebase64data'];
          }
        case 1:
          {
            leaveRequestModel.fILENAMENEW = _uploadFiles[i]['fileName'];
            leaveRequestModel.bLOBFILENEW =
                _uploadFiles[i]['fileNamebase64data'];
          }
        case 2:
          {
            leaveRequestModel.fILENAMENEW_ = _uploadFiles[i]['fileName'];
            leaveRequestModel.bLOBFILENEW_ =
                _uploadFiles[i]['fileNamebase64data'];
          }
      }
    }
    leaveRequestModel.uSERCOMMENTS = _commentController.text;
    _servicesBloc.submitLeaveRequest(requestParams: leaveRequestModel.toJson());
  }

  @override
  Widget build(BuildContext context) {
    userName = context.userDB.get(userNameKey, defaultValue: '');
    if (leaveType == LeaveType.otherLeave ||
        leaveType == LeaveType.createLeave) {
      _servicesBloc.getLeaveTypes(requestParams: {});
    }
    if (leaveType == LeaveType.createLeave) {
      _servicesBloc
          .getEmployeesByManager(requestParams: {'USER_NAME': userName});
    }
    resources = context.resources;
    _startDateController.addListener(
      () {
        _endDateController.text = '';
      },
    );
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
              } else if (state is OnLeaveTypesSuccess) {
                _leaveTypeList.value = state.leaveTypeEntity;
              } else if (state is OnEmployeesSuccess) {
                _employeesList.value = state.employeesList;
              } else if (state is OnLeaveSubmittedSuccess) {
                if (isLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                  isLoading = false;
                }
                if (state.leaveSubmitResponse.isSuccess ?? false) {
                  Dialogs.showInfoDialog(
                          context,
                          PopupType.success,
                          state.leaveSubmitResponse
                              .getDisplayMessage(resources))
                      .then((value) => Navigator.pop(context));
                } else {
                  Dialogs.showInfoDialog(context, PopupType.fail,
                      state.leaveSubmitResponse.getDisplayMessage(resources));
                }
              } else if (state is OnServicesError) {
                if (isLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                  isLoading = false;
                }
                Dialogs.showInfoDialog(context, PopupType.fail, state.message);
              }
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.string.type,
                      style: context.textFontWeight400
                          .onFontSize(context.resources.fontSize.dp12)
                          .copyWith(height: 1),
                    ),
                    SizedBox(
                      width: 190,
                      child: AnimatedToggle(
                        width: 190,
                        height: 28,
                        values: [
                          context.string.planned,
                          context.string.confirmed
                        ],
                        selectedPossition: 0,
                        onToggleCallback: (value) {
                          if (value == 0) {
                            leaveSubType = LeaveSubType.planned;
                          } else {
                            leaveSubType = LeaveSubType.confirmed;
                          }
                          printLog(message: leaveSubType.name);
                        },
                        buttonColor: resources.color.viewBgColor,
                        backgroundColor:
                            resources.color.bottomSheetIconUnSelected,
                        boxRadious: resources.dimen.dp5,
                        textColor: const Color(0xFFFFFFFF),
                        textFontSize: resources.fontSize.dp13,
                      ),
                    ),
                  ],
                ),
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
                          Visibility(
                            visible: leaveType == LeaveType.createLeave,
                            child: ValueListenableBuilder(
                                valueListenable: _employeesList,
                                builder: (context, employeesList, widget) {
                                  return DropDownWidget<EmployeeEntity>(
                                    list: employeesList,
                                    height: resources.dimen.dp27,
                                    labelText: context.string.employee,
                                    hintText: context.string.chooseAbsenceType,
                                    suffixIconPath:
                                        DrawableAssets.icChevronDown,
                                    selectedValue: selectedEmployee,
                                    callback: onEmployeeSelected,
                                  );
                                }),
                          ),
                          Visibility(
                            visible: leaveType == LeaveType.createLeave,
                            child: SizedBox(
                              height: resources.dimen.dp20,
                            ),
                          ),
                          Visibility(
                            visible: leaveType == LeaveType.otherLeave ||
                                leaveType == LeaveType.createLeave,
                            child: ValueListenableBuilder(
                                valueListenable: _leaveTypeList,
                                builder: (context, leaveTypeList, widget) {
                                  return DropDownWidget<LeaveTypeEntity>(
                                    list: leaveTypeList,
                                    height: resources.dimen.dp27,
                                    labelText: context.string.absenceType,
                                    hintText: context.string.chooseAbsenceType,
                                    suffixIconPath:
                                        DrawableAssets.icChevronDown,
                                    selectedValue: selectedLeaveType,
                                    callback: onLeaveTypeSelected,
                                  );
                                }),
                          ),
                          Visibility(
                            visible: leaveType == LeaveType.otherLeave ||
                                leaveType == LeaveType.createLeave,
                            child: SizedBox(
                              height: resources.dimen.dp20,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _selectDate(context, _startDateController,
                                  initialDate: _startDateController
                                          .text.isNotEmpty
                                      ? getDateTimeByString(
                                          dateFormat, _startDateController.text)
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
                          ValueListenableBuilder(
                              valueListenable: _isleaveTypeChanged,
                              builder: (contex, value, widget) {
                                return Visibility(
                                  visible:
                                      leaveType.id == LeaveType.permission.id ||
                                          '${selectedLeaveType?.id ?? ''}' ==
                                              LeaveType.permission.id,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: resources.dimen.dp20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                _selectTime(context,
                                                    _startTimeController);
                                              },
                                              child: RightIconTextWidget(
                                                height: resources.dimen.dp27,
                                                labelText:
                                                    context.string.startTime,
                                                hintText: context
                                                    .string.chooseStartTime,
                                                errorMessage: context
                                                    .string.chooseStartTime,
                                                fontFamily: fontFamilyEN,
                                                suffixIconPath:
                                                    DrawableAssets.icTime,
                                                textController:
                                                    _startTimeController,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: resources.dimen.dp20,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                _selectTime(
                                                    context, _endTimeController,
                                                    startTime: getDateTimeByString(
                                                        '$dateFormat $timeFormat',
                                                        _endTimeController
                                                                .text.isEmpty
                                                            ? '${_startDateController.text} ${_startTimeController.text}'
                                                            : '${_endDateController.text} ${_endTimeController.text}'));
                                              },
                                              child: RightIconTextWidget(
                                                height: resources.dimen.dp27,
                                                labelText:
                                                    context.string.endTime,
                                                hintText: context
                                                    .string.chooseEndTime,
                                                errorMessage: context
                                                    .string.chooseEndTime,
                                                fontFamily: fontFamilyEN,
                                                suffixIconPath:
                                                    DrawableAssets.icTime,
                                                textController:
                                                    _endTimeController,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          SizedBox(
                            height: resources.dimen.dp20,
                          ),
                          Text(
                            context.string.upload,
                            style: context.textFontWeight400
                                .onFontSize(context.resources.fontSize.dp12),
                          ),
                          SizedBox(
                            height: context.resources.dimen.dp10,
                          ),
                          Row(
                            children: [
                              ValueListenableBuilder(
                                  valueListenable: _isUploadChanged,
                                  builder: (context, isChanged, widget) {
                                    return Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: context.resources.dimen.dp10,
                                            top: context.resources.dimen.dp5,
                                            right: context.resources.dimen.dp15,
                                            bottom:
                                                context.resources.dimen.dp5),
                                        decoration: BackgroundBoxDecoration(
                                                boxColor: context
                                                    .resources.color.colorWhite,
                                                radious: context
                                                    .resources.dimen.dp10)
                                            .roundedCornerBox,
                                        child: _uploadFiles.isNotEmpty
                                            ? Wrap(
                                                runSpacing:
                                                    resources.dimen.dp10,
                                                children: List.generate(
                                                    _uploadFiles.length,
                                                    (index) => ItemAttachment(
                                                          id: index,
                                                          name: _uploadFiles[
                                                                  index]
                                                              ['fileName'],
                                                          callBack:
                                                              _onDeleteUpload,
                                                        )),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  _showSelectFileOptions(
                                                      context);
                                                },
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: context
                                                          .resources.dimen.dp5,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        context.string.upload,
                                                        style: context
                                                            .textFontWeight400
                                                            .onFontSize(context
                                                                .resources
                                                                .fontSize
                                                                .dp12)
                                                            .onColor(context
                                                                .resources
                                                                .color
                                                                .colorD6D6D6)
                                                            .onFontFamily(
                                                                fontFamily: isLocalEn
                                                                    ? fontFamilyEN
                                                                    : fontFamilyAR)
                                                            .copyWith(
                                                                height: 1),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: context
                                                          .resources.dimen.dp10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  resources
                                                                      .dimen
                                                                      .dp8),
                                                      child: ImageWidget(
                                                              // width: 13,
                                                              // height: 13,
                                                              path:
                                                                  DrawableAssets
                                                                      .icUpload,
                                                              backgroundTint:
                                                                  resources
                                                                      .color
                                                                      .viewBgColor)
                                                          .loadImage,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ),
                                    );
                                  }),
                              InkWell(
                                onTap: () {
                                  _showSelectFileOptions(context);
                                },
                                child: Container(
                                  padding: isLocalEn
                                      ? EdgeInsets.only(
                                          left: resources.dimen.dp10,
                                        )
                                      : EdgeInsets.only(
                                          right: resources.dimen.dp10,
                                        ),
                                  child: ImageWidget(
                                          path: DrawableAssets.icPlusCircle,
                                          backgroundTint:
                                              resources.color.viewBgColor)
                                      .loadImage,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: resources.dimen.dp20,
                          ),
                          RightIconTextWidget(
                            height: resources.dimen.dp100,
                            isEnabled: true,
                            maxLines: 8,
                            labelText: context.string.comments,
                            textController: _commentController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: resources.dimen.dp20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.resources.dimen.dp15,
                              vertical: resources.dimen.dp7),
                          decoration: BackgroundBoxDecoration(
                                  boxColor:
                                      context.resources.color.textColorLight,
                                  radious: context.resources.dimen.dp15)
                              .roundedCornerBox,
                          child: Text(
                            context.string.cancel,
                            style: context.textFontWeight600
                                .onFontSize(context.resources.fontSize.dp17)
                                .onColor(resources.color.colorWhite)
                                .copyWith(height: 1),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: resources.dimen.dp20,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _submitLeaveRequest(context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.resources.dimen.dp15,
                              vertical: resources.dimen.dp7),
                          decoration: BackgroundBoxDecoration(
                                  boxColor: context.resources.color.viewBgColor,
                                  radious: context.resources.dimen.dp15)
                              .roundedCornerBox,
                          child: Text(
                            context.string.submit,
                            style: context.textFontWeight600
                                .onFontSize(context.resources.fontSize.dp17)
                                .onColor(resources.color.colorWhite)
                                .copyWith(height: 1),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: resources.dimen.dp10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
