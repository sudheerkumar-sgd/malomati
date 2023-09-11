// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/presentation/ui/services/widgets/item_hr_approvals.dart';

import '../../../injection_container.dart';
import '../../bloc/services/services_bloc.dart';
import '../utils/dialogs.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class HrApprovalsScreen extends StatelessWidget {
  final _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<List<HrApprovalEntity>> _notificationList =
      ValueNotifier([]);

  String userName = '';

  HrApprovalsScreen({super.key});
  _onActionClicked(String id, BuildContext context) {
    // final list = _notificationList.value;
    // final index = list.indexWhere((element) => element.nOTIFICATIONID == id);
    // list.removeAt(index);
    // _notificationList.value = [];
    // _notificationList.value = list;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HrApprovalsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var noNotificationText = '';
    var resources = context.resources;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    Timer(const Duration(milliseconds: 50), () {
      _servicesBloc.getHrApprovalsList(requestParams: {'USER_NAME': userName});
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                Dialogs.loader(context);
              } else if (state is OnHrApprovalsListSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                noNotificationText = context.string.noHrRequests;
                _notificationList.value = state.hrApprovalsList;
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
                  BackAppBarWidget(title: context.string.hrApprovals),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: _notificationList,
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
                                      ItemHRApprovals(
                                        data: notificationList[index],
                                        callBack: _onActionClicked,
                                      ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: resources.dimen.dp20,
                                      ),
                                  itemCount: notificationList.length);
                        }),
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
