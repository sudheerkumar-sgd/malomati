// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/domain/entities/base_entity.dart';

class AttendanceListEntity extends BaseEntity {
  List<AttendanceEntity> attendanceList = [];

  AttendanceListEntity();
  @override
  List<Object?> get props => [attendanceList];
}
