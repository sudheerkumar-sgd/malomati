import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';

import '../../domain/entities/attendance_entity.dart';

// ignore: must_be_immutable
class AttendanceModel extends BaseModel {
  String? userid = "";
  String? username = "";
  String? processdate = "";

  String? punch1Time = "";
  String? punch2Time = "";

  AttendanceModel();

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    var attendanceJson = json['attendance-daily'][0];
    var attendanceModel = AttendanceModel();
    attendanceModel.userid = attendanceJson['userid'];
    attendanceModel.username = attendanceJson['username'];
    attendanceModel.processdate = attendanceJson['processdate'];
    attendanceModel.punch1Time = attendanceJson['punch1_time'];
    attendanceModel.punch2Time = attendanceJson['punch2_time'];
    return attendanceModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "userid": userid,
      };

  @override
  List<Object?> get props => [userid];

  @override
  BaseEntity toEntity<T>() {
    return AttendanceEntity();
  }
}

extension SourceModelExtension on AttendanceModel {
  AttendanceEntity toAttendanceEntity() {
    var attendanceEntity = AttendanceEntity();
    attendanceEntity.userid = userid;
    attendanceEntity.username = username;
    attendanceEntity.processdate = processdate;
    attendanceEntity.punch1Time = punch1Time;
    attendanceEntity.punch2Time = punch2Time;
    return attendanceEntity;
  }
}
