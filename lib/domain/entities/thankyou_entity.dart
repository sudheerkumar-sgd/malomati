// ignore_for_file: must_be_immutable

import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/domain/entities/base_entity.dart';

class ThankyouEntity extends BaseEntity {
  String? empNameEN;
  String? empNameAR;
  String? departmentNameAr;
  String? departmentNameEn;
  String? pERSONID;
  String? uSERNAME;
  String? reasonEn;
  String? reasonAr;
  String? creationDate;

  ThankyouEntity();

  @override
  List<Object?> get props => [pERSONID, empNameEN, empNameAR, uSERNAME];
  @override
  String toString() {
    return isLocalEn ? empNameEN ?? '' : empNameAR ?? '';
  }
}
