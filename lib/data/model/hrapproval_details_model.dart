import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/data/model/finance_details_item_model.dart';
import 'package:malomati/domain/entities/attachment_entity.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/finance_details_item_entity.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/entities/hrapproval_details_entity.dart';
import 'attachment_model.dart';
import 'hr_approval_model.dart';

// ignore: must_be_immutable
class HrApprovalDetailsModel extends BaseModel {
  List<HrApprovalEntity> notificationDetails = [];
  List<FinanceDetailsItemEntity> financeNotificationDetails = [];
  List<AttachmentEntity> attachements = [];

  HrApprovalDetailsModel();

  factory HrApprovalDetailsModel.fromJson(Map<String, dynamic> json) {
    var hrApprovalDetailsModel = HrApprovalDetailsModel();
    if (json['NotificationDetails'] != null) {
      var hrApprovalsJson = json['NotificationDetails'] as List;
      var hrApprovalList = hrApprovalsJson
          .map((hrApprovalJson) =>
              HrApprovalModel.fromJsonDetails(hrApprovalJson)
                  .toHrApprovalDetailsEntity())
          .toList();
      hrApprovalDetailsModel.notificationDetails = hrApprovalList;
    }

    if (json['Items'] != null) {
      var financeDetailsItemListJson = json['Items'] as List;
      var financeDetailsItemList = financeDetailsItemListJson
          .map((financeDetailsItemJson) =>
              FinanceDetailsItemModel.fromJson(financeDetailsItemJson)
                  .toFinanceDetailsItemEntity())
          .toList();
      hrApprovalDetailsModel.financeNotificationDetails =
          financeDetailsItemList;
    }

    if (json['AttachmentList'] != null) {
      final attachmentsListJson = json['AttachmentList'] as List;
      final attachmentsList = attachmentsListJson
          .map((attachmentJson) =>
              AttachmentModel.fromJson(attachmentJson).toAttachmentEntity())
          .toList();
      hrApprovalDetailsModel.attachements = attachmentsList;
    }

    if (json['Attachments'] != null) {
      final attachmentsListJson = json['Attachments'] as List;
      final attachmentsList = attachmentsListJson
          .map((attachmentJson) =>
              AttachmentModel.fromJson(attachmentJson).toAttachmentEntity())
          .toList();
      hrApprovalDetailsModel.attachements = attachmentsList;
    }

    return hrApprovalDetailsModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "notificationDetails": notificationDetails,
      };

  @override
  List<Object?> get props => [notificationDetails];

  @override
  BaseEntity toEntity<T>() {
    return AttendanceEntity();
  }
}

extension SourceModelExtension on HrApprovalDetailsModel {
  HrapprovalDetailsEntity toHrapprovalDetailsEntity() {
    HrapprovalDetailsEntity hrapprovalDetailsEntity = HrapprovalDetailsEntity();
    hrapprovalDetailsEntity.notificationDetails = notificationDetails;
    hrapprovalDetailsEntity.financeNotificationDetails =
        financeNotificationDetails;
    hrapprovalDetailsEntity.attachements = attachements;
    return hrapprovalDetailsEntity;
  }
}
