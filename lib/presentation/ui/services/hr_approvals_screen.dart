// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/presentation/ui/services/widgets/item_hr_approvals.dart';

import '../../../config/constant_config.dart';
import '../../../injection_container.dart';
import '../../bloc/services/services_bloc.dart';
import '../utils/dialogs.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class HrApprovalsScreen extends StatefulWidget {
  const HrApprovalsScreen({super.key});

  @override
  State<HrApprovalsScreen> createState() => _HrApprovalsScreenState();
}

class _HrApprovalsScreenState extends State<HrApprovalsScreen> {
  final _servicesBloc = sl<ServicesBloc>();
  List<HrApprovalEntity> _notificationList = List.empty(growable: true);
  String noNotificationText = '';
  String userName = '';
  bool _isSilentLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userName = context.userDB.get(userNameKey, defaultValue: '');
      _fetchData();
    });
  }

  @override
  void dispose() {
    _servicesBloc.close();
    super.dispose();
  }

  Future<void> _fetchData() async {
    await _servicesBloc
        .getHrApprovalsList(requestParams: {'USER_NAME': userName});
  }

  _onActionClicked(String id, BuildContext context) {
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var resources = context.resources;
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>.value(
          value: _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                if (!_isSilentLoading) Dialogs.loader(context);
              } else if (state is OnHrApprovalsListSuccess) {
                if (!_isSilentLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
                setState(() {
                  noNotificationText = context.string.noHrRequests;
                  _notificationList = List.from(state.hrApprovalsList);
                });
                _servicesBloc
                    .getRequestsCount(requestParams: {'USER_NAME': userName});
              } else if (state is OnRequestsCountSuccess) {
                ConstantConfig.hrApprovalCount =
                    state.requestsCountEntity.hRCOUNT ?? 0;
                ConstantConfig.financePOApprovalCount =
                    state.requestsCountEntity.pOCOUNT ?? 0;
                ConstantConfig.financePRApprovalCount =
                    state.requestsCountEntity.pRCOUNT ?? 0;
                ConstantConfig.financeINVApprovalCount =
                    state.requestsCountEntity.iNVCOUNT ?? 0;
                ConstantConfig.isApprovalCountChange.value =
                    !(ConstantConfig.isApprovalCountChange.value);
              } else if (state is OnServicesError) {
                if (!_isSilentLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
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
                  BackAppBarWidget(title: context.string.hrApprovals),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _isSilentLoading = true;
                        await _fetchData();
                        _isSilentLoading = false;
                      },
                      child: (_notificationList.isEmpty &&
                              noNotificationText.isNotEmpty)
                          ? SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                alignment: Alignment.center,
                                child: Text(
                                  noNotificationText,
                                  style: context.textFontWeight600,
                                ),
                              ),
                            )
                          : ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) => ItemHRApprovals(
                                    key: ValueKey(_notificationList[index]
                                        .nOTIFICATIONID),
                                    data: _notificationList[index],
                                    callBack: _onActionClicked,
                                  ),
                              separatorBuilder: (context, index) => SizedBox(
                                    height: resources.dimen.dp20,
                                  ),
                              itemCount: _notificationList.length),
                    ),
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
