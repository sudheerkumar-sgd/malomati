// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/data/model/api_request_model.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/back_app_bar.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/resources.dart';

import '../widgets/alert_dialog_widget.dart';

class CertificatesScreen extends StatelessWidget {
  static const String route = '/Certificates';

  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServicesBloc>(),
      child: const CertificatesView(),
    );
  }
}

class CertificatesView extends StatefulWidget {
  const CertificatesView({super.key});

  @override
  State<CertificatesView> createState() => _CertificatesViewState();
}

class _CertificatesViewState extends State<CertificatesView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _toControllerEn;
  late final TextEditingController _toControllerAr;
  late final TextEditingController _fromDateController;

  String? showSalary;
  String? showEID;
  late String userName;

  Resources get resources => context.resources;

  ServicesBloc get servicesBloc => context.read<ServicesBloc>();

  @override
  void initState() {
    super.initState();

    userName = context.userDB.get(userNameKey, defaultValue: '');

    _nameController = TextEditingController(
      text: context.userDB.get(
        resources.isLocalEn ? userFullNameUsKey : userFullNameArKey,
        defaultValue: '',
      ),
    );

    _jobTitleController = TextEditingController(
      text: context.userDB.get(
        resources.isLocalEn ? userJobNameEnKey : userJobNameArKey,
        defaultValue: '',
      ),
    );

    _fromDateController = TextEditingController(
      text: getDateByformat(
        'dd-MM-yyyy',
        DateTime.now(),
      ),
    );

    _toControllerEn = TextEditingController();
    _toControllerAr = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _toControllerEn.dispose();
    _toControllerAr.dispose();
    _fromDateController.dispose();
    super.dispose();
  }

  void onShowSalarySelected(NameIdEntity? value) {
    showSalary = value?.id;
  }

  void onShowEIDSelected(NameIdEntity? value) {
    showEID = value?.id;
  }

  void onSubmit(String clickedButton) {
    if (!_formKey.currentState!.validate()) return;

    final request = ApiRequestModel()
      ..uSERNAME = userName
      ..eNTITYNAMEEN = _toControllerEn.text.trim()
      ..eNTITYNAMEAR = _toControllerAr.text.trim()
      ..sHOWSALARY = showSalary
      ..sHOWEID = showEID
      ..fROMDATE = _fromDateController.text;

    servicesBloc.submitServicesRequest(
      apiUrl: certificateApiUrl,
      requestParams: request.toCertificateRequest(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: resources.color.appScaffoldBg,
        body: BlocListener<ServicesBloc, ServicesState>(
          listener: (context, state) {
            if (state is OnServicesLoading) {
              Dialogs.loader(context);
            } else if (state is OnServicesRequestSubmitSuccess) {
              Navigator.of(context, rootNavigator: true).pop();

              final response = state.servicesRequestSuccessResponse;

              if (response.isSuccess ?? false) {
                Dialogs.showInfoDialog(
                  context,
                  PopupType.success,
                  response.getDisplayMessage(resources),
                ).then((_) => Navigator.pop(context));

                final approvers = response.entity?.aPPROVERSLIST ?? [];

                for (final approver in approvers) {
                  servicesBloc.sendPushNotifications(
                    requestParams: getFCMMessageData(
                      to: approver,
                      title: 'Certificate',
                      body: '${context.userDB.get(userFullNameUsKey)} '
                          'has applied for Certificate Request',
                      type: '',
                      notificationId: response.entity?.nTFID ?? '',
                    ),
                  );
                }
              } else {
                Dialogs.showInfoDialog(
                  context,
                  PopupType.fail,
                  response.getDisplayMessage(resources),
                );
              }
            } else if (state is OnServicesError) {
              Navigator.of(context, rootNavigator: true).pop();

              Dialogs.showInfoDialog(
                context,
                PopupType.fail,
                state.message,
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: resources.dimen.dp20,
              horizontal: resources.dimen.dp25,
            ),
            child: Column(
              children: [
                SizedBox(height: resources.dimen.dp10),
                BackAppBarWidget(
                  title: context.string.certificate,
                ),
                SizedBox(height: resources.dimen.dp20),
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
                            isEnabled: false,
                            height: resources.dimen.dp27,
                            labelText: context.string.fromDate,
                            textController: _fromDateController,
                          ),
                          SizedBox(
                            height: resources.dimen.dp20,
                          ),
                          RightIconTextWidget(
                            isEnabled: true,
                            height: resources.dimen.dp27,
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            labelText: context.string.entityNameEn,
                            errorMessage: context.string.entityNameEn,
                            textController: _toControllerEn,
                          ),
                          SizedBox(
                            height: resources.dimen.dp20,
                          ),
                          RightIconTextWidget(
                            isEnabled: true,
                            height: resources.dimen.dp27,
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            labelText: context.string.entityNameAr,
                            errorMessage: context.string.entityNameAr,
                            textController: _toControllerAr,
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
                          SizedBox(
                            height: resources.dimen.dp20,
                          ),
                          DropDownWidget<NameIdEntity>(
                            list: getDropDownYesNo(context),
                            height: resources.dimen.dp27,
                            labelText: context.string.showEID,
                            errorMessage: context.string.showEID,
                            callback: onShowEIDSelected,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: resources.dimen.dp20),
                SubmitCancelWidget(
                  callBack: onSubmit,
                ),
                SizedBox(height: resources.dimen.dp10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
