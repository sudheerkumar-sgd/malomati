import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

enum AttendanceStatus {
  weekOff('Week Off', Color(0xffEB920C)),
  present('Present', Color(0xff26B757)),
  absent('Absent', Color(0xffD32030));

  final String name;
  final Color color;
  const AttendanceStatus(this.name, this.color);
}

class ItemAttendanceList extends StatelessWidget {
  final ValueNotifier _isExpanded = ValueNotifier<bool>(false);
  final AttendanceEntity attendanceEntity;
  ItemAttendanceList({required this.attendanceEntity, super.key});
  AttendanceStatus? _getAttendanceStatus() {
    var caseText =
        '${attendanceEntity.firsthalf}${attendanceEntity.secondhalf}';
    var dateParams = (attendanceEntity.processdate ?? '').split('/');
    var dayOfMonth = getDateByformat(
        'EEEE',
        DateTime(int.parse(dateParams[2]), int.parse(dateParams[1]),
            int.parse(dateParams[0])));
    if (dayOfMonth == 'Saturday' || dayOfMonth == 'Sunday') {
      return AttendanceStatus.weekOff;
    }
    switch (caseText) {
      case "WOWO":
        return AttendanceStatus.weekOff;
      case "PRPR" || "PRIN" || "INPR":
        return AttendanceStatus.present;
      case "ABAB" || "ABIN" || "INAB" || "IN" || "PR" || "AB" || "":
        return AttendanceStatus.absent;
      default:
        return null;
    }
  }

  String _getAttendanceStatusName(
      BuildContext context, AttendanceStatus? status) {
    switch (status) {
      case AttendanceStatus.absent:
        return context.string.absent;
      case AttendanceStatus.present:
        return context.string.present;
      default:
        return context.string.weekOff;
    }
  }

  Map _getDepartmentLocation() {
    printLog(message: attendanceEntity.toString());
    if ((attendanceEntity.gpsLatitude ?? '').isNotEmpty) {
      return getDepartmentByLocation(
          double.parse(attendanceEntity.gpsLatitude ?? '0.0'),
          double.parse(attendanceEntity.gpsLongitude ?? '0.0'));
    } else {
      return {};
    }
  }

  String _getPunchType(BuildContext context, String spfid) {
    switch (spfid) {
      case '1':
        return context.string.officialIn;
      case '2':
        return context.string.officialOut;
      case '3':
        return context.string.shortLeaveIn;
      case '4':
        return context.string.shortLeaveOut;
      case '5':
        return context.string.regularIn;
      case '6':
        return context.string.regularOut;
      case '7':
        return context.string.lunchIn;
      case '8':
        return context.string.lunchOut;
      case '9':
        return context.string.overtimeIn;
      case '10':
        return context.string.overtimeOut;
      default:
        return context.string.regularIn;
    }
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
                '${_getPunchType(context, attendanceEntity.spfid1 ?? '5')}:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.fontSize.dp11),
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
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .onFontSize(context.resources.fontSize.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch2Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                '${_getPunchType(context, (attendanceEntity.spfid2 ?? '').isNotEmpty ? attendanceEntity.spfid2 ?? '' : '6')}:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.fontSize.dp11),
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
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .onFontSize(context.resources.fontSize.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch3Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                '${_getPunchType(context, attendanceEntity.spfid3 ?? '')}:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.fontSize.dp11),
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
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .onFontSize(context.resources.fontSize.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch4Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                '${_getPunchType(context, attendanceEntity.spfid4 ?? '')}:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.fontSize.dp11),
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
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .onFontSize(context.resources.fontSize.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch5Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                '${_getPunchType(context, attendanceEntity.spfid5 ?? '')}:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.fontSize.dp11),
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
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .onFontSize(context.resources.fontSize.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch6Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                '${_getPunchType(context, attendanceEntity.spfid6 ?? '')}:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.fontSize.dp11),
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
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .onFontSize(context.resources.fontSize.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch7Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                '${_getPunchType(context, attendanceEntity.spfid7 ?? '')}:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.fontSize.dp11),
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
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .onFontSize(context.resources.fontSize.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch8Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                '${_getPunchType(context, attendanceEntity.spfid8 ?? '')}:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.fontSize.dp11),
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
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .onFontSize(context.resources.fontSize.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch9Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                '${_getPunchType(context, attendanceEntity.spfid9 ?? '')}:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.fontSize.dp11),
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
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .onFontSize(context.resources.fontSize.dp11),
              ),
            )
          ])
        ],
        if ((attendanceEntity.punch10Time?.isNotEmpty ?? false)) ...[
          TableRow(children: [
            TableCell(
              child: Text(
                '${_getPunchType(context, attendanceEntity.spfid10 ?? '')}:',
                textAlign: TextAlign.right,
                style: context.textFontWeight400
                    .onColor(context.resources.color.textColor212B4B)
                    .onFontSize(context.resources.fontSize.dp11),
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
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .onFontSize(context.resources.fontSize.dp11),
              ),
            )
          ])
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    attendanceEntity.departmentLocation = _getDepartmentLocation()['name'];
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
                            color: _getAttendanceStatus()?.color),
                      ),
                      SizedBox(
                        width: context.resources.dimen.dp8,
                      ),
                      Expanded(
                        child: Text(
                          attendanceEntity.processdate ?? '',
                          style: context.textFontWeight400
                              .onColor(context.resources.color.textColor)
                              .onFontFamily(fontFamily: fontFamilyEN)
                              .onFontSize(context.resources.fontSize.dp12),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: _getAttendanceStatus() != null,
                                    child: Text(
                                      _getAttendanceStatusName(
                                          context, _getAttendanceStatus()),
                                      style: context.textFontWeight400
                                          .onColor(context
                                              .resources.color.textColor212B4B)
                                          .onFontSize(
                                              context.resources.fontSize.dp11),
                                    ),
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
                                            context.resources.fontSize.dp11),
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
