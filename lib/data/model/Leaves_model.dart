// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import '../../domain/entities/employee_entity.dart';

class LeavesModel extends BaseModel {
  String? lEAVEDETAIL;
  String? aBSENCEATTENDANCEID;

  LeavesModel();

  factory LeavesModel.fromJson(Map<String, dynamic> json) {
    var departmentModel = LeavesModel();
    departmentModel.lEAVEDETAIL = json['LEAVE_DETAIL'];
    departmentModel.aBSENCEATTENDANCEID = '${json['ABSENCE_ATTENDANCE_ID']}';
    return departmentModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "token": lEAVEDETAIL,
      };

  @override
  List<Object?> get props => [lEAVEDETAIL, aBSENCEATTENDANCEID];

  @override
  BaseEntity toEntity<T>() {
    return EmployeeEntity();
  }
}

extension SourceModelExtension on LeavesModel {
  NameIdEntity toNameIdEntity() =>
      NameIdEntity(aBSENCEATTENDANCEID, lEAVEDETAIL);
}
