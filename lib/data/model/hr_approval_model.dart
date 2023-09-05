// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/attachment_model.dart';
import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/attachment_entity.dart';
import 'package:malomati/domain/entities/base_entity.dart';
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
  List<AttachmentEntity>? attachments;

  HrApprovalModel();

  factory HrApprovalModel.fromJson(Map<String, dynamic> json) {
    var hrApprovalModel = HrApprovalModel();
    hrApprovalModel.nOTIFICATIONID = '${json['NOTIFICATION_ID']}';
    hrApprovalModel.fROMUSER = '${json['FROM_USER']}';
    hrApprovalModel.sUBJECTAR = '${json['SUBJECT_AR']}';
    hrApprovalModel.sUBJECTUS = '${json['SUBJECT_US']}';
    hrApprovalModel.bEGINDATE = '${json['BEGIN_DATE']}';
    hrApprovalModel.bEGINDATECHAR = '${json['BEGIN_DATE_CHAR']}';
    hrApprovalModel.dUEDATECHAR = '${json['DUE_DATE_CHAR']}';
    hrApprovalModel.nOTIFICATIONTYPE = '${json['NOTIFICATION_TYPE']}';
    return hrApprovalModel;
  }

  factory HrApprovalModel.fromJsonDetails(Map<String, dynamic> json) {
    var hrApprovalModel = HrApprovalModel();
    hrApprovalModel.fNAME = '${json['F_NAME']}';
    hrApprovalModel.fVALUE = '${json['F_VALUE']}';
    if (json['AttachmentList'] != null) {
      final attachmentsListJson = json['AttachmentList'] as List;
      final attachmentsList = attachmentsListJson
          .map((attachmentJson) =>
              AttachmentModel.fromJson(attachmentJson).toAttachmentEntity())
          .toList();
      hrApprovalModel.attachments = attachmentsList;
    }
    return hrApprovalModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "token": nOTIFICATIONID,
      };

  @override
  List<Object?> get props => [];

  @override
  BaseEntity toEntity<T>() {
    return HrApprovalEntity();
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
    hrApprovalEntity.attachments = attachments;
    return hrApprovalEntity;
  }
}
