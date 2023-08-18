// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';

class LeaveTypeListEntity extends BaseEntity {
  List<LeaveTypeEntity> leaveTypeList = [];

  LeaveTypeListEntity();
  @override
  List<Object?> get props => [leaveTypeList];
}
