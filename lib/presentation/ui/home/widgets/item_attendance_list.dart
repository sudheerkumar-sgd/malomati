import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

enum AttendanceStatus {
  weekOff('Week Off'),
  present('Present'),
  absent('Absent');

  final name;
  const AttendanceStatus(this.name);
}

class ItemAttendanceList extends StatelessWidget {
  final ValueNotifier _isExpanded = ValueNotifier<bool>(false);
  final AttendanceEntity attendanceEntity;
  ItemAttendanceList({required this.attendanceEntity, super.key});
  AttendanceStatus _getAttendanceStatus() {
    var caseText =
        '${attendanceEntity.firsthalf}${attendanceEntity.secondhalf}';
    switch (caseText) {
      case "WOWO":
        return AttendanceStatus.weekOff;
      case "PRPR" || "PRIN" || "INPR":
        return AttendanceStatus.present;
      default:
        return AttendanceStatus.absent;
    }
  }

  String _getDepartmentLocation() {
    return getDepartmentsLocation(
        double.parse(attendanceEntity.gpsLatitude ?? ''),
        double.parse(attendanceEntity.gpsLongitude ?? ''));
  }

  Widget _getAttendanceLog(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      children: [
        if ((attendanceEntity.punch1Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                'Reg In:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp5,
            ),
            TableCell(
              child: Text(
                '${attendanceEntity.punch1Time}',
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch2Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                'Reg Out:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp5,
            ),
            TableCell(
              child: Text(
                '${attendanceEntity.punch2Time}',
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch3Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                'Reg In:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp5,
            ),
            TableCell(
              child: Text(
                '${attendanceEntity.punch3Time}',
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch4Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                'Reg Out:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp5,
            ),
            TableCell(
              child: Text(
                '${attendanceEntity.punch4Time}',
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch5Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                'Reg In:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp5,
            ),
            TableCell(
              child: Text(
                '${attendanceEntity.punch5Time}',
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch6Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                'Reg Out:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp5,
            ),
            TableCell(
              child: Text(
                '${attendanceEntity.punch6Time}',
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch7Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                'Reg In:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp5,
            ),
            TableCell(
              child: Text(
                '${attendanceEntity.punch7Time}',
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch8Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                'Reg Out:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp5,
            ),
            TableCell(
              child: Text(
                '${attendanceEntity.punch8Time}',
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch9Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                'Reg In:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp5,
            ),
            TableCell(
              child: Text(
                '${attendanceEntity.punch9Time}',
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch10Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                'Reg Out:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp5,
            ),
            TableCell(
              child: Text(
                '${attendanceEntity.punch10Time}',
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.dimen.dp11),
              ),
            )
          ])
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    attendanceEntity.departmentLocation = _getDepartmentLocation();
    return ValueListenableBuilder(
        valueListenable: _isExpanded,
        builder: (context, isExpaned, widget) {
          return InkWell(
            onTap: () {
              _isExpanded.value = !isExpaned;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              margin:
                  EdgeInsets.symmetric(horizontal: context.resources.dimen.dp5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: ShapeDecoration(
                            shape: const CircleBorder(),
                            color: _getAttendanceStatus() ==
                                    AttendanceStatus.absent
                                ? context.resources.color.colorD32030
                                : context.resources.color.colorGreen26B757),
                      ),
                      SizedBox(
                        width: context.resources.dimen.dp8,
                      ),
                      Expanded(
                        child: Text(
                          attendanceEntity.processdate ?? '',
                          style: context.textFontWeight400
                              .onColor(context.resources.color.textColor)
                              .onFontSize(context.resources.dimen.dp12),
                        ),
                      ),
                      ImageWidget(
                              path: isExpaned
                                  ? DrawableAssets.icChevronUp
                                  : DrawableAssets.icChevronDown)
                          .loadImage
                    ],
                  ),
                  Visibility(
                    visible: isExpaned,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: context.resources.dimen.dp15,
                          top: context.resources.dimen.dp8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getAttendanceStatus().name,
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                  SizedBox(
                                    height: context.resources.dimen.dp5,
                                  ),
                                  Text(
                                    attendanceEntity.departmentLocation ?? '',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                ],
                              ),
                              _getAttendanceLog(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
