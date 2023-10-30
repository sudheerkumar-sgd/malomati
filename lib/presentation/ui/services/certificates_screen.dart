// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/resources.dart';
import '../../../data/data_sources/api_urls.dart';
import '../../../data/model/api_request_model.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class CertificatesScreen extends StatelessWidget {
  static const String route = '/Certificates';
  CertificatesScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  String? showSalary;
  String userName = '';

  onShowSalarySelected(NameIdEntity? value) {
    showSalary = value?.id ?? '';
  }

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitCertificateRequest();
    }
  }

  _submitCertificateRequest() {
    final certificateRequestModel = ApiRequestModel();
    certificateRequestModel.uSERNAME = userName;
    certificateRequestModel.eNTITYNAME = _toController.text;
    certificateRequestModel.sHOWSALARY = showSalary;
    _servicesBloc.submitServicesRequest(
        apiUrl: certificateApiUrl,
        requestParams: certificateRequestModel.toCertificateRequest());
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    _nameController.text = context.userDB.get(
        resources.isLocalEn ? userFullNameUsKey : userFullNameArKey,
        defaultValue: '');
    _jobTitleController.text = context.userDB.get(
        resources.isLocalEn ? userJobNameEnKey : userJobNameArKey,
        defaultValue: '');
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
                            title: 'Certificate',
                            body:
                                '${context.userDB.get(userFullNameUsKey)} has applied for Certificate Request',
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
                  BackAppBarWidget(title: context.string.certificate),
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
                              isEnabled: false,
                              height: resources.dimen.dp27,
                              labelText: context.string.fullName,
                              textController: _nameController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              isEnabled: false,
                              height: resources.dimen.dp27,
                              labelText: context.string.jobTitle,
                              textController: _jobTitleController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              isEnabled: true,
                              height: resources.dimen.dp27,
                              labelText: context.string.entityName,
                              errorMessage: context.string.entityName,
                              textController: _toController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            DropDownWidget<NameIdEntity>(
                              list: getSalaryTypes(context),
                              height: resources.dimen.dp27,
                              labelText: context.string.showSalary,
                              errorMessage: context.string.showSalary,
                              callback: onShowSalarySelected,
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
