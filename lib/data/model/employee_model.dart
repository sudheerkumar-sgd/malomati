// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import '../../domain/entities/employee_entity.dart';

class EmployeeModel extends BaseModel {
  String? empNameEN;
  String? empNameAR;
  String? pERSONID;
  String? uSERNAME;

  EmployeeModel();

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    var departmentModel = EmployeeModel();
    departmentModel.empNameEN = json['ENGLISH'];
    departmentModel.empNameAR = json['ARABIC'];
    departmentModel.pERSONID = '${json['PERSON_ID']}';
    departmentModel.uSERNAME = '${json['USER_NAME']}';
    return departmentModel;
  }

  factory EmployeeModel.fromJsonMyTeam(Map<String, dynamic> json) {
    var departmentModel = EmployeeModel();
    departmentModel.empNameEN = json['FULL_NAME_US'];
    departmentModel.empNameAR = json['FULL_NAME'];
    departmentModel.pERSONID = '${json['EMPLOYEE_NUMBER']}';
    departmentModel.uSERNAME = '${json['USER_NAME']}';
    return departmentModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "token": pERSONID,
      };

  @override
  List<Object?> get props => [pERSONID, empNameEN, empNameAR];

  @override
  BaseEntity toEntity<T>() {
    return EmployeeEntity();
  }
}

extension SourceModelExtension on EmployeeModel {
  EmployeeEntity toEmployeeEntity() {
    var employeeEntity = EmployeeEntity();
    employeeEntity.pERSONID = pERSONID;
    employeeEntity.empNameEN = empNameEN;
    employeeEntity.empNameAR = empNameAR;
    employeeEntity.uSERNAME = uSERNAME;
    return employeeEntity;
  }
}
