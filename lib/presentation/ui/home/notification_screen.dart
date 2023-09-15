// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/domain/entities/finance_approval_entity.dart';
import 'package:malomati/presentation/bloc/home/home_bloc.dart';
import 'package:malomati/presentation/ui/home/widgets/item_notifications.dart';

import '../../../injection_container.dart';
import '../utils/dialogs.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  final _homeBloc = sl<HomeBloc>();
  final ValueNotifier<List<FinanceApprovalEntity>> _notificationList =
      ValueNotifier([]);

  String userName = '';

  NotificationsScreen({super.key});

  _onActionClicked(String id, BuildContext context) {
    // final list = _notificationList.value;
    // final index = list.indexWhere((element) => element.nOTIFICATIONID == id);
    // list.removeAt(index);
    // _notificationList.value = [];
    // _notificationList.value = list;
    context.userDB.put(deletedNotificationKey,
        '${context.userDB.get(deletedNotificationKey, defaultValue: '')}#$id');
    final list = _notificationList.value
        .where((element) => !id.contains('${element.nOTIFICATIONID}'))
        .toList();
    _notificationList.value = list;
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => NotificationsScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    var noNotificationText = '';
    var resources = context.resources;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    Timer(const Duration(milliseconds: 50), () {
      _homeBloc.getNotificationsList(requestParams: {
        'USER_NAME': userName,
        'START_DATE': getDateByformat(
            'yyy-MM-dd', DateTime.now().subtract(const Duration(days: 7))),
        'END_DATE': getDateByformat('yyy-MM-dd', DateTime.now())
      });
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<HomeBloc>(
          create: (context) => _homeBloc,
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is OnLoading) {
                Dialogs.loader(context);
              } else if (state is OnNotificationsListSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                noNotificationText = context.string.noHrRequests;
                String deletedNotification = context.userDB
                    .get(deletedNotificationKey, defaultValue: '');
                final list = state.notificationsList
                    .where((element) => !deletedNotification
                        .contains('${element.nOTIFICATIONID}'))
                    .toList();
                _notificationList.value = list;
              } else if (state is OnApiError) {
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
                  BackAppBarWidget(title: context.string.notifications),
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
                                      ItemNotifications(
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
