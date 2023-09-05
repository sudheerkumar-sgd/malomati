// ignore_for_file: must_be_immutable
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
import '../../../data/model/api_request_model.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class BadgeScreen extends StatelessWidget {
  static const String route = '/BadgeScreen';
  BadgeScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  final TextEditingController empNumberController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController hiringDateController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitAdvanceSalaryRequest();
    }
  }

  _submitAdvanceSalaryRequest() {
    final certificateRequestModel = ApiRequestModel();
    certificateRequestModel.uSERNAME = userName;
    certificateRequestModel.hIRINGDATE = getDateByformat('dd-MM-yyyy',
        getDateTimeByString('dd-MMM-yyyy', hiringDateController.text));
    _servicesBloc.submitServicesRequest(
        apiUrl: badgeApiUrl,
        requestParams: certificateRequestModel.toBadgeRequest());
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    empNumberController.text =
        context.userDB.get(userJobIdEnKey, defaultValue: '');
    nationalityController.text = context.userDB.get(
        isLocalEn ? userNationalityEnKey : userNationalityArKey,
        defaultValue: '');
    if (nationalityController.text.isEmpty) {
      nationalityController.text =
          context.userDB.get(userNationalityEnKey, defaultValue: '');
    }
    hiringDateController.text =
        context.userDB.get(userJoiningDateEnKey, defaultValue: '');
    jobTitleController.text = context.userDB
        .get(isLocalEn ? userJobNameEnKey : userJobNameArKey, defaultValue: '');
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
                  BackAppBarWidget(title: context.string.badge),
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
                              height: resources.dimen.dp27,
                              labelText: context.string.employeeNumber,
                              textController: empNumberController,
                              fontFamily: fontFamilyEN,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              height: resources.dimen.dp27,
                              labelText: context.string.nationality,
                              textController: nationalityController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              height: resources.dimen.dp27,
                              labelText: context.string.hiringDate,
                              textController: hiringDateController,
                              fontFamily: fontFamilyEN,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              height: resources.dimen.dp27,
                              labelText: context.string.jobTitle,
                              textController: jobTitleController,
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
