import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/leave_type_list_entity.dart';
import '../../domain/entities/leave_type_entity.dart';
import 'leave_type_model.dart';

// ignore: must_be_immutable
class LeaveTypeListModel extends BaseModel {
  List<LeaveTypeEntity> leaveTypeList = [];

  LeaveTypeListModel();

  factory LeaveTypeListModel.fromJson(Map<String, dynamic> json) {
    var leaveTypeJsonList = [];
    if (json['LeaveTypeList'] != null) {
      leaveTypeJsonList = json['LeaveTypeList'] as List;
    }

    final leaveTypeList = leaveTypeJsonList
        .map((leaveTypeJson) =>
            LeaveTypeModel.fromJson(leaveTypeJson).toLeaveTypeEntity())
        .toList();
    var leaveTypeListModel = LeaveTypeListModel();
    leaveTypeListModel.leaveTypeList = leaveTypeList;
    return leaveTypeListModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "leaveType_daily": leaveTypeList,
      };

  @override
  List<Object?> get props => [leaveTypeList];

  @override
  BaseEntity toEntity<T>() {
    return LeaveTypeEntity();
  }
}

extension SourceModelExtension on LeaveTypeListModel {
  LeaveTypeListEntity toleaveTypeList() {
    LeaveTypeListEntity leaveTypeListEntity = LeaveTypeListEntity();
    leaveTypeListEntity.leaveTypeList = leaveTypeList;
    return leaveTypeListEntity;
  }
}
