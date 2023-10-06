// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/resources.dart';
import '../../../core/common/log.dart';
import '../../../data/model/api_request_model.dart';
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
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final ValueNotifier<bool> _isUploadChanged = ValueNotifier(false);
  final _uploadFiles = [];

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitAdvanceSalaryRequest();
    }
  }

  _submitAdvanceSalaryRequest() {
    final certificateRequestModel = ApiRequestModel();
    _servicesBloc.submitServicesRequest(
        apiUrl: badgeApiUrl,
        requestParams: certificateRequestModel.toBadgeRequest());
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

  @override
  Widget build(BuildContext context) {
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
                            title: 'Badge',
                            body:
                                '${context.userDB.get(userFullNameUsKey)} has applied for Badge ID',
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
