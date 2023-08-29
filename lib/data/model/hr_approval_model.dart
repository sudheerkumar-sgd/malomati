// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';

import '../../domain/entities/department_entity.dart';
import '../../domain/entities/hr_approval_entity.dart';

class HrApprovalModel extends BaseModel {
  String? nOTIFICATIONID;
  String? fROMUSER;
  String? sUBJECTAR;
  String? sUBJECTUS;
  String? bEGINDATE;
  String? bEGINDATECHAR;
  String? dUEDATECHAR;
  String? nOTIFICATIONTYPE;
  String? fNAME;
  String? fVALUE;

  HrApprovalModel();

  factory HrApprovalModel.fromJson(Map<String, dynamic> json) {
    var departmentModel = HrApprovalModel();
    departmentModel.nOTIFICATIONID = '${json['NOTIFICATION_ID']}';
    departmentModel.fROMUSER = '${json['FROM_USER']}';
    departmentModel.sUBJECTAR = '${json['SUBJECT_AR']}';
    departmentModel.sUBJECTUS = '${json['SUBJECT_US']}';
    departmentModel.bEGINDATE = '${json['BEGIN_DATE']}';
    departmentModel.bEGINDATECHAR = '${json['BEGIN_DATE_CHAR']}';
    departmentModel.dUEDATECHAR = '${json['DUE_DATE_CHAR']}';
    departmentModel.nOTIFICATIONTYPE = '${json['NOTIFICATION_TYPE']}';
    return departmentModel;
  }

  factory HrApprovalModel.fromJsonDetails(Map<String, dynamic> json) {
    var departmentModel = HrApprovalModel();
    departmentModel.fNAME = '${json['F_NAME']}';
    departmentModel.fVALUE = '${json['F_VALUE']}';
    return departmentModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "token": nOTIFICATIONID,
      };

  @override
  List<Object?> get props => [];

  @override
  BaseEntity toEntity<T>() {
    return DepartmentEntity();
  }
}

extension SourceModelExtension on HrApprovalModel {
  HrApprovalEntity toHrApprovalEntity() {
    final hrApprovalEntity = HrApprovalEntity();
    hrApprovalEntity.nOTIFICATIONID = nOTIFICATIONID;
    hrApprovalEntity.fROMUSER = fROMUSER;
    hrApprovalEntity.sUBJECTAR = sUBJECTAR;
    hrApprovalEntity.sUBJECTUS = sUBJECTUS;
    hrApprovalEntity.bEGINDATE = bEGINDATE;
    hrApprovalEntity.bEGINDATECHAR = bEGINDATECHAR;
    hrApprovalEntity.dUEDATECHAR = dUEDATECHAR;
    hrApprovalEntity.nOTIFICATIONTYPE = nOTIFICATIONTYPE;
    return hrApprovalEntity;
  }

  HrApprovalEntity toHrApprovalDetailsEntity() {
    final hrApprovalEntity = HrApprovalEntity();
    hrApprovalEntity.fNAME = fNAME;
    hrApprovalEntity.fVALUE = fVALUE;
    return hrApprovalEntity;
  }
}
