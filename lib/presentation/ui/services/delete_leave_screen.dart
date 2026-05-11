import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/network/api_urls.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import '../../../core/common/common_utils.dart';
import 'package:malomati/domain/requests/api_request_model.dart';
import '../../../domain/entities/leave_details_entity.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class DeleteLeaveScreen extends StatefulWidget {
  static const String route = '/DeleteLeaveScreen';
  const DeleteLeaveScreen({super.key});

  @override
  State<DeleteLeaveScreen> createState() => _DeleteLeaveScreenState();
}

class _DeleteLeaveScreenState extends State<DeleteLeaveScreen> {
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  final ValueNotifier<List<LeaveDetailsEntity>> _leaves =
      ValueNotifier<List<LeaveDetailsEntity>>([]);
  final TextEditingController _commentsController = TextEditingController();
  String? leave;
  bool _isLoading = false;
  bool _didInit = false;
  String _noLeavesText = '';

  onLeavesSelected(LeaveDetailsEntity? value) {
    leave = value?.id ?? '';
  }

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitAdvanceSalaryRequest();
    }
  }

  _submitAdvanceSalaryRequest() {
    final deleteLeaveRequestModel = ApiRequestModel();
    deleteLeaveRequestModel.uSERNAME = userName;
    deleteLeaveRequestModel.aPPROVALCOMMENT = _commentsController.text;
    deleteLeaveRequestModel.lEAVE = leave;
    _servicesBloc.submitServicesRequest(
        apiUrl: deleteLeaveApiUrl,
        requestParams: deleteLeaveRequestModel.toDeleteLeaveRequest());
  }

  void _showLoader(BuildContext context) {
    if (_isLoading) return;
    _isLoading = true;
    Dialogs.loader(context).then((_) {
      _isLoading = false;
    });
  }

  void _hideLoader(BuildContext context) {
    if (!_isLoading) return;
    Navigator.of(context, rootNavigator: true).pop();
    _isLoading = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    _servicesBloc.getLeaves(
        apiUrl: deleteleavesApiUrl, requestParams: {'USER_NAME': userName});
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
              } else if (state is OnLeavesSuccess) {
                _noLeavesText = context.string.noDeleteLeaves;
                _leaves.value = state.leavesList;
              } else if (state is OnServicesRequestSubmitSuccess) {
                _hideLoader(context);
                _servicesBloc.sendPushNotifications(
                    requestParams: getFCMMessageData(
                        to: userName,
                        title: 'Delete Leave',
                        body:
                            '${context.userDB.get(userFullNameUsKey)} has applied for Delete Leave Request',
                        type: '',
                        notificationId: state
                                .servicesRequestSuccessResponse.entity?.nTFID ??
                            ''));
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
                            title: 'Delete Leave',
                            body:
                                '${context.userDB.get(userFullNameUsKey)} has applied for Delete Leave Request',
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
              child: ValueListenableBuilder(
                  valueListenable: _leaves,
                  builder: (context, leaves, child) {
                    return Column(
                      children: [
                        SizedBox(
                          height: context.resources.dimen.dp10,
                        ),
                        BackAppBarWidget(title: context.string.deleteLeave),
                        SizedBox(
                          height: context.resources.dimen.dp20,
                        ),
                        if (leaves.isNotEmpty) ...[
                          Expanded(
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropDownWidget<LeaveDetailsEntity>(
                                      list: leaves,
                                      labelText: context.string.leaves,
                                      errorMessage: context.string.leaves,
                                      callback: onLeavesSelected,
                                    ),
                                    SizedBox(
                                      height: resources.dimen.dp20,
                                    ),
                                    RightIconTextWidget(
                                      isEnabled: true,
                                      maxLines: 5,
                                      height: resources.dimen.dp27,
                                      labelText: context.string.reason,
                                      textController: _commentsController,
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
                        if (leaves.isEmpty) ...[
                          Expanded(
                            child: _noLeavesText.isNotEmpty
                                ? Center(
                                    child: Text(
                                      _noLeavesText,
                                      style: context.textFontWeight600,
                                    ),
                                  )
                                : const Center(
                                    child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator())),
                          )
                        ]
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _leaves.dispose();
    _commentsController.dispose();
    _servicesBloc.close();
    super.dispose();
  }
}
