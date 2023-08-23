// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class EmployeeEntity extends BaseEntity {
  String? empNameEN;
  String? empNameAR;
  String? pERSONID;

  EmployeeEntity();

  @override
  List<Object?> get props => [pERSONID, empNameEN, empNameAR];
  @override
  String toString() {
    return empNameEN ?? '';
  }
}
