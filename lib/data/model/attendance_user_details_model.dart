import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/attendance_user_details_entity.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/domain/entities/login_entity.dart';
import '../../domain/entities/attendance_entity.dart';

// ignore: must_be_immutable
class AttendanceUserDetailsModel extends BaseModel {
  String? locationMandatory;
  List<EmployeeEntity> usersData = [];

  AttendanceUserDetailsModel();

  factory AttendanceUserDetailsModel.fromJson(Map<String, dynamic> json) {
    var attendanceUserDetailsModel = AttendanceUserDetailsModel();
    if (json['user'] != null) {
      final attendanceUserJsonList = json['user'] as List;
      if (attendanceUserJsonList.isNotEmpty) {
        attendanceUserDetailsModel.locationMandatory =
            attendanceUserJsonList[0]['location-mandatory'];
      }

      if (attendanceUserJsonList.isNotEmpty) {
        attendanceUserDetailsModel.usersData = attendanceUserJsonList
            .map<EmployeeEntity>((e) => EmployeeEntity()
              ..pERSONID = e['id']
              ..empNameEN = e['name']
              ..uSERNAME = e['active-directory-username']
              ..punchApiAccess = e['punch-api'])
            .toList();
      }
    }
    return attendanceUserDetailsModel;
  }

  factory AttendanceUserDetailsModel.fromStringJson(String json) {
    var attendanceUserDetailsModel = AttendanceUserDetailsModel();

    return attendanceUserDetailsModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "location-mandatory": locationMandatory,
      };

  @override
  List<Object?> get props => [locationMandatory];

  @override
  BaseEntity toEntity<T>() {
    return AttendanceEntity();
  }
}

extension SourceModelExtension on AttendanceUserDetailsModel {
  AttendanceUserDetailsEntity toAttendanceUserDetailsEntity() {
    AttendanceUserDetailsEntity attendanceUserDetailsEntity =
        AttendanceUserDetailsEntity();
    attendanceUserDetailsEntity.locationMandatory = locationMandatory;
    attendanceUserDetailsEntity.usersData = usersData;
    return attendanceUserDetailsEntity;
  }
}
