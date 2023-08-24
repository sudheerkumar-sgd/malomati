import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';

import '../../widgets/dashed_progress_indicator.dart';

class MyTeamAttendance extends StatelessWidget {
  const MyTeamAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    var percentage = 90 / 100;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: DashedProgressIndicator(
                  percent: percentage,
                  strokeWidth: resources.dimen.dp15,
                  color: percentage == 1
                      ? resources.color.colorGreen26B757
                      : resources.color.bgGradientStart),
              size: const Size(200, 200),
            ),
            Text(
              '${(percentage * 100).round()}%',
              style: context.textFontWeight600.onFontSize(35),
            ),
          ],
        ),
        SizedBox(
          height: resources.dimen.dp20,
        ),
        Text(
          context.string.teamStatusText,
          style: context.textFontWeight400.onFontSize(resources.dimen.dp15),
        ),
        SizedBox(
          height: resources.dimen.dp5,
        ),
        Text(
          getCurrentDateByformat('dd/MM/yyyy'),
          style: context.textFontWeight400
              .onFontSize(resources.dimen.dp15)
              .onColor(resources.color.bgGradientStart),
        ),
        SizedBox(
          height: resources.dimen.dp30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.string.numberOfEmployee,
              style: context.textFontWeight400.onFontSize(resources.dimen.dp15),
            ),
            Text(
              '90',
              style: context.textFontWeight600.onFontSize(resources.dimen.dp15),
            ),
          ],
        ),
        SizedBox(
          height: resources.dimen.dp15,
        ),
        Divider(
          height: resources.dimen.dp1,
          color: resources.color.bottomSheetIconUnSelected,
        ),
        SizedBox(
          height: resources.dimen.dp15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.string.employeesOnLeaves,
              style: context.textFontWeight400.onFontSize(resources.dimen.dp15),
            ),
            Text(
              '10',
              style: context.textFontWeight600.onFontSize(resources.dimen.dp15),
            ),
          ],
        ),
        SizedBox(
          height: resources.dimen.dp15,
        ),
        Divider(
          height: resources.dimen.dp1,
          color: resources.color.bottomSheetIconUnSelected,
        ),
        SizedBox(
          height: resources.dimen.dp15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.string.teamAttendanceReport,
              style: context.textFontWeight400.onFontSize(resources.dimen.dp15),
            ),
            Text(
              context.string.view,
              style: context.textFontWeight600
                  .onFontSize(resources.dimen.dp12)
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ],
        ),
      ],
    );
  }
}
