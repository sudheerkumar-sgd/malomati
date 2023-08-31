// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/services/widgets/leaves_form.dart';
import 'package:malomati/presentation/ui/services/widgets/myteam_attendance.dart';
import 'package:malomati/presentation/ui/widgets/tab_buttons_widget.dart';
import 'package:malomati/res/resources.dart';
import '../widgets/back_app_bar.dart';

class MyTeamScreen extends StatelessWidget {
  static const String route = '/MyTeamScreen';
  MyTeamScreen({super.key});
  late Resources resources;
  ValueNotifier<int> selectedButtonIndex = ValueNotifier<int>(0);
  List<String> buttons = [];
  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    buttons = [context.string.attendanceRate, context.string.createAbsence];
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: Container(
          margin: EdgeInsets.symmetric(
              vertical: context.resources.dimen.dp20,
              horizontal: context.resources.dimen.dp25),
          child: Column(
            children: [
              SizedBox(
                height: context.resources.dimen.dp10,
              ),
              BackAppBarWidget(title: context.string.myTeam),
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
                    return value == 0
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: MyTeamAttendance(),
                            ),
                          )
                        : Expanded(
                            child:
                                LeavesForm(leaveType: LeaveType.createLeave));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
