import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/network/api_urls.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/home/widgets/upload_file_widget.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/date_time_util.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class ResignationScreen extends StatefulWidget {
  static const String route = '/BadgeScreen';
  const ResignationScreen({super.key});

  @override
  State<ResignationScreen> createState() => _ResignationScreenState();
}

class _ResignationScreenState extends State<ResignationScreen> {
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String employeeId = '';
  String selectedReason = '';
  final TextEditingController _resignationController = TextEditingController();
  final dateFormat = 'yyyy-MM-dd';
  final List<dynamic> _uploadFiles = [];
  bool _didInit = false;
  bool _isLoaderShowing = false;
  Future<List<String>>? _resignationReasonsFuture;

  void onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      if (_uploadFiles.isEmpty) {
        Dialogs.showInfoDialog(context, PopupType.fail,
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

  void _showLoader(BuildContext context) {
    if (_isLoaderShowing) return;
    _isLoaderShowing = true;
    Dialogs.loader(context).then((_) {
      _isLoaderShowing = false;
    });
  }

  void _hideLoader(BuildContext context) {
    if (!_isLoaderShowing) return;
    Navigator.of(context, rootNavigator: true).pop();
    _isLoaderShowing = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    employeeId = context.userDB.get(userJobIdEnKey, defaultValue: '');
    _resignationReasonsFuture =
        _servicesBloc.getResignationReasons(requestParams: {});
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                _showLoader(context);
              } else if (state is OnServicesRequestSubmitSuccess) {
                _hideLoader(context);
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
                _hideLoader(context);
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
                                future: _resignationReasonsFuture,
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

  @override
  void dispose() {
    _resignationController.dispose();
    _servicesBloc.close();
    super.dispose();
  }
}
