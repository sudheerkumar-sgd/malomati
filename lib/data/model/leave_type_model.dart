// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';

import '../../domain/entities/leave_type_entity.dart';

class LeaveTypeModel extends BaseModel {
  String? name;
  int? id;
  String? hoursOrDays;

  LeaveTypeModel();

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    var leaveTypeModel = LeaveTypeModel();
    leaveTypeModel.name = json['NAME'];
    leaveTypeModel.id = json['ABSENCE_ATTENDANCE_TYPE_ID'];
    leaveTypeModel.hoursOrDays = json['HOURS_OR_DAYS'];
    return leaveTypeModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "ABSENCE_ATTENDANCE_TYPE_ID": id,
      };

  @override
  List<Object?> get props => [id, name, hoursOrDays];

  @override
  BaseEntity toEntity<T>() {
    return LeaveTypeEntity();
  }
}

extension SourceModelExtension on LeaveTypeModel {
  LeaveTypeEntity toLeaveTypeEntity() {
    var leaveTypeEntity = LeaveTypeEntity();
    leaveTypeEntity.id = id;
    leaveTypeEntity.name = name;
    leaveTypeEntity.hoursOrDays = hoursOrDays;
    return leaveTypeEntity;
  }
}
