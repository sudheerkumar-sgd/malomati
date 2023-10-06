// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/resources.dart';
import '../../../core/common/log.dart';
import '../../../res/drawables/background_box_decoration.dart';
import '../../../res/drawables/drawable_assets.dart';
import '../services/widgets/dialog_upload_attachment.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/image_widget.dart';
import '../widgets/item_attachment.dart';
import 'guest_back_app_bar.dart';

class GuestJobsScreen extends StatelessWidget {
  static const String route = '/GuestJobsScreen';
  GuestJobsScreen({super.key});
  late Resources resources;
  late BuildContext context;
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final ValueNotifier<bool> _isUploadChanged = ValueNotifier(false);
  final _uploadFiles = [];

  _getFile(BuildContext context) async {
    String filePath = '';
    String fileName = '';
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      fileName = result.files.single.name;
      filePath = result.files.single.path ?? '';
    }
    if (filePath.isNotEmpty) {
      File file = File(filePath);
      printLog(message: '${file.lengthSync()}');
      if (file.lengthSync() <= maxUploadFilesize * 2) {
        final bytes = file.readAsBytesSync();
        final data = {
          'fileName': fileName,
          'fileNamebase64data': base64Encode(bytes),
        };
        _uploadFiles.add(data);
        _isUploadChanged.value = !_isUploadChanged.value;
      } else if (context.mounted) {
        Dialogs.showInfoDialog(
            context, PopupType.fail, "Upload file should not be more then 2mb");
      }
    } else {
      printLog(message: 'message');
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

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      bool isValidEmail = RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(emailIdController.text);
      if (!isValidEmail) {
        Dialogs.showInfoDialog(
            context, PopupType.fail, 'Please enter valid email');
      } else if (mobileNumberController.text.length < 10) {
        Dialogs.showInfoDialog(
            context, PopupType.fail, 'Please enter valid Mobile Number');
      } else if (_uploadFiles.isEmpty) {
        Dialogs.showInfoDialog(
            context, PopupType.fail, 'Please add attachemnt');
      } else {
        _submitJobRequest();
      }
    }
  }

  _submitJobRequest() {
    Map<String, dynamic> jobRequest = {
      "sendToEmail": "career@uaqgov.ae",
      "ccEmail": emailIdController.text,
      "languageCode": "en",
      "subject":
          "New CV ${firstNameController.text} ${lastNameController.text}",
      "messageContent":
          "<b>Dear HR</b>,<br/><br/>Kindly be informed that there is a new CV Submitted. Please find below details and attachment of the candidate.<br/><br/>Name: ${firstNameController.text} ${lastNameController.text}<br/><br/>Email: ${emailIdController.text}<br/><br/>Mobile Number: ${mobileNumberController.text}<br/><br/><br/><b>Thanks,<br/><br/>Malomati</b>",
      "attachments": {
        "documentName": _uploadFiles[0]['fileName'],
        "document": _uploadFiles[0]['fileNamebase64data']
      }
    };
    _servicesBloc.submitJobEmailRequest(requestParams: jobRequest);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    resources = context.resources;
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                Dialogs.loader(context);
              } else if (state is OnJobEmailSubmitSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                if (state.jobEmailSubmitSuccess['statusCode'] == '200') {
                  Dialogs.showInfoDialog(context, PopupType.success,
                          state.jobEmailSubmitSuccess['status'])
                      .then((value) => Navigator.pop(context));
                } else {
                  Dialogs.showInfoDialog(context, PopupType.fail,
                      state.jobEmailSubmitSuccess['status']);
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
                  GuestBackAppBarWidget(title: context.string.jobs),
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
                            RightIconTextWidget(
                              isEnabled: true,
                              height: resources.dimen.dp27,
                              labelText: context.string.firstName,
                              errorMessage: context.string.firstName,
                              textController: firstNameController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              isEnabled: true,
                              height: resources.dimen.dp27,
                              labelText: context.string.lastName,
                              errorMessage: context.string.lastName,
                              textController: lastNameController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              isEnabled: true,
                              height: resources.dimen.dp27,
                              labelText: context.string.emailID,
                              errorMessage: context.string.emailID,
                              textController: emailIdController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              isEnabled: true,
                              height: resources.dimen.dp27,
                              maxLength: 12,
                              labelText: context.string.mobileNo,
                              textInputType: TextInputType.number,
                              errorMessage: context.string.mobileNo,
                              textController: mobileNumberController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            Text(
                              context.string.uploadCV,
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
                                                    _getFile(context);
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
                              ],
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
