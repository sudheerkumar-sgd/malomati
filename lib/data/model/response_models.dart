// ignore_for_file: must_be_immutable

import 'package:malomati/core/common/common.dart';
import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';

import '../../domain/entities/leave_type_entity.dart';
import '../../domain/entities/warning_list_entity.dart';

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
