// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';

import '../../domain/entities/login_entity.dart';

class LoginModel extends BaseModel {
  String? oracleLoginId;
  String? iSMANAGER;
  String? fullNameAR;
  String? fullNameUS;
  String? departmentId;
  String? jobName;
  String? jobNameAr;
  String? employeeNumber;
  String? hireDate;
  String? dateOfBirth;
  String? nationality;
  String? persionID;

  LoginModel();

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    var loginModel = LoginModel();
    loginModel.oracleLoginId = json['ORACLE_LOGIN'];
    loginModel.iSMANAGER = json['IS_MANAGER'];
    loginModel.fullNameAR = json['FULL_NAME_AR'];
    loginModel.fullNameUS = json['FULL_NAME_US'];
    loginModel.departmentId = '${json['DEPARTMENT_ID']}';
    loginModel.jobName = '${json['JOB_NAME']}';
    loginModel.jobNameAr = '${json['JOB_NAME_AR']}';
    loginModel.employeeNumber = '${json['EMPLOYEE_NUMBER']}';
    loginModel.hireDate = '${json['HIRE_DATE']}';
    loginModel.dateOfBirth = '${json['DATE_OF_BIRTH']}';
    loginModel.nationality = '${json['NATIONALITY']}';
    loginModel.persionID = '${json['PERSON_ID']}';
    return loginModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "token": oracleLoginId,
      };

  @override
  List<Object?> get props => [oracleLoginId, fullNameAR, fullNameUS, iSMANAGER];

  @override
  BaseEntity toEntity<T>() {
    return LoginEntity();
  }
}

extension SourceModelExtension on LoginModel {
  LoginEntity toLoginEntity() {
    var loginEntity = LoginEntity();
    loginEntity.oracleLoginId = oracleLoginId;
    loginEntity.iSMANAGER = iSMANAGER;
    loginEntity.fullNameUS = fullNameUS;
    loginEntity.fullNameAR = fullNameAR;
    loginEntity.departmentId = departmentId;
    loginEntity.jobName = jobName;
    loginEntity.jobNameAr = jobNameAr;
    loginEntity.employeeNumber = employeeNumber;
    loginEntity.hireDate = hireDate;
    loginEntity.dateOfBirth = dateOfBirth;
    loginEntity.nationality = nationality;
    loginEntity.persionID = persionID;
    return loginEntity;
  }
}
