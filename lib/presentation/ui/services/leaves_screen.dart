// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/data/model/leave_request_model.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/home/home_screen.dart';
import 'package:malomati/presentation/ui/services/widgets/dialog_upload_attachment.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/item_attachment.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/animated_toggle.dart';
import '../widgets/back_app_bar.dart';

enum LeaveType {
  anualLeave('Annual Leaves', '61'),
  permission('Permission', '75'),
  sickLeave('Sick Leaves', '76'),
  missionLeave('Mission Leaves', '68'),
  otherLeave('Other Leaves', '0');

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

class LeavesScreen extends StatelessWidget {
  static const String route = '/LeavesScreen';
  final LeaveType leaveType;
  LeavesScreen({required this.leaveType, super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<List<LeaveTypeEntity>> _leaveTypeList = ValueNotifier([]);
  LeaveTypeEntity? selectedLeaveType;
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
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<String> _durationText = ValueNotifier('0');

  String _getTitleByLeaveType(BuildContext context) {
    switch (leaveType) {
      case LeaveType.anualLeave:
        {
          currentBalanceText = HomeScreen.anualLeaveBalance;
          return context.string.anualLeaves;
        }
      case LeaveType.permission:
        {
          currentBalanceText = HomeScreen.permissionBalance;
          return context.string.permission;
        }
      case LeaveType.sickLeave:
        {
          currentBalanceText = HomeScreen.sickLeaveBalance;
          return context.string.sickLeaves;
        }
      case LeaveType.missionLeave:
        {
          return context.string.missionLeaves;
        }
      default:
        {
          return context.string.otherLeaves;
        }
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller,
      {DateTime? firstDate, DateTime? lastDate}) async {
    final currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDate ?? currentDate,
      firstDate: firstDate ?? DateTime(currentDate.year - 1, currentDate.month),
      lastDate: lastDate ?? DateTime(2024),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: context.resources.color.viewBgColor, // header text color
            onSurface: context.resources.color.viewBgColor, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
                  context.resources.color.viewBgColor, // button text color
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.text = getDateByformat(dateFormat, picked);
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller,
      {TimeOfDay? startTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.resources.color.viewBgColor,
              onSurface: context.resources.color.viewBgColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    context.resources.color.viewBgColor, // button text color
              ),
            ),
          ),
          child: child!,
        ),
      ),
    );
    if (picked != null) {
      controller.text =
          '${picked.hourOfPeriod > 9 ? picked.hourOfPeriod : '0${picked.hourOfPeriod}'}:${picked.minute > 9 ? picked.minute : '0${picked.minute}'} ${picked.period.name.toUpperCase()}';
    }
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

  _onDeleteUpload(int id) {
    _uploadFiles.removeAt(id);
    _isUploadChanged.value = !_isUploadChanged.value;
  }

  onLeaveTypeSelected(LeaveTypeEntity? leaveTypeEntity) {
    selectedLeaveType = leaveTypeEntity;
    _isleaveTypeChanged.value = !_isleaveTypeChanged.value;
  }

