// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';

import '../../domain/entities/leave_type_entity.dart';

class WarningReasonsModel extends BaseModel {
  String? name;
  String? id;

  WarningReasonsModel();

  factory WarningReasonsModel.fromJson(Map<String, dynamic> json) {
    var warningReasonsModel = WarningReasonsModel();
    warningReasonsModel.name = json['VALUE'];
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
        name,
      ];

  @override
  BaseEntity toEntity<T>() {
    return LeaveTypeEntity();
  }
}

extension SourceModelExtension on WarningReasonsModel {
  NameIdEntity toNameIdEntity() => NameIdEntity(id, name);
}

class WarningListModel extends BaseModel {
  String? name;
  String? id;

  WarningListModel();

  factory WarningListModel.fromJson(Map<String, dynamic> json) {
    var warningListModel = WarningListModel();
    warningListModel.name = json['VALUE'];
    warningListModel.id = json['ID'];
    return warningListModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "ID": id,
      };

  @override
  List<Object?> get props => [
        id,
        name,
      ];

  @override
  BaseEntity toEntity<T>() {
    return LeaveTypeEntity();
  }
}

extension WarningListExtension on WarningListModel {
  NameIdEntity toNameIdEntity() => NameIdEntity(id, name);
}
