// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';
import '../widgets/animated_toggle.dart';
import '../widgets/back_app_bar.dart';
import 'package:file_picker/file_picker.dart';

enum LeaveType {
  anualLeave('Annual Leaves'),
  permission('Permission'),
  sickLeave('Sick Leaves'),
  missionLeave('Mission Leaves'),
  otherLeave('Other Leaves');

  final String name;
  const LeaveType(this.name);
}

class LeavesScreen extends StatelessWidget {
  static const String route = '/LeavesScreen';
  final LeaveType leaveType;
  LeavesScreen({required this.leaveType, super.key});
  late Resources resources;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _uploadController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final dateFormat = 'dd-MMM-yyyy';
  final timeFormat = 'hh:mm a';

  String _getTitleByLeaveType(BuildContext context) {
    switch (leaveType) {
      case LeaveType.anualLeave:
        {
          return context.string.anualLeaves;
        }
      case LeaveType.permission:
        {
          return context.string.permission;
        }
      case LeaveType.sickLeave:
        {
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
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: firstDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime.now(),
        lastDate: lastDate ?? DateTime(2024));
    if (picked != null) {
      controller.text = getDateByformat(dateFormat, picked);
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller,
      {TimeOfDay? startTime}) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context, initialTime: startTime ?? TimeOfDay.now());
    if (picked != null) {
      controller.text = picked.format(context);
    }
  }

  Future<void> _selectFile(
    TextEditingController controller,
  ) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.media);

    if (result != null) {
      controller.text = result.files.single.name;
      if (controller.text.isNotEmpty) {
        File file = File(result.files.single.path ?? '');
      }
    } else {
      printLog(message: 'message');
    }
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    _startDateController.addListener(
      () {
        _endDateController.text = '';
      },
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: Container(
          margin: EdgeInsets.symmetric(
              vertical: context.resources.dimen.dp20,
              horizontal: context.resources.dimen.dp25),
          child: Column(
            children: [
              SizedBox(
                height: context.resources.dimen.dp10,
              ),
              BackAppBarWidget(title: _getTitleByLeaveType(context)),
              SizedBox(
                height: context.resources.dimen.dp20,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimen.dp15,
                    vertical: resources.dimen.dp5),
                decoration: BackgroundBoxDecoration(
                        boxColor:
                            context.resources.color.bottomSheetIconUnSelected,
                        radious: context.resources.dimen.dp15)
                    .roundedCornerBox,
                child: Text(
                  context.string.currentBalance,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.dimen.dp12)
                      .copyWith(height: 1),
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
                        .onFontSize(context.resources.dimen.dp12)
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
                        printLog(message: '$value');
                      },
                      buttonColor: resources.color.viewBgColor,
                      backgroundColor:
                          resources.color.bottomSheetIconUnSelected,
                      boxRadious: resources.dimen.dp5,
                      textColor: const Color(0xFFFFFFFF),
                      textFontSize: resources.dimen.dp13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Visibility(
                        visible: leaveType == LeaveType.otherLeave,
                        child: InkWell(
                          onTap: () {
                            _selectDate(context, _startDateController);
                          },
                          child: RightIconTextWidget(
                            height: resources.dimen.dp27,
                            labelText: context.string.absenceType,
                            hintText: context.string.chooseAbsenceType,
                            suffixIconPath: DrawableAssets.icChevronDown,
                            textController: _startDateController,
                          ),
                        ),
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
                          suffixIconPath: DrawableAssets.icCalendar,
                          textController: _endDateController,
                        ),
                      ),
                      Visibility(
                        visible: leaveType == LeaveType.permission,
                        child: SizedBox(
                          height: resources.dimen.dp20,
                        ),
                      ),
                      Visibility(
                        visible: leaveType == LeaveType.permission,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _selectTime(context, _startTimeController);
                                },
                                child: RightIconTextWidget(
                                  height: resources.dimen.dp27,
                                  labelText: context.string.startTime,
                                  hintText: context.string.chooseStartTime,
                                  suffixIconPath: DrawableAssets.icTime,
                                  textController: _startTimeController,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: resources.dimen.dp20,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  final startTime = TimeOfDay.fromDateTime(
                                      getDateTimeByString(
                                          '$dateFormat $timeFormat',
                                          '${_startDateController.text} ${_startTimeController.text}'));
                                  _selectTime(context, _endTimeController,
                                      startTime: startTime);
                                },
                                child: RightIconTextWidget(
                                  height: resources.dimen.dp27,
                                  labelText: context.string.endTime,
                                  hintText: context.string.chooseEndTime,
                                  suffixIconPath: DrawableAssets.icTime,
                                  textController: _endTimeController,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: resources.dimen.dp20,
                      ),
                      InkWell(
                        onTap: () {
                          _selectFile(_uploadController);
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: RightIconTextWidget(
                                height: resources.dimen.dp27,
                                labelText: context.string.upload,
                                hintText: context.string.chooseFiles,
                                suffixIconPath: DrawableAssets.icUpload,
                                textController: _uploadController,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: resources.dimen.dp10,
                                  top: resources.dimen.dp20),
                              child:
                                  ImageWidget(path: DrawableAssets.icPlusCircle)
                                      .loadImage,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: resources.dimen.dp20,
                      ),
                      RightIconTextWidget(
                        height: resources.dimen.dp100,
                        isEnabled: true,
                        labelText: context.string.comments,
                        textController: _commentController,
                      ),
                    ],
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
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.resources.dimen.dp15,
                          vertical: resources.dimen.dp7),
                      decoration: BackgroundBoxDecoration(
                              boxColor: context.resources.color.textColorLight,
                              radious: context.resources.dimen.dp15)
                          .roundedCornerBox,
                      child: Text(
                        context.string.cancel,
                        style: context.textFontWeight600
                            .onFontSize(context.resources.dimen.dp17)
                            .onColor(resources.color.colorWhite)
                            .copyWith(height: 1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: resources.dimen.dp20,
                  ),
                  Expanded(
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
                            .onFontSize(context.resources.dimen.dp17)
                            .onColor(resources.color.colorWhite)
                            .copyWith(height: 1),
                        textAlign: TextAlign.center,
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
    );
  }
}