  _submitLeaveRequest(BuildContext context) {
    final leaveRequestModel = LeaveRequestModel();
    leaveRequestModel.lEAVETYPE = leaveSubType.name;
    leaveRequestModel.uSERNAME = context.userDB.get(userNameKey);
    leaveRequestModel.cREATORUSERNAME = '';
    if (leaveType == LeaveType.otherLeave) {
      leaveRequestModel.aBSENCETYPEID = '${selectedLeaveType?.id}';
    } else {
      leaveRequestModel.aBSENCETYPEID = leaveType.id;
    }
    leaveRequestModel.sTARTDATE = _startDateController.text;
    leaveRequestModel.eNDDATE = _endDateController.text;
    if (leaveType == LeaveType.permission) {
      leaveRequestModel.sTARTTIME = _startTimeController.text;
      leaveRequestModel.eNDTIME = _endTimeController.text;
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
    if (leaveType == LeaveType.otherLeave) {
      _servicesBloc.getLeaveTypes(requestParams: {});
    }
    resources = context.resources;
    _startDateController.addListener(
      () {
        _endDateController.text = '';
      },
    );
    _endDateController.addListener(
      () {
        if (leaveType != LeaveType.permission &&
            leaveType != LeaveType.otherLeave) {
          _servicesBloc.getWorkingDays(requestParams: {
            'P_FROM_DATE': getDateByformat("yyyy-MM-dd",
                getDateTimeByString(dateFormat, _startDateController.text)),
            'P_TO_DATE': getDateByformat("yyyy-MM-dd",
                getDateTimeByString(dateFormat, _endDateController.text))
          });
        }
      },
    );
    if (leaveType == LeaveType.permission) {
      _endTimeController.addListener(
        () {
          if (_endTimeController.text.isNotEmpty) {
            final minutes = getMinutes(
                getDateTimeByString('$dateFormat $timeFormat',
                    '${_startDateController.text} ${_startTimeController.text}'),
                getDateTimeByString('$dateFormat $timeFormat',
                    '${_endDateController.text} ${_endTimeController.text}'));
            var text = '';
            if (minutes >= 30) {
              if (minutes >= 60) {
                text =
                    '${(minutes / 60).round()}:${minutes % 60} ${context.string.hours}';
              } else {
                text = '$minutes min';
              }
              _durationText.value = text;
            } else {
              _endTimeController.text = '';
              Dialogs.showInfoDialog(context, PopupType.fail,
                  'Minimum duration should be 30 mins');
            }
          }
        },
      );
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
              } else if (state is OnLeaveTypesSuccess) {
                _leaveTypeList.value = state.leaveTypeEntity;
              } else if (state is OnLeaveSubmittedSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
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
              } else if (state is OnWorkingDaysSuccess) {
                final value = state.workingDaysEntity.noOfDays ?? '';
                _durationText.value =
                    '$value ${value == '1' ? context.string.day : context.string.days}';
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
                  BackAppBarWidget(title: _getTitleByLeaveType(context)),
                  Visibility(
                    visible: leaveType == LeaveType.anualLeave ||
                        leaveType == LeaveType.sickLeave ||
                        leaveType == LeaveType.permission,
                    child: Column(
                      children: [
                        SizedBox(
                          height: context.resources.dimen.dp20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                ImageWidget(
                                        height: 25,
                                        path: DrawableAssets.icCalendar,
                                        backgroundTint:
                                            resources.color.viewBgColor)
                                    .loadImage,
                                SizedBox(
                                  width: resources.dimen.dp5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.string.remaining,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textFontWeight400
                                          .onColor(
                                              context.resources.color.textColor)
                                          .onFontSize(
                                              context.resources.fontSize.dp12),
                                    ),
                                    Text(
                                      currentBalanceText,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textFontWeight600
                                          .onColor(context
                                              .resources.color.viewBgColor)
                                          .onFontSize(
                                              context.resources.fontSize.dp12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              width: resources.dimen.dp20,
                            ),
                            Row(
                              children: [
                                ImageWidget(
                                        height: 25,
                                        path: DrawableAssets.icCalendar,
                                        backgroundTint:
                                            resources.color.viewBgColor)
                                    .loadImage,
                                SizedBox(
                                  width: resources.dimen.dp5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.string.duration,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textFontWeight400
                                          .onColor(
                                              context.resources.color.textColor)
                                          .onFontSize(
                                              context.resources.fontSize.dp12),
                                    ),
                                    ValueListenableBuilder(
                                        valueListenable: _durationText,
                                        builder: (context, value, child) {
                                          return Text(
                                            value,
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            style: context.textFontWeight600
                                                .onColor(context.resources.color
                                                    .viewBgColor)
                                                .onFontSize(context
                                                    .resources.fontSize.dp12),
                                          );
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
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
                              visible: leaveType == LeaveType.otherLeave,
                              child: ValueListenableBuilder(
                                  valueListenable: _leaveTypeList,
                                  builder: (context, leaveTypeList, widget) {
                                    return DropDownWidget<LeaveTypeEntity>(
                                      list: leaveTypeList,
                                      height: resources.dimen.dp27,
                                      labelText: context.string.absenceType,
                                      hintText:
                                          context.string.chooseAbsenceType,
                                      suffixIconPath:
                                          DrawableAssets.icChevronDown,
                                      selectedValue: selectedLeaveType,
                                      callback: onLeaveTypeSelected,
                                    );
                                  }),
                            ),
                            Visibility(
                              visible: leaveType == LeaveType.otherLeave,
                              child: SizedBox(
                                height: resources.dimen.dp20,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _selectDate(context, _startDateController);
                              },
                              child: RightIconTextWidget(
                                height: resources.dimen.dp27,
                                labelText: context.string.startDate,
                                hintText: context.string.chooseStartDate,
                                fontFamily: fontFamilyEN,
                                errorMessage: context.string.chooseStartDate,
                                suffixIconPath: DrawableAssets.icCalendar,
                                textController: _startDateController,
                              ),
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            InkWell(
                              onTap: () {
                                if (leaveType != LeaveType.permission) {
                                  _selectDate(context, _endDateController,
                                      firstDate: getDateTimeByString(dateFormat,
                                          _startDateController.text));
                                } else {
                                  _selectDate(context, _endDateController,
                                      firstDate: getDateTimeByString(dateFormat,
                                          _startDateController.text),
                                      lastDate: getDateTimeByString(dateFormat,
                                          _startDateController.text));
                                }
                              },
                              child: RightIconTextWidget(
                                height: resources.dimen.dp27,
                                labelText: context.string.endDate,
                                hintText: context.string.chooseEndDate,
                                fontFamily: fontFamilyEN,
                                errorMessage: context.string.chooseEndDate,
                                suffixIconPath: DrawableAssets.icCalendar,
                                textController: _endDateController,
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable: _isleaveTypeChanged,
                                builder: (contex, value, widget) {
                                  return Visibility(
                                    visible: leaveType.id ==
                                            LeaveType.permission.id ||
                                        '${selectedLeaveType?.id ?? ''}' ==
                                            LeaveType.permission.id,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: resources.dimen.dp20,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  TimeOfDay? startTime;
                                                  try {
                                                    startTime = TimeOfDay.fromDateTime(
                                                        getDateTimeByString(
                                                            '$dateFormat $timeFormat',
                                                            '${_startDateController.text} ${_startTimeController.text}'));
                                                  } catch (err) {
                                                    printLog(
                                                        message:
                                                            err.toString());
                                                  }
                                                  _selectTime(context,
                                                      _endTimeController,
                                                      startTime: startTime);
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
                                              left:
                                                  context.resources.dimen.dp10,
                                              top: context.resources.dimen.dp5,
                                              right:
                                                  context.resources.dimen.dp15,
                                              bottom:
                                                  context.resources.dimen.dp5),
                                          decoration: BackgroundBoxDecoration(
                                                  boxColor: context.resources
                                                      .color.colorWhite,
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
                                                        width: context.resources
                                                            .dimen.dp5,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          context.string.upload,
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  context
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
                                                        width: context.resources
                                                            .dimen.dp10,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    resources
                                                                        .dimen
                                                                        .dp8),
                                                        child: ImageWidget(
                                                                // width: 13,
                                                                // height: 13,
                                                                path: DrawableAssets
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
                                    padding: EdgeInsets.only(
                                      left: resources.isLocalEn
                                          ? resources.dimen.dp10
                                          : 0,
                                      right: resources.isLocalEn
                                          ? 0
                                          : resources.dimen.dp10,
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
                                    boxColor:
                                        context.resources.color.viewBgColor,
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
      ),
    );
  }
}
