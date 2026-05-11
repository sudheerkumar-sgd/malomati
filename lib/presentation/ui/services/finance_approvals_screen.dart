// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/network/api_urls.dart';
import 'package:malomati/domain/entities/finance_approval_entity.dart';
import 'package:malomati/presentation/ui/services/widgets/item_finance_inv_approvals.dart';
import 'package:malomati/presentation/ui/services/widgets/item_finance_payroll_approvals.dart';
import 'package:malomati/presentation/ui/services/widgets/item_finance_po_approvals.dart';
import 'package:malomati/presentation/ui/services/widgets/item_finance_pr_approvals.dart';
import 'package:malomati/presentation/ui/widgets/tab_buttons_widget.dart';
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

class FinanceApprovalsScreen extends StatefulWidget {
  static const String route = '/FinanceApprovalsScreen';
  final int index;
  const FinanceApprovalsScreen({this.index = 0, super.key});

  @override
  State<FinanceApprovalsScreen> createState() => _FinanceApprovalsScreenState();
}

class _FinanceApprovalsScreenState extends State<FinanceApprovalsScreen> {
  final _servicesBloc = sl<ServicesBloc>();
  late ValueNotifier<int> selectedButtonIndex;
  List<FinanceApprovalEntity> _financeNotificationList =
      List.empty(growable: true);
  final ValueNotifier<List<Map>> _buttons = ValueNotifier([]);
  String userName = '';
  String noNotificationText = '';
  bool _isSilentLoading = false;
  bool _isLoaderShowing = false;

  void _updateButtons() {
    _buttons.value = [
      {'name': 'PO', 'count': ConstantConfig.financePOApprovalCount},
      {'name': 'PR', 'count': ConstantConfig.financePRApprovalCount},
      {'name': 'Invoice', 'count': ConstantConfig.financeINVApprovalCount},
      {'name': 'Payroll', 'count': ConstantConfig.financePayrollApprovalCount},
    ];
  }

  @override
  void initState() {
    super.initState();
    selectedButtonIndex = ValueNotifier<int>(widget.index);
    selectedButtonIndex.addListener(_fetchData);
    _updateButtons();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userName = context.userDB.get(userNameKey, defaultValue: '');
      _fetchData();
      _fetchCounts();
    });
  }

  @override
  void dispose() {
    selectedButtonIndex.removeListener(_fetchData);
    selectedButtonIndex.dispose();
    _servicesBloc.close();
    _buttons.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    int value = selectedButtonIndex.value;
    setState(() {
      noNotificationText = '';
    });
    await _servicesBloc.getFinanceApprovalList(
        apiUrl: value == 0
            ? financePOApiUrl
            : value == 1
                ? financePRApiUrl
                : value == 2
                    ? financeInvoiceApiUrl
                    : payrollApiUrl,
        requestParams: {'USER_NAME': userName});
  }

  void _fetchCounts() {
    _servicesBloc.getRequestsCount(requestParams: {'USER_NAME': userName});
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

  _onActionClicked(String id, BuildContext context) {
    _fetchData();
    _fetchCounts();
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
                if (!_isSilentLoading) _showLoader(context);
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
                _updateButtons();
              } else if (state is OnFinanceApprovalsListSuccess) {
                if (!_isSilentLoading) _hideLoader(context);
                setState(() {
                  noNotificationText = context.string.noHrRequests;
                  _financeNotificationList =
                      List.from(state.financeApprovalsList);
                });
              } else if (state is OnServicesError) {
                if (!_isSilentLoading) _hideLoader(context);
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
                          onTabSelected: selectedButtonIndex,
                        );
                      }),
                  SizedBox(
                    height: context.resources.dimen.dp30,
                  ),
                  ValueListenableBuilder(
                      valueListenable: selectedButtonIndex,
                      builder: (context, value, widget) {
                        return Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              _isSilentLoading = true;
                              _fetchCounts();
                              await _fetchData();
                              _isSilentLoading = false;
                            },
                            child: (_financeNotificationList.isEmpty &&
                                    noNotificationText.isNotEmpty)
                                ? SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      alignment: Alignment.center,
                                      child: Text(
                                        noNotificationText,
                                        style: context.textFontWeight600,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => value == 0
                                        ? ItemFinancePOApprovals(
                                            key: ValueKey(
                                                _financeNotificationList[index]
                                                    .nOTIFICATIONID),
                                            data:
                                                _financeNotificationList[index],
                                            callBack: _onActionClicked,
                                          )
                                        : value == 1
                                            ? ItemFinancePRApprovals(
                                                key: ValueKey(
                                                    _financeNotificationList[
                                                            index]
                                                        .nOTIFICATIONID),
                                                data: _financeNotificationList[
                                                    index],
                                                callBack: _onActionClicked,
                                              )
                                            : value == 2
                                                ? ItemFinanceInvApprovals(
                                                    key: ValueKey(
                                                        _financeNotificationList[
                                                                index]
                                                            .nOTIFICATIONID),
                                                    data:
                                                        _financeNotificationList[
                                                            index],
                                                    callBack: _onActionClicked,
                                                  )
                                                : ItemFinancePayrollApprovals(
                                                    key: ValueKey(
                                                        _financeNotificationList[
                                                                index]
                                                            .nOTIFICATIONID),
                                                    data:
                                                        _financeNotificationList[
                                                            index],
                                                    callBack: _onActionClicked,
                                                  ),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: resources.dimen.dp20,
                                        ),
                                    itemCount: _financeNotificationList.length),
                          ),
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
