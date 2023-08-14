import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/attendance_list_entity.dart';
import 'attendance_model.dart';

// ignore: must_be_immutable
class AttendanceListModel extends BaseModel {
  List<AttendanceEntity> attendanceDaily = [];

  AttendanceListModel();

  factory AttendanceListModel.fromJson(Map<String, dynamic> json) {
    var attendanceJsonList = [];
    if (json['attendance-daily'] != null) {
      attendanceJsonList = json['attendance-daily'] as List;
    } else if (json['event-ta-date'] != null) {
      attendanceJsonList = json['event-ta-date'] as List;
    }

    final attendanceList = attendanceJsonList
        .map((attendanceJson) =>
            AttendanceModel.fromJson(attendanceJson).toAttendanceEntity())
        .toList();
    var attendanceListModel = AttendanceListModel();
    attendanceListModel.attendanceDaily = attendanceList;
    return attendanceListModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "attendance_daily": attendanceDaily,
      };

  @override
  List<Object?> get props => [attendanceDaily];

  @override
  BaseEntity toEntity<T>() {
    return AttendanceEntity();
  }
}

extension SourceModelExtension on AttendanceListModel {
  AttendanceListEntity toAttendanceList() {
    AttendanceListEntity attendanceListEntity = AttendanceListEntity();
    attendanceListEntity.attendanceList = attendanceDaily;
    return attendanceListEntity;
  }
}
