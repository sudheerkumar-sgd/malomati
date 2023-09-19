// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/domain/entities/finance_approval_entity.dart';
import 'package:malomati/presentation/ui/services/widgets/item_finance_inv_approvals.dart';
import 'package:malomati/presentation/ui/services/widgets/item_finance_po_approvals.dart';
import 'package:malomati/presentation/ui/services/widgets/item_finance_pr_approvals.dart';
import 'package:malomati/presentation/ui/widgets/tab_buttons_widget.dart';
import 'package:malomati/res/resources.dart';
import '../../../config/constant_config.dart';
import '../../../injection_container.dart';
import '../../bloc/services/services_bloc.dart';
import '../utils/dialogs.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

enum FinanceApprovalType {
  po,
  pr,
  invoice;
}

class FinanceApprovalsScreen extends StatelessWidget {
  static const String route = '/FinanceApprovalsScreen';
  final int index;
  FinanceApprovalsScreen({this.index = 0, super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  ValueNotifier<int> selectedButtonIndex = ValueNotifier<int>(0);
  final ValueNotifier<List<FinanceApprovalEntity>> _financeNotificationList =
      ValueNotifier([]);
  ValueNotifier<List<Map>> _buttons = ValueNotifier([]);
  String userName = '';
  _onActionClicked(String id, BuildContext context) {
    // final list = _notificationList.value;
    // final index = list.indexWhere((element) => element.nOTIFICATIONID == id);
    // list.removeAt(index);
    // _notificationList.value = [];
    // _notificationList.value = list;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => FinanceApprovalsScreen(
                index: selectedButtonIndex.value,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    _buttons.value = [
      {'name': 'PO', 'count': ConstantConfig.financePOApprovalCount},
      {'name': 'PR', 'count': ConstantConfig.financePRApprovalCount},
      {'name': 'Invoice', 'count': ConstantConfig.financeINVApprovalCount}
    ];
    selectedButtonIndex.value = index;
    var noNotificationText = '';
    userName = context.userDB.get(userNameKey, defaultValue: '');
    Future.delayed(const Duration(milliseconds: 50), () {
      _servicesBloc.getRequestsCount(requestParams: {'USER_NAME': userName});
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                Dialogs.loader(context);
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
                _buttons.value = [
                  {
                    'name': 'PO',
                    'count': ConstantConfig.financePOApprovalCount
                  },
                  {
                    'name': 'PR',
                    'count': ConstantConfig.financePRApprovalCount
                  },
                  {
                    'name': 'Invoice',
                    'count': ConstantConfig.financeINVApprovalCount
                  }
                ];
              } else if (state is OnFinanceApprovalsListSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                noNotificationText = context.string.noHrRequests;
                _financeNotificationList.value = state.financeApprovalsList;
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
                  BackAppBarWidget(title: context.string.financeApprovals),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  ValueListenableBuilder(
                      valueListenable: _buttons,
                      builder: (context, buttons, child) {
                        return TabsButtonsWidget(
                          buttons: buttons,
                          selectedIndex: selectedButtonIndex,
                        );
                      }),
                  SizedBox(
                    height: context.resources.dimen.dp30,
                  ),
                  ValueListenableBuilder(
                      valueListenable: selectedButtonIndex,
                      builder: (context, value, widget) {
                        noNotificationText = '';
                        _financeNotificationList.value = [];
                        _servicesBloc.getFinanceApprovalList(
                            apiUrl: value == 0
                                ? financePOApiUrl
                                : value == 1
                                    ? financePRApiUrl
                                    : financeInvoiceApiUrl,
                            requestParams: {'USER_NAME': userName});
                        return Expanded(
                          child: ValueListenableBuilder(
                              valueListenable: _financeNotificationList,
                              builder: (context, notificationList, child) {
                                return (notificationList.isEmpty &&
                                        noNotificationText.isNotEmpty)
                                    ? Center(
                                        child: Text(
                                          noNotificationText,
                                          style: context.textFontWeight600,
                                        ),
                                      )
                                    : ListView.separated(
                                        controller: ScrollController(),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) =>
                                            value == 0
                                                ? ItemFinancePOApprovals(
                                                    data:
                                                        notificationList[index],
                                                    callBack: _onActionClicked,
                                                  )
                                                : value == 1
                                                    ? ItemFinancePRApprovals(
                                                        data: notificationList[
                                                            index],
                                                        callBack:
                                                            _onActionClicked,
                                                      )
                                                    : ItemFinanceInvApprovals(
                                                        data: notificationList[
                                                            index],
                                                        callBack:
                                                            _onActionClicked,
                                                      ),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                              height: resources.dimen.dp20,
                                            ),
                                        itemCount: notificationList.length);
                              }),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
