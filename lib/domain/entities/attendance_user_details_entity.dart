// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';

class AttendanceUserDetailsEntity extends BaseEntity {
  String? locationMandatory;
  List<EmployeeEntity> usersData = [];

  AttendanceUserDetailsEntity();
  @override
  List<Object?> get props => [locationMandatory, usersData];
}
