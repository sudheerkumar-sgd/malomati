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

class TrainingCertificateScreen extends StatefulWidget {
  static const String route = '/BadgeScreen';
  const TrainingCertificateScreen({super.key});

  @override
  State<TrainingCertificateScreen> createState() =>
      _TrainingCertificateScreenState();
}

class _TrainingCertificateScreenState extends State<TrainingCertificateScreen> {
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String empNumber = '';
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateDateController = TextEditingController();
  final TextEditingController _certificateNameController =
      TextEditingController();
  String? trainingCerttype;
  final dateFormat = 'yyyy-MM-dd';
  final List<dynamic> _uploadFiles = [];
  bool _didInit = false;
  bool _isLoaderShowing = false;
  Future<List<String>>? _trainingTypeFuture;

  void _onSubmit(String clickedButton) {
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
    final requestParams = {
      "employeeNumber": empNumber,
      "trainingName": _certificateNameController.text,
      "startDate": _startDateController.text,
      "endDate": _endDateDateController.text,
      "trainingType": trainingCerttype ?? '',
      "userName": userName,
      "attachmentName": _uploadFiles[0]['fileName'],
      "attachmentFileBlob": _uploadFiles[0]['fileNamebase64data']
    };
    _servicesBloc.submitServicesRequest(
        apiUrl: addCertificateApiUrl, requestParams: requestParams);
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
    empNumber = context.userDB.get(userJobIdEnKey, defaultValue: '');
    _trainingTypeFuture =
        _servicesBloc.getTrainingCerttypeList(requestParams: {});
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
                  BackAppBarWidget(
                      title: context.string.addTrainingCertificate),
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
                              labelText: context.string.trainingCertificateName,
                              hintText: context.string.trainingCertificateName,
                              errorMessage:
                                  context.string.trainingCertificateName,
                              textController: _certificateNameController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            FutureBuilder(
                                future: _trainingTypeFuture,
                                builder: (context, snapShot) {
                                  return DropDownWidget<String>(
                                    list: snapShot.data ?? [],
                                    height: resources.dimen.dp27,
                                    labelText: context.string.typeOfCertificate,
                                    errorMessage:
                                        context.string.typeOfCertificate,
                                    callback: (value) {
                                      trainingCerttype = value ?? '';
                                      _formKey.currentState!.validate();
                                    },
                                  );
                                }),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _selectDate(context, _startDateController,
                                          initialDate: _startDateController
                                                  .text.isNotEmpty
                                              ? getDateTimeByString(dateFormat,
                                                  _startDateController.text)
                                              : DateTime.now());
                                      _formKey.currentState!.validate();
                                    },
                                    child: RightIconTextWidget(
                                      height: resources.dimen.dp27,
                                      isEnabled: false,
                                      labelText: context.string.startDate,
                                      hintText: context.string.startDate,
                                      errorMessage: context.string.startDate,
                                      fontFamily: fontFamilyEN,
                                      suffixIconPath: DrawableAssets.icCalendar,
                                      textController: _startDateController,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: context.resources.dimen.dp10,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _selectDate(
                                          context, _endDateDateController,
                                          initialDate: _endDateDateController
                                                  .text.isNotEmpty
                                              ? getDateTimeByString(dateFormat,
                                                  _endDateDateController.text)
                                              : DateTime.now());
                                      _formKey.currentState!.validate();
                                    },
                                    child: RightIconTextWidget(
                                      height: resources.dimen.dp27,
                                      isEnabled: false,
                                      labelText: context.string.endDate,
                                      hintText: context.string.endDate,
                                      errorMessage: context.string.endDate,
                                      fontFamily: fontFamilyEN,
                                      suffixIconPath: DrawableAssets.icCalendar,
                                      textController: _endDateDateController,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                  SubmitCancelWidget(callBack: _onSubmit),
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
    _startDateController.dispose();
    _endDateDateController.dispose();
    _certificateNameController.dispose();
    _servicesBloc.close();
    super.dispose();
  }
}
