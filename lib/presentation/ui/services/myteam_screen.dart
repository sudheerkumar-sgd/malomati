import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/services/widgets/leaves_form.dart';
import 'package:malomati/presentation/ui/services/widgets/myteam_attendance.dart';
import 'package:malomati/presentation/ui/widgets/tab_buttons_widget.dart';
import '../widgets/back_app_bar.dart';

class MyTeamScreen extends StatefulWidget {
  static const String route = '/MyTeamScreen';
  const MyTeamScreen({super.key});

  @override
  State<MyTeamScreen> createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends State<MyTeamScreen> {
  final ValueNotifier<int> selectedButtonIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    selectedButtonIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      {'name': context.string.attendanceRate},
      {'name': context.string.createAbsence},
    ];
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
                onTabSelected: selectedButtonIndex,
              ),
              SizedBox(
                height: context.resources.dimen.dp30,
              ),
              ValueListenableBuilder(
                  valueListenable: selectedButtonIndex,
                  builder: (context, value, child) {
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
