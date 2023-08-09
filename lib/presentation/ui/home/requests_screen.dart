import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/home/widgets/item_attendance_list.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_leaves.dart';
import 'package:malomati/presentation/ui/home/widgets/item_requests_list.dart';

import '../../../res/drawables/background_box_decoration.dart';
import '../widgets/services_app_bar.dart';

enum SelectedListType {
  attendance,
  requests,
}

class RequestsScreen extends StatelessWidget {
  final ValueNotifier _selectedListType =
      ValueNotifier<SelectedListType>(SelectedListType.attendance);
  RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.resources.dimen.dp10,
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    vertical: context.resources.dimen.dp20,
                    horizontal: context.resources.dimen.dp25),
                child: ServicesAppBarWidget(title: context.string.requests)),
            GridView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: context.resources.dimen.dp25,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: context.resources.dimen.dp10,
              ),
              itemBuilder: (ctx, i) {
                switch (i) {
                  case 0:
                    {
                      return ItemDashboardLeaves(
                        balanceCount: '25',
                        balancetype: context.string.approved,
                        padding: context.resources.dimen.dp20,
                      );
                    }
                  case 1:
                    {
                      return ItemDashboardLeaves(
                        balanceCount: '10',
                        balancetype: context.string.pending,
                        padding: context.resources.dimen.dp20,
                      );
                    }
                  default:
                    {
                      return ItemDashboardLeaves(
                        balanceCount: '0',
                        balancetype: context.string.rejected,
                        padding: context.resources.dimen.dp20,
                      );
                    }
                }
              },
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
                    .onFontSize(context.resources.dimen.dp17),
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
                                        vertical: context.resources.dimen.dp8,
                                        horizontal:
                                            context.resources.dimen.dp10),
                                    decoration: BackgroundBoxDecoration(
                                      boxColor: listType ==
                                              SelectedListType.attendance
                                          ? context
                                              .resources.color.viewBgColorLight
                                          : context.resources.color.colorF5C3C3,
                                      radious: context.resources.dimen.dp25,
                                    ).roundedCornerBox,
                                    child: Text(
                                      context.string.attendance,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textFontWeight600
                                          .onColor(context
                                              .resources.color.colorWhite)
                                          .onFontSize(
                                              context.resources.dimen.dp17),
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
                                        vertical: context.resources.dimen.dp8,
                                        horizontal:
                                            context.resources.dimen.dp10),
                                    decoration: BackgroundBoxDecoration(
                                      boxColor: listType ==
                                              SelectedListType.requests
                                          ? context
                                              .resources.color.viewBgColorLight
                                          : context.resources.color.colorF5C3C3,
                                      radious: context.resources.dimen.dp25,
                                    ).roundedCornerBox,
                                    child: Text(
                                      context.string.requests,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textFontWeight600
                                          .onColor(context
                                              .resources.color.colorWhite)
                                          .onFontSize(
                                              context.resources.dimen.dp17),
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
                builder: (context, listType, widget) {
                  return Expanded(
                    child: Container(
                      margin: context.resources.isLocalEn
                          ? EdgeInsets.only(right: context.resources.dimen.dp20)
                          : EdgeInsets.only(left: context.resources.dimen.dp20),
                      child: Scrollbar(
                        controller: _controller,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: (_selectedListType.value ==
                                SelectedListType.attendance)
                            ? ListView.separated(
                                itemCount: 300,
                                itemBuilder: (context, index) {
                                  return ItemAttendanceList();
                                },
                                separatorBuilder: (context, index) => Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              context.resources.dimen.dp25),
                                      color:
                                          context.resources.color.colorD6D6D6,
                                      height: 0.5,
                                    ))
                            : ListView.separated(
                                itemCount: 100,
                                itemBuilder: (context, index) {
                                  return ItemRequestsList();
                                },
                                separatorBuilder: (context, index) => Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              context.resources.dimen.dp25),
                                      color:
                                          context.resources.color.colorD6D6D6,
                                      height: 0.5,
                                    )),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
