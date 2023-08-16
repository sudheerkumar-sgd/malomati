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
    attendanceModel.spfid1 = attendanceJson['spfid1'];
    attendanceModel.spfid2 = attendanceJson['spfid2'];
    attendanceModel.spfid3 = attendanceJson['spfid3'];
    attendanceModel.spfid4 = attendanceJson['spfid4'];
    attendanceModel.spfid5 = attendanceJson['spfid5'];
    attendanceModel.spfid6 = attendanceJson['spfid6'];
    attendanceModel.spfid7 = attendanceJson['spfid7'];
    attendanceModel.spfid8 = attendanceJson['spfid8'];
    attendanceModel.spfid9 = attendanceJson['spfid9'];
    attendanceModel.spfid10 = attendanceJson['spfid10'];
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
    attendanceEntity.gpsLatitude = gpsLatitude;
    attendanceEntity.gpsLongitude = gpsLongitude;
    attendanceEntity.punch1Time = punch1Time;
    attendanceEntity.punch2Time = punch2Time;
    attendanceEntity.punch3Time = punch3Time;
    attendanceEntity.punch4Time = punch4Time;
    attendanceEntity.punch5Time = punch5Time;
    attendanceEntity.punch6Time = punch6Time;
    attendanceEntity.punch7Time = punch7Time;
    attendanceEntity.punch8Time = punch8Time;
    attendanceEntity.punch9Time = punch9Time;
    attendanceEntity.punch10Time = punch10Time;
    attendanceEntity.spfid1 = spfid1;
    attendanceEntity.spfid2 = spfid2;
    attendanceEntity.spfid3 = spfid3;
    attendanceEntity.spfid4 = spfid4;
    attendanceEntity.spfid5 = spfid5;
    attendanceEntity.spfid6 = spfid6;
    attendanceEntity.spfid7 = spfid7;
    attendanceEntity.spfid8 = spfid8;
    attendanceEntity.spfid9 = spfid9;
    attendanceEntity.spfid10 = spfid10;
    return attendanceEntity;
  }
}
