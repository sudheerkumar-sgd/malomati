// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/domain/entities/warning_list_entity.dart';
import 'package:malomati/presentation/bloc/home/home_bloc.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/item_warnings.dart';

import '../../../injection_container.dart';
import '../utils/dialogs.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class ViewWarningsScreen extends StatelessWidget {
  final _serviceBloc = sl<ServicesBloc>();
  final ValueNotifier<List<WarningListEntity>> _warningsList =
      ValueNotifier([]);

  String userName = '';

  ViewWarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var noNotificationText = '';
    var resources = context.resources;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    Timer(const Duration(milliseconds: 50), () {
      _serviceBloc.getHrApprovalDetails(requestParams: {
        'USER_NAME': userName,
        'START_DATE': getDateByformat(
            'yyy-MM-dd', DateTime.now().subtract(const Duration(days: 2))),
        'END_DATE': getDateByformat(
            'yyy-MM-dd', DateTime.now().add(const Duration(days: 1)))
      });
    });
    _warningsList.value = [
      WarningListEntity(),
      WarningListEntity(),
      WarningListEntity()
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _serviceBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnLoading) {
                Dialogs.loader(context);
              } else if (state is OnNotificationsListSuccess) {
              } else if (state is OnServicesError) {
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
                  BackAppBarWidget(title: context.string.warnings),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: _warningsList,
                        builder: (context, notificationList, child) {
                          return (notificationList.isEmpty)
                              ? noNotificationText.isNotEmpty
                                  ? Center(
                                      child: Text(
                                        noNotificationText,
                                        style: context.textFontWeight600,
                                      ),
                                    )
                                  : const Center(
                                      child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: CircularProgressIndicator()))
                              : ListView.separated(
                                  controller: ScrollController(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) => ItemWarnings(
                                        data: WarningListEntity(),
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
