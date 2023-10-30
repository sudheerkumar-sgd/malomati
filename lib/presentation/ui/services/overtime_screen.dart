// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/data/model/api_request_model.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/dialog_upload_attachment.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/item_attachment.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';
import '../utils/date_time_util.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';
import 'package:file_picker/file_picker.dart';

class OvertimeScreen extends StatelessWidget {
  static const String route = '/LeavesScreen';
  OvertimeScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _noOfHoursController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final dateFormat = 'yyy-MM-dd';
  final timeFormat = 'hh:mm a';
  final ValueNotifier<bool> _isUploadChanged = ValueNotifier(false);
  final _uploadFiles = [];
  final _formKey = GlobalKey<FormState>();
  String userName = '';

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
      if (controller == _toTimeController) {
        double hours = getMinutes(
                getDateTimeByString('$dateFormat $timeFormat',
                    '${_startDateController.text} ${_fromTimeController.text}'),
                getDateTimeByString('$dateFormat $timeFormat',
                    '${_startDateController.text} ${_toTimeController.text}')) /
            60;
        if (hours > 0) {
          _noOfHoursController.text = hours.toStringAsFixed(1);
        } else {
          _noOfHoursController.text = '';
          _toTimeController.text = '';
        }
      }
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

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitRequest();
    }
  }

  _submitRequest() {
    final apiRequestModel = ApiRequestModel();
    apiRequestModel.uSERNAME = userName;
    apiRequestModel.oVERTIMEDATE = _startDateController.text;
    apiRequestModel.fROMTIME = getDateByformat(
        'HH:mm',
        getDateTimeByString('$dateFormat $timeFormat',
            '${_startDateController.text} ${_fromTimeController.text}'));
    apiRequestModel.tOTIME = getDateByformat(
        'HH:mm',
        getDateTimeByString('$dateFormat $timeFormat',
            '${_startDateController.text} ${_toTimeController.text}'));
    apiRequestModel.nOOFHOURS = _noOfHoursController.text;
    for (int i = 0; i < _uploadFiles.length; i++) {
      switch (i) {
        case 0:
          {
            apiRequestModel.fILENAME = _uploadFiles[i]['fileName'];
            apiRequestModel.bLOBFILE = _uploadFiles[i]['fileNamebase64data'];
          }
        case 1:
          {
            apiRequestModel.fILENAMENEW = _uploadFiles[i]['fileName'];
            apiRequestModel.bLOBFILENEW = _uploadFiles[i]['fileNamebase64data'];
          }
        case 2:
          {
            apiRequestModel.fILENAMENEW_ = _uploadFiles[i]['fileName'];
            apiRequestModel.bLOBFILENEW_ =
                _uploadFiles[i]['fileNamebase64data'];
          }
      }
    }
    apiRequestModel.rEASON = _reasonController.text;
    _servicesBloc.submitServicesRequest(
        apiUrl: overtimeApiUrl,
        requestParams: apiRequestModel.toOvertimeRequest());
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    userName = context.userDB.get(userNameKey, defaultValue: '');

    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                Dialogs.loader(context);
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
                            title: 'Overtime',
                            body: getLeavesApproverFCMBodyText(
                                context.userDB.get(userFullNameUsKey),
                                'Overtime',
                                '${_startDateController.text} ${_fromTimeController.text}',
                                _toTimeController.text),
                            type: fcmTypeHRApprovals,
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
                  BackAppBarWidget(title: context.string.overtime),
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
                                labelText: context.string.overtimeDate,
                                hintText: context.string.chooseOvertimeDate,
                                errorMessage: context.string.chooseOvertimeDate,
                                fontFamily: fontFamilyEN,
                                suffixIconPath: DrawableAssets.icCalendar,
                                textController: _startDateController,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: resources.dimen.dp20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          _selectTime(
                                              context, _fromTimeController);
                                        },
                                        child: RightIconTextWidget(
                                          height: resources.dimen.dp27,
                                          labelText: context.string.fromTime,
                                          hintText:
                                              context.string.chooseFromTime,
                                          errorMessage:
                                              context.string.chooseFromTime,
                                          fontFamily: fontFamilyEN,
                                          suffixIconPath: DrawableAssets.icTime,
                                          textController: _fromTimeController,
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
                                              context, _toTimeController,
                                              startTime: getDateTimeByString(
                                                  '$dateFormat $timeFormat',
                                                  '${_startDateController.text} ${_toTimeController.text.isEmpty ? _fromTimeController.text : _toTimeController.text}'));
                                        },
                                        child: RightIconTextWidget(
                                          height: resources.dimen.dp27,
                                          labelText: context.string.totime,
                                          hintText: context.string.chooseTotime,
                                          errorMessage:
                                              context.string.chooseTotime,
                                          fontFamily: fontFamilyEN,
                                          suffixIconPath: DrawableAssets.icTime,
                                          textController: _toTimeController,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              isEnabled: true,
                              height: resources.dimen.dp27,
                              textInputType: TextInputType.number,
                              labelText: context.string.noOfHours,
                              errorMessage: context.string.noOfHours,
                              fontFamily: fontFamilyEN,
                              textController: _noOfHoursController,
                            ),
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
                                                                    .icUpload)
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
                                            path: DrawableAssets.icPlusCircle)
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
                              labelText: context.string.reason,
                              errorMessage: context.string.reason,
                              textController: _reasonController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
