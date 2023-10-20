// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/thankyou_entity.dart';
import '../../domain/entities/employee_entity.dart';

class ThankyouModel extends BaseModel {
  String? empNameEN;
  String? empNameAR;
  String? departmentNameAr;
  String? departmentNameEn;
  String? pERSONID;
  String? uSERNAME;
  String? reasonEn;
  String? reasonAr;
  String? note;
  String? creationDate;

  ThankyouModel();

  factory ThankyouModel.fromJson(Map<String, dynamic> json) {
    var thankyouModel = ThankyouModel();
    thankyouModel.empNameEN = json['CONC_FULL_NAME_EN'];
    thankyouModel.empNameAR = json['CONC_FULL_NAME_AR'];
    thankyouModel.departmentNameAr = json['CONC_DEPARTMENT_NAME_AR'];
    thankyouModel.departmentNameEn = json['CONC_DEPARTMENT_NAME_EN'];
    thankyouModel.reasonEn = json['REASON_EN'];
    thankyouModel.reasonAr = json['REASON_AR'];
    thankyouModel.note = json['NOTE'];
    thankyouModel.uSERNAME = json['USER_NAME'];
    thankyouModel.creationDate = json['CREATION_DATE'];
    thankyouModel.pERSONID = '${json['PERSON_ID']}';
    return thankyouModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "token": pERSONID,
      };

  @override
  List<Object?> get props => [pERSONID, empNameEN, empNameAR];

  @override
  BaseEntity toEntity<T>() {
    return EmployeeEntity();
  }
}

extension SourceModelExtension on ThankyouModel {
  ThankyouEntity toThankyouEntity() {
    var thankyouEntity = ThankyouEntity();
    thankyouEntity.pERSONID = pERSONID;
    thankyouEntity.empNameEN = empNameEN;
    thankyouEntity.empNameAR = empNameAR;
    thankyouEntity.uSERNAME = uSERNAME;
    thankyouEntity.departmentNameAr = departmentNameAr;
    thankyouEntity.departmentNameEn = departmentNameEn;
    thankyouEntity.reasonAr = reasonAr;
    thankyouEntity.reasonEn = reasonEn;
    thankyouEntity.note = note;
    thankyouEntity.creationDate = creationDate;
    return thankyouEntity;
  }
}
