// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/thankyou_reason_entity.dart';

import '../../domain/entities/department_entity.dart';

class DepartmentModel extends BaseModel {
  String? deptNameEN;
  String? deptNameAR;
  String? pAYROLLID;
  String? lOOKUP_CODE;
  String? mEANING;
  String? attribute8;

  DepartmentModel();

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    var departmentModel = DepartmentModel();
    departmentModel.deptNameEN = json['Dept_Name_EN'];
    departmentModel.deptNameAR = json['Dept_Name_AR'];
    departmentModel.pAYROLLID = '${json['PAYROLL_ID']}';
    departmentModel.lOOKUP_CODE = '${json['LOOKUP_CODE']}';
    departmentModel.mEANING = '${json['MEANING']}';
    departmentModel.attribute8 = '${json['attribute8']}';
    return departmentModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "token": pAYROLLID,
      };

  @override
  List<Object?> get props => [pAYROLLID, deptNameEN, deptNameAR];

  @override
  BaseEntity toEntity<T>() {
    return DepartmentEntity();
  }
}

extension SourceModelExtension on DepartmentModel {
  DepartmentEntity toDepartmentEntity() {
    var departmentEntity = DepartmentEntity();
    departmentEntity.pAYROLLID = pAYROLLID;
    departmentEntity.deptNameEN = deptNameEN;
    departmentEntity.deptNameAR = deptNameAR;
    return departmentEntity;
  }

  ThankyouReasonEntity toThankyouReasonEntity() {
    var thankyouReasonEntity = ThankyouReasonEntity();
    thankyouReasonEntity.lOOKUP_CODE = lOOKUP_CODE;
    thankyouReasonEntity.mEANING = mEANING;
    thankyouReasonEntity.attribute8 = attribute8;
    return thankyouReasonEntity;
  }
}
