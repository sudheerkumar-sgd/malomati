// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/home/widgets/upload_file_widget.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/date_time_util.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class ResignationScreen extends StatelessWidget {
  static const String route = '/BadgeScreen';
  ResignationScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String employeeId = '';
  String selectedReason = '';
  final TextEditingController _resignationController = TextEditingController();
  final dateFormat = 'yyyy-MM-dd';
  final _uploadFiles = [];

  void onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      if (_uploadFiles.isEmpty) {
        Dialogs.showInfoDialog(resources.context, PopupType.fail,
            isLocalEn ? 'Please upload attachment' : 'يرجى تحميل المرفق');
        return;
      }
      _submitRequest();
    }
  }

  void _submitRequest() {
    _servicesBloc
        .submitServicesRequest(apiUrl: resignationApiUrl, requestParams: {
      "employeeNumber": employeeId,
      "teminationDate": _resignationController.text,
      "resignationReason": selectedReason,
      "fileName": _uploadFiles[0]['fileName'],
      "attachment": _uploadFiles[0]['fileNamebase64data'],
    });
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
    employeeId = context.userDB.get(userJobIdEnKey, defaultValue: '');
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
                            title: 'Resignation',
                            body:
                                '${context.userDB.get(userFullNameUsKey)} Submitted resignation request',
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
                  BackAppBarWidget(title: context.string.resignation),
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
                            InkWell(
                              onTap: () {
                                _selectDate(context, _resignationController,
                                    initialDate:
                                        _resignationController.text.isNotEmpty
                                            ? getDateTimeByString(dateFormat,
                                                _resignationController.text)
                                            : DateTime.now());
                              },
                              child: RightIconTextWidget(
                                height: resources.dimen.dp27,
                                labelText: context.string.resignationDate,
                                hintText: context.string.resignationDate,
                                fontFamily: fontFamilyEN,
                                errorMessage: context.string.resignationDate,
                                suffixIconPath: DrawableAssets.icCalendar,
                                textController: _resignationController,
                              ),
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            FutureBuilder(
                                future: _servicesBloc
                                    .getResignationReasons(requestParams: {}),
                                builder: (context, snapShot) {
                                  return DropDownWidget<String>(
                                    list: snapShot.data ?? [],
                                    height: resources.dimen.dp27,
                                    labelText: context.string.reason,
                                    errorMessage: context.string.reason,
                                    callback: (value) {
                                      selectedReason = value ?? '';
                                    },
                                  );
                                }),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            UploadFileWidget(
                              uploadFileSize: 1,
                              callback: (files) {
                                _uploadFiles.clear();
                                _uploadFiles.addAll(files);
                              },
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
