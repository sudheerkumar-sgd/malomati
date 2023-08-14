import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';

import '../../domain/entities/attendance_entity.dart';

// ignore: must_be_immutable
class AttendanceModel extends BaseModel {
  String? userid = "";
  String? username = "";
  String? processdate = "";
  String? firsthalf = "";
  String? secondhalf = "";
  String? gpsLatitude = "";
  String? gpsLongitude = "";
  String? punch1Time = "";
  String? punch2Time = "";
  String? punch3Time = "";
  String? punch4Time = "";
  String? punch5Time = "";
  String? punch6Time = "";
  String? punch7Time = "";
  String? punch8Time = "";
  String? punch9Time = "";
  String? punch10Time = "";
  String? spfid1 = "";
  String? spfid2 = "";
  String? spfid3 = "";
  String? spfid4 = "";
  String? spfid5 = "";
  String? spfid6 = "";
  String? spfid7 = "";
  String? spfid8 = "";
  String? spfid9 = "";
  String? spfid10 = "";

  AttendanceModel();

  factory AttendanceModel.fromJson(Map<String, dynamic> attendanceJson) {
    var attendanceModel = AttendanceModel();
    attendanceModel.userid = attendanceJson['userid'];
    attendanceModel.username = attendanceJson['username'];
    attendanceModel.processdate = attendanceJson['processdate'];
    attendanceModel.firsthalf = attendanceJson['firsthalf'];
    attendanceModel.secondhalf = attendanceJson['secondhalf'];
    attendanceModel.gpsLatitude = attendanceJson['gps_latitude'];
    attendanceModel.gpsLongitude = attendanceJson['gps_longitude'];
    attendanceModel.punch1Time = attendanceJson['punch1_time'];
    attendanceModel.punch2Time = attendanceJson['punch2_time'];
    attendanceModel.punch3Time = attendanceJson['punch3_time'];
    attendanceModel.punch4Time = attendanceJson['punch4_time'];
    attendanceModel.punch5Time = attendanceJson['punch5_time'];
    attendanceModel.punch6Time = attendanceJson['punch6_time'];
    attendanceModel.punch7Time = attendanceJson['punch7_time'];
    attendanceModel.punch8Time = attendanceJson['punch8_time'];
    attendanceModel.punch9Time = attendanceJson['punch9_time'];
    attendanceModel.punch10Time = attendanceJson['punch10_time'];
    attendanceModel.spfid1 = attendanceJson['SPFID1'];
    attendanceModel.spfid2 = attendanceJson['SPFID2'];
    attendanceModel.spfid3 = attendanceJson['SPFID3'];
    attendanceModel.spfid4 = attendanceJson['SPFID4'];
    attendanceModel.spfid5 = attendanceJson['SPFID5'];
    attendanceModel.spfid6 = attendanceJson['SPFID6'];
    attendanceModel.spfid7 = attendanceJson['SPFID7'];
    attendanceModel.spfid8 = attendanceJson['SPFID8'];
    attendanceModel.spfid9 = attendanceJson['SPFID9'];
    attendanceModel.spfid10 = attendanceJson['SPFID10'];
    return attendanceModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "userid": userid,
      };

  @override
  List<Object?> get props => [userid, processdate];

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
    attendanceEntity.firsthalf = firsthalf;
    attendanceEntity.secondhalf = secondhalf;
    attendanceEntity.punch1Time = punch1Time;
    attendanceEntity.punch2Time = punch2Time;
    attendanceEntity.gpsLatitude = gpsLatitude;
    attendanceEntity.gpsLongitude = gpsLongitude;
    return attendanceEntity;
  }
}
