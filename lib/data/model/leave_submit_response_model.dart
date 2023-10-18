// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/leave_submit_response_entity.dart';

import '../../domain/entities/login_entity.dart';

class LeaveSubmitResponseModel extends BaseModel {
  String? nTFID;
  String? iTEMKEY;
  String? sTATUS;
  String? cREATORUSERNAME;
  List<String> aPPROVERSLIST = [];

  LeaveSubmitResponseModel();

  factory LeaveSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    var leaveSubmitResponseModel = LeaveSubmitResponseModel();
    leaveSubmitResponseModel.sTATUS = json['STATUS'];
    leaveSubmitResponseModel.nTFID = '${json['NTF_ID']}';
    leaveSubmitResponseModel.iTEMKEY = '${json['ITEM_KEY']}';
    leaveSubmitResponseModel.cREATORUSERNAME = '${json['CREATOR_USER_NAME']}';
    if (json['APPROVER_LIST'] != null) {
      leaveSubmitResponseModel.aPPROVERSLIST = (json['APPROVER_LIST'] as List)
          .map((e) => e['CURRENT_APPROVER'].toString())
          .toList();
    } else if (json['APPROVERS_LIST'] != null) {
      leaveSubmitResponseModel.aPPROVERSLIST = (json['APPROVERS_LIST'] as List)
          .map((e) => e['CURRENT_APPROVER'].toString())
          .toList();
    }
    return leaveSubmitResponseModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "token": nTFID,
      };

  @override
  List<Object?> get props => [nTFID, iTEMKEY, sTATUS];

  @override
  BaseEntity toEntity<T>() {
    return LoginEntity();
  }
}

extension SourceModelExtension on LeaveSubmitResponseModel {
  LeaveSubmitResponseEntity toLeaveSubmitResponseEntity() {
    final leaveSubmitResponseEntity = LeaveSubmitResponseEntity();
    leaveSubmitResponseEntity.sTATUS = sTATUS;
    leaveSubmitResponseEntity.iTEMKEY = iTEMKEY;
    leaveSubmitResponseEntity.nTFID = nTFID;
    leaveSubmitResponseEntity.aPPROVERSLIST = aPPROVERSLIST;
    leaveSubmitResponseEntity.cREATORUSERNAME = cREATORUSERNAME;
    return leaveSubmitResponseEntity;
  }
}
