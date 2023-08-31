// ignore_for_file: must_be_immutable

import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/domain/entities/base_entity.dart';

class EmployeeEntity extends BaseEntity {
  String? empNameEN;
  String? empNameAR;
  String? pERSONID;
  String? uSERNAME;

  EmployeeEntity();

  @override
  List<Object?> get props => [pERSONID, empNameEN, empNameAR, uSERNAME];
  @override
  String toString() {
    return isLocalEn ? empNameEN ?? '' : empNameAR ?? '';
  }
}
