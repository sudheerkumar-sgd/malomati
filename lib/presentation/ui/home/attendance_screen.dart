// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';

import '../../../res/drawables/background_box_decoration.dart';
import '../../../res/drawables/drawable_assets.dart';
import '../../../res/resources.dart';
import '../widgets/back_app_bar.dart';

enum AttendanceType {
  punchIn,
  punchOut,
}

class AttendanceScreen extends StatelessWidget {
  final AttendanceType attendanceType;
  late Resources resources;
  final ValueNotifier _timeString =
      ValueNotifier<String>(getCurrentDateByformat('hh:mm:ss aa'));
  List<String> attendanceOptions = [];
  AttendanceScreen({required this.attendanceType, super.key});
  void _setTime() {
    _timeString.value = getCurrentDateByformat('hh:mm:ss aa');
  }

  List<String> _getAttendanceOptions(BuildContext context) {
    if (attendanceType == AttendanceType.punchIn) {
      return [
        context.string.regularIn,
        context.string.officialWorkIn,
        context.string.overtimeIn,
        context.string.shortLeaveIn
      ];
    } else {
      return [
        context.string.regularOut,
        context.string.officialWorkOut,
        context.string.overtimeOut,
        context.string.shortLeaveOut
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    startTimer(duration: 1, callback: _setTime);
    attendanceOptions = _getAttendanceOptions(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: resources.color.appScaffoldBg,
            body: Container(
                margin: EdgeInsets.symmetric(
                    vertical: resources.dimen.dp20,
                    horizontal: resources.dimen.dp25),
                child: Column(
                  children: [
                    SizedBox(
                      height: resources.dimen.dp10,
                    ),
                    BackAppBarWidget(title: context.string.timeAttendance),
                    SizedBox(
                      height: resources.dimen.dp25,
                    ),
                    ImageWidget(
                            path: DrawableAssets.icMap, boxType: BoxFit.fill)
                        .loadImage,
                    SizedBox(
                      height: resources.dimen.dp25,
                    ),
                    Text(
                      getCurrentDateByformat('EEE, dd MMMM yyyy'),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: context.textFontWeight600
                          .onColor(context.resources.color.textColor)
                          .onFontSize(context.resources.dimen.dp17),
                    ),
                    SizedBox(
                      height: resources.dimen.dp5,
                    ),
                    ValueListenableBuilder(
                        valueListenable: _timeString,
                        builder: (context, value, widget) {
                          return Text(
                            value,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: context.textFontWeight400
                                .onColor(context.resources.color.textColor)
                                .onFontSize(context.resources.dimen.dp13),
                          );
                        }),
                    SizedBox(
                      height: resources.dimen.dp5,
                    ),
                    Text(
                      'Location: ',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: context.textFontWeight400
                          .onColor(context.resources.color.textColor)
                          .onFontSize(context.resources.dimen.dp13),
                    ),
                    SizedBox(
                      height: resources.dimen.dp30,
                    ),
                    for (var option in attendanceOptions) ...[
                      Container(
                        width: 155,
                        margin: EdgeInsets.only(bottom: resources.dimen.dp20),
                        padding: EdgeInsets.symmetric(
                            vertical: context.resources.dimen.dp8,
                            horizontal: context.resources.dimen.dp10),
                        decoration: BackgroundBoxDecoration(
                          boxColor: resources.color.viewBgColorLight,
                          radious: context.resources.dimen.dp10,
                        ).roundedCornerBox,
                        child: Text(
                          option,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: context.textFontWeight400
                              .onColor(context.resources.color.colorWhite)
                              .onFontSize(context.resources.dimen.dp14),
                        ),
                      ),
                    ]
                  ],
                ))));
  }
}
