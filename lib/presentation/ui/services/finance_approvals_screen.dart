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
import '../../../injection_container.dart';
import '../../bloc/services/services_bloc.dart';
import '../utils/dialogs.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class FinanceApprovalsScreen extends StatelessWidget {
  static const String route = '/FinanceApprovalsScreen';
  FinanceApprovalsScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  ValueNotifier<int> selectedButtonIndex = ValueNotifier<int>(0);
  final ValueNotifier<List<FinanceApprovalEntity>> _financeNotificationList =
      ValueNotifier([]);
  List<String> buttons = [];
  String userName = '';
  _onActionClicked(String id) {
    final list = _financeNotificationList.value;
    final index = list.indexWhere((element) => element.nOTIFICATIONID == id);
    list.removeAt(index);
    _financeNotificationList.value = [];
    _financeNotificationList.value = list;
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    buttons = ['PO', 'PR', 'Invoice'];
    var noNotificationText = '';
    userName = context.userDB.get(userNameKey, defaultValue: '');
    // Future.delayed(const Duration(milliseconds: 50), () {
    //   _servicesBloc.getFinanceApprovalList(
    //       apiUrl: financePOApiUrl, requestParams: {'USER_NAME': userName});
    // });
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                Dialogs.loader(context);
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
                  TabsButtonsWidget(
                    buttons: buttons,
                    selectedIndex: selectedButtonIndex,
                  ),
                  SizedBox(
                    height: context.resources.dimen.dp30,
                  ),
                  ValueListenableBuilder(
                      valueListenable: selectedButtonIndex,
                      builder: (context, value, widget) {
                        _servicesBloc.getFinanceApprovalList(
                            apiUrl: value == 0
                                ? financePOApiUrl
                                : value == 1
                                    ? financePRApiUrl
                                    : financeInvoiceApiUrl,
                            requestParams: {
                              'USER_NAME':
                                  value == 1 ? 'AHMED.ALALI' : 'KHALIFA.SAEED'
                            });
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
