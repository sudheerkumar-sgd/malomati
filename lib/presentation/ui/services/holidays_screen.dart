// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/presentation/ui/guest/guest_back_app_bar.dart';
import 'package:malomati/presentation/ui/services/widgets/item_events.dart';

import '../../../injection_container.dart';
import '../../bloc/services/services_bloc.dart';
import '../utils/dialogs.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class HolidaysScreen extends StatelessWidget {
  final _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<List<EventsEntity>> _notificationList = ValueNotifier([]);

  String userName = '';

  HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var noNotificationText = '';
    var resources = context.resources;
    Timer(const Duration(milliseconds: 50), () {
      _servicesBloc.getHolidayEvents(requestParams: {
        'START_DATE': '${DateTime.now().year}-01-01',
        'END_DATE': '${DateTime.now().year}-12-31'
      });
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
              } else if (state is OnHolidayEventsSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                noNotificationText = context.string.noHrRequests;
                _notificationList.value = state.holidayEvents;
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
                  context.userDB.get(isGuestKey, defaultValue: false)
                      ? GuestBackAppBarWidget(title: context.string.holidays)
                      : BackAppBarWidget(title: context.string.holidays),
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
                                  itemBuilder: (context, index) => ItemEvents(
                                        data: notificationList[index],
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
