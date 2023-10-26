// ignore_for_file: must_be_immutable

import 'package:malomati/core/common/common.dart';
import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';

import '../../domain/entities/hr_approval_entity.dart';
import '../../domain/entities/leave_type_entity.dart';
import '../../domain/entities/request_details_entity.dart';
import '../../domain/entities/warning_list_entity.dart';
import 'hr_approval_model.dart';

class WarningReasonsModel extends BaseModel {
  String? nameAR;
  String? nameEN;
  String? id;

  WarningReasonsModel();

  factory WarningReasonsModel.fromJson(Map<String, dynamic> json) {
    var warningReasonsModel = WarningReasonsModel();
    warningReasonsModel.nameAR = json['VALUE_AR'];
    warningReasonsModel.nameEN = json['VALUE_AR'];
    warningReasonsModel.id = json['ID'];
    return warningReasonsModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "ID": id,
      };

  @override
  List<Object?> get props => [
        id,
        nameAR,
        nameEN,
      ];

  @override
  BaseEntity toEntity<T>() {
    return LeaveTypeEntity();
  }
}

extension SourceModelExtension on WarningReasonsModel {
  NameIdEntity toNameIdEntity() =>
      NameIdEntity(id, isLocalEn ? nameEN : nameAR);
}

class WarningListModel extends BaseModel {
  String? date;
  String? receivedBy;
  String? reasonEN;
  String? reasonAR;
  String? note;

  WarningListModel();

  factory WarningListModel.fromJson(Map<String, dynamic> json) {
    var warningListModel = WarningListModel();
    warningListModel.date = json['LAST_UPDATE_DATE'];
    warningListModel.reasonEN = json['REASON_EN'];
    warningListModel.reasonAR = json['REASON_AR'];
    warningListModel.receivedBy = json['RECEIVED_BY'];
    warningListModel.note = json['NOTE'];
    return warningListModel;
  }

  @override
  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [
        date,
        reasonEN,
        reasonAR,
      ];

  @override
  BaseEntity toEntity<T>() {
    return LeaveTypeEntity();
  }
}

extension WarningListExtension on WarningListModel {
  WarningListEntity toWarningListEntity() {
    WarningListEntity warningListEntity = WarningListEntity();
    warningListEntity.date = date;
    warningListEntity.receivedBy = receivedBy;
    warningListEntity.reasonEN = reasonEN;
    warningListEntity.reasonAR = reasonAR;
    warningListEntity.note = note;
    return warningListEntity;
  }
}

class RequestsDetailsModel extends BaseModel {
  String? action;
  String? user;
  String? question;
  String? rejectedBy;
  String? employeeName;
  String? employeeNumber;
  String? submittedDate;
  String? absenceStatus;
  String? absenceType;
  String? absenceCategory;
  String? dateStart;
  String? dateEnd;
  String? days;
  List<HrApprovalEntity> notificationDetails = [];
  List<String> approversList = [];

  RequestsDetailsModel();

  factory RequestsDetailsModel.fromJson(Map<String, dynamic> json) {
    var requestsDetailsModel = RequestsDetailsModel();
    requestsDetailsModel.action = json['ACTION'];
    requestsDetailsModel.user = json['USER'];
    requestsDetailsModel.question = json['QUESTION'];
    requestsDetailsModel.rejectedBy = json['REJECTED_BY'];
    if (json['NotificationDetails'] != null) {
      var requestDetailsJson = json['NotificationDetails'] as List;
      var hrApprovalList = requestDetailsJson
          .map((hrApprovalJson) =>
              HrApprovalModel.fromJsonDetails(hrApprovalJson)
                  .toHrApprovalDetailsEntity())
          .toList();
      requestsDetailsModel.notificationDetails = hrApprovalList;
      // for (int i = 0; i < requestDetailsJson.length; i++) {
      //   switch (requestDetailsJson[i]['F_NAME']) {
      //     case 'Employee Name':
      //       {
      //         requestsDetailsModel.employeeName =
      //             requestDetailsJson[i]['F_VALUE'];
      //       }
      //     case 'Employee Number':
      //       {
      //         requestsDetailsModel.employeeNumber =
      //             requestDetailsJson[i]['F_VALUE'];
      //       }
      //     case 'Submitted Date':
      //       {
      //         requestsDetailsModel.submittedDate =
      //             requestDetailsJson[i]['F_VALUE'];
      //       }
      //     case 'Absence Status':
      //       {
      //         requestsDetailsModel.absenceStatus =
      //             requestDetailsJson[i]['F_VALUE'];
      //       }
      //     case 'Absence Type':
      //       {
      //         requestsDetailsModel.absenceCategory =
      //             requestDetailsJson[i]['F_VALUE'];
      //       }
      //     case 'Absence Category':
      //       {
      //         requestsDetailsModel.dateStart = requestDetailsJson[i]['F_VALUE'];
      //       }
      //     case 'Date Start':
      //       {
      //         requestsDetailsModel.dateStart = requestDetailsJson[i]['F_VALUE'];
      //       }
      //     case 'Date End':
      //       {
      //         requestsDetailsModel.dateEnd = requestDetailsJson[i]['F_VALUE'];
      //       }
      //     case 'Days':
      //       {
      //         requestsDetailsModel.days = requestDetailsJson[i]['F_VALUE'];
      //       }
      //   }
      // }
    }
    if (json['APPROVER_LIST'] != null) {
      requestsDetailsModel.approversList = (json['APPROVER_LIST'] as List)
          .map((e) => e['CURRENT_APPROVER'].toString())
          .toList();
    }
    return requestsDetailsModel;
  }

  @override
  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [
        action,
        user,
        question,
      ];

  @override
  BaseEntity toEntity<T>() {
    return LeaveTypeEntity();
  }
}

extension RequestsDetailsExtension on RequestsDetailsModel {
  RequestDetailsEntity toRequestDetailsEntity() {
    RequestDetailsEntity requestDetailsEntity = RequestDetailsEntity();
    requestDetailsEntity.user = user;
    requestDetailsEntity.action = action;
    requestDetailsEntity.question = question;
    requestDetailsEntity.rejectedBy = rejectedBy;
    requestDetailsEntity.employeeName = employeeName;
    requestDetailsEntity.employeeNumber = employeeNumber;
    requestDetailsEntity.submittedDate = submittedDate;
    requestDetailsEntity.absenceStatus = absenceStatus;
    requestDetailsEntity.absenceType = absenceType;
    requestDetailsEntity.absenceCategory = absenceCategory;
    requestDetailsEntity.dateStart = dateStart;
    requestDetailsEntity.dateEnd = dateEnd;
    requestDetailsEntity.days = days;
    requestDetailsEntity.notificationDetails = notificationDetails;
    requestDetailsEntity.approversList = approversList;
    return requestDetailsEntity;
  }
}
