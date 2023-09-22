// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class AttendanceEntity extends BaseEntity {
  String? userid;
  String? username;
  String? processdate;
  String? edate;
  String? gpsLatitude = '0.0';
  String? gpsLongitude = '0.0';
  String? departmentLocation;
  String? firsthalf;
  String? secondhalf;
  String? punch1Time;
  String? punch2Time;
  String? punch3Time;
  String? punch4Time;
  String? punch5Time;
  String? punch6Time;
  String? punch7Time;
  String? punch8Time;
  String? punch9Time;
  String? punch10Time;
  String? spfid1;
  String? spfid2;
  String? spfid3;
  String? spfid4;
  String? spfid5;
  String? spfid6;
  String? spfid7;
  String? spfid8;
  String? spfid9;
  String? spfid10;

  AttendanceEntity();
  @override
  List<Object?> get props => [
        userid,
        username,
        processdate,
        edate,
        firsthalf,
        secondhalf,
        gpsLatitude,
        gpsLongitude,
        departmentLocation,
        punch1Time,
        punch2Time,
        punch3Time,
        punch4Time,
        punch5Time,
        punch6Time,
        punch7Time,
        punch8Time,
        punch9Time,
        punch10Time,
        spfid1,
        spfid2,
        spfid3,
        spfid4,
        spfid5,
        spfid6,
        spfid7,
        spfid8,
        spfid9,
        spfid10,
      ];
}
