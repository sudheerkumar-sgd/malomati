// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:malomati/presentation/bloc/requests/requests_bloc.dart';
import 'package:malomati/presentation/ui/home/widgets/item_attendance_list.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_leaves.dart';
import 'package:malomati/presentation/ui/home/widgets/item_requests_list.dart';
import '../../../injection_container.dart';
import '../../../res/drawables/background_box_decoration.dart';
import '../widgets/services_app_bar.dart';

enum SelectedListType {
  attendance,
  requests,
}

class RequestsScreen extends StatelessWidget {
  final _attendanceBloc = sl<AttendanceBloc>();
  final _requestsBloc = sl<RequestsBloc>();
  final ValueNotifier _selectedListType =
      ValueNotifier<SelectedListType>(SelectedListType.attendance);
  ScrollController controller = ScrollController();
  RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now(); //.subtract(const Duration(days: 1));
    var dateCurrent = DateFormat('ddMMyyyy').format(date);
    var dateStart =
        DateFormat('ddMMyyyy').format(DateTime(date.year, date.month, 1));
    Map<String, dynamic> attendanceRequestParams = {
      'date-range': '$dateStart-$dateCurrent',
    };
    _attendanceBloc.getAttendance(requestParams: attendanceRequestParams);
    _attendanceBloc.getAttendanceDetails(
        dateRange: '${dateStart}000000-${dateCurrent}235959');
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<RequestsBloc>(
          create: (context) => _requestsBloc,
          child: BlocListener<RequestsBloc, RequestsState>(
            listener: (context, state) {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.resources.dimen.dp10,
                ),
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: context.resources.dimen.dp20,
                        horizontal: context.resources.dimen.dp25),
                    child:
                        ServicesAppBarWidget(title: context.string.requests)),
                Row(
                  children: [
                    Expanded(
                      child: ItemDashboardLeaves(
                        balanceCount: '25',
                        balancetype: context.string.approved,
                        padding: context.resources.dimen.dp20,
                      ),
                    ),
                    Expanded(
                      child: ItemDashboardLeaves(
                        balanceCount: '10',
                        balancetype: context.string.pending,
                        padding: context.resources.dimen.dp20,
                      ),
                    ),
                    Expanded(
                      child: ItemDashboardLeaves(
                        balanceCount: '0',
                        balancetype: context.string.rejected,
                        padding: context.resources.dimen.dp20,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: context.resources.dimen.dp25,
                    right: context.resources.dimen.dp25,
                    bottom: context.resources.dimen.dp12,
                  ),
                  child: Text(
                    context.string.historyLogs,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: context.textFontWeight600
                        .onColor(context.resources.color.textColor)
                        .onFontSize(context.resources.fontSize.dp17),
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: _selectedListType,
                    builder: (context, listType, widget) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: context.resources.dimen.dp25),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: double.infinity,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        _selectedListType.value =
                                            SelectedListType.attendance;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                context.resources.dimen.dp8,
                                            horizontal:
                                                context.resources.dimen.dp10),
                                        decoration: BackgroundBoxDecoration(
                                          boxColor: listType ==
                                                  SelectedListType.attendance
                                              ? context.resources.color
                                                  .viewBgColorLight
                                              : context
                                                  .resources.color.colorF5C3C3,
                                          radious: context.resources.dimen.dp25,
                                        ).roundedCornerBox,
                                        child: Text(
                                          context.string.attendance,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textFontWeight600
                                              .onColor(context
                                                  .resources.color.colorWhite)
                                              .onFontSize(context
                                                  .resources.fontSize.dp17),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: context.resources.dimen.dp20,
                                ),
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: double.infinity,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        _selectedListType.value =
                                            SelectedListType.requests;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                context.resources.dimen.dp8,
                                            horizontal:
                                                context.resources.dimen.dp10),
                                        decoration: BackgroundBoxDecoration(
                                          boxColor: listType ==
                                                  SelectedListType.requests
                                              ? context.resources.color
                                                  .viewBgColorLight
                                              : context
                                                  .resources.color.colorF5C3C3,
                                          radious: context.resources.dimen.dp25,
                                        ).roundedCornerBox,
                                        child: Text(
                                          context.string.requests,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textFontWeight600
                                              .onColor(context
                                                  .resources.color.colorWhite)
                                              .onFontSize(context
                                                  .resources.fontSize.dp17),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: context.resources.dimen.dp10,
                            ),
                          ],
                        ),
                      );
                    }),
                ValueListenableBuilder(
                    valueListenable: _selectedListType,
                    builder: (context, value, widget) {
                      return Expanded(
                        child: Container(
                          margin: context.resources.isLocalEn
                              ? EdgeInsets.only(
                                  right: context.resources.dimen.dp20)
                              : EdgeInsets.only(
                                  left: context.resources.dimen.dp20),
                          child: Scrollbar(
                            controller: controller,
                            thumbVisibility: true,
                            trackVisibility: true,
                            child: (_selectedListType.value ==
                                    SelectedListType.attendance)
                                ? StreamBuilder(
                                    stream: _attendanceBloc.getAttendanceReport,
                                    builder: (context, snapshot) {
                                      return ListView.separated(
                                          itemCount: snapshot.data?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            return ItemAttendanceList(
                                              attendanceEntity:
                                                  snapshot.data![index],
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: context
                                                        .resources.dimen.dp25),
                                                color: context.resources.color
                                                    .colorD6D6D6,
                                                height: 0.5,
                                              ));
                                    })
                                : ListView.separated(
                                    itemCount: 100,
                                    itemBuilder: (context, index) {
                                      return ItemRequestsList();
                                    },
                                    separatorBuilder: (context, index) =>
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  context.resources.dimen.dp25),
                                          color: context
                                              .resources.color.colorD6D6D6,
                                          height: 0.5,
                                        )),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
