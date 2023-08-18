// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';

import '../../domain/entities/login_entity.dart';

class LeaveSubmitResponseModel extends BaseModel {
  String? nTFID;
  String? iTEMKEY;
  String? sTATUS;

  LeaveSubmitResponseModel();

  factory LeaveSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    var leaveSubmitResponseModel = LeaveSubmitResponseModel();
    leaveSubmitResponseModel.sTATUS = json['STATUS'];
    leaveSubmitResponseModel.nTFID = '${json['NTF_ID']}';
    leaveSubmitResponseModel.iTEMKEY = '${json['ITEM_KEY']}';
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
  bool isSuccess() {
    return sTATUS == 'SUCCESS';
  }
}
