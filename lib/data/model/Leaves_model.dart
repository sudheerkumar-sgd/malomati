// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/leave_details_entity.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/leave_type_entity.dart';

class LeavesModel extends BaseModel {
  String? lEAVEDETAIL;
  String? aBSENCEATTENDANCEID;
  String? lEAVEUS;
  String? lEAVEAR;
  int? noOfDays;

  LeavesModel();

  factory LeavesModel.fromJson(Map<String, dynamic> json) {
    var departmentModel = LeavesModel();
    departmentModel.lEAVEUS = json['LEAVE_DETAIL'] ?? json['LEAVE_US'];
    departmentModel.lEAVEAR = json['LEAVE_AR'];
    departmentModel.aBSENCEATTENDANCEID = '${json['ABSENCE_ATTENDANCE_ID']}';
    return departmentModel;
  }

  factory LeavesModel.fromWorkingDaysJson(Map<String, dynamic> json) {
    var departmentModel = LeavesModel();
    departmentModel.noOfDays = json['NO_OF_DAYS'];
    return departmentModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "token": lEAVEDETAIL,
      };

  @override
  List<Object?> get props => [lEAVEDETAIL, aBSENCEATTENDANCEID];

  @override
  BaseEntity toEntity<T>() {
    return EmployeeEntity();
  }
}

extension SourceModelExtension on LeavesModel {
  NameIdEntity toNameIdEntity() =>
      NameIdEntity(aBSENCEATTENDANCEID, lEAVEDETAIL);

  WorkingDaysEntity toWorkingDaysEntity() {
    WorkingDaysEntity workingDaysEntity = WorkingDaysEntity();
    workingDaysEntity.noOfDays = '$noOfDays';
    return workingDaysEntity;
  }

  LeaveDetailsEntity toLeaveDetailsEntity() {
    LeaveDetailsEntity leaveDetailsEntity = LeaveDetailsEntity();
    leaveDetailsEntity.id = aBSENCEATTENDANCEID;
    leaveDetailsEntity.nameUS = lEAVEUS;
    leaveDetailsEntity.nameAR = lEAVEAR;
    return leaveDetailsEntity;
  }
}
