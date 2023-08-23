// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class DepartmentEntity extends BaseEntity {
  String? deptNameEN;
  String? deptNameAR;
  String? pAYROLLID;

  DepartmentEntity();

  @override
  List<Object?> get props => [pAYROLLID, deptNameEN, deptNameAR];
  @override
  String toString() {
    return deptNameEN ?? '';
  }
}
