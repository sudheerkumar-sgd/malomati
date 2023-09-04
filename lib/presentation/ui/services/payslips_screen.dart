// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/res/resources.dart';
import '../../../data/model/api_request_model.dart';
import '../../../res/drawables/background_box_decoration.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class PayslipsScreen extends StatelessWidget {
  static const String route = '/PayslipsScreen';
  PayslipsScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  final ValueNotifier<List<NameIdEntity>> _leaves =
      ValueNotifier<List<NameIdEntity>>([]);
  final TextEditingController _commentsController = TextEditingController();
  String? leave;

  onLeavesSelected(NameIdEntity? value) {
    leave = value?.id ?? '';
  }

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitAdvanceSalaryRequest();
    }
  }

  _submitAdvanceSalaryRequest() {
    final certificateRequestModel = ApiRequestModel();
    certificateRequestModel.uSERNAME = userName;
    certificateRequestModel.aPPROVALCOMMENT = _commentsController.text;
    certificateRequestModel.lEAVE = leave;
    _servicesBloc.submitServicesRequest(
        apiUrl: advanceSalaryApiUrl,
        requestParams: certificateRequestModel.toAdvanceSalaryRequest());
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
              } else if (state is OnLeavesSuccess) {
                _leaves.value = state.leavesList;
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
                  BackAppBarWidget(title: context.string.payslip),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.resources.dimen.dp15,
                        vertical: context.resources.dimen.dp7),
                    decoration: BackgroundBoxDecoration(
                            boxColor: context.resources.color.viewBgColor,
                            radious: context.resources.dimen.dp15)
                        .roundedCornerBox,
                    child: Text(
                      context.string.submit,
                      style: context.textFontWeight600
                          .onFontSize(context.resources.fontSize.dp17)
                          .onColor(context.resources.color.colorWhite)
                          .copyWith(height: 1),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
