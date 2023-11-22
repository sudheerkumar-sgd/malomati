// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class AttendanceUserDetailsEntity extends BaseEntity {
  String? locationMandatory;

  AttendanceUserDetailsEntity();
  @override
  List<Object?> get props => [locationMandatory];
}
