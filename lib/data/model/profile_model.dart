import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/profile_entity.dart';

import '../../domain/entities/login_entity.dart';

class ProfileModel extends BaseModel {
  int PERSON_ID = 0;
  String? MARITAL_STATUS = "";
  String? EMPLOYEE_NUMBER = "";
  String? SUPERVISOR_NAME_ARABIC = "";
  String? SUPERVISOR_NAME_ENGLISH = "";
  String? FULL_NAME_AR = "";
  String? FULL_NAME_US = "";
  String? EMAIL_ADDRESS = "";
  String? DATE_OF_BIRTH = "";
  String? PHONE_NUMBER = "";
  String? HIRE_DATE = "";
  String? DEPARTMENT_NAME = "";
  String? DEPARTMENT_NAME_US = "";
  String? NATIONALITY = "";
  String? AS_OF_DATE = "";
  String? AS_OF_DATE_CHAR = "";
  String? USER_NAME = "";
  String? YEARS_OF_SERVICE = "";
  String? NEXT_GLOBAL_HOLIDAY = "";
  String? JOB_NAME = "";
  String? JOB_NAME_AR = "";
  String? BASIC_SALARY = "";

  ProfileModel();

  factory ProfileModel.fromJson(Map<String, dynamic> data) {
    var json = data['Data'];
    var profileModel = ProfileModel();
    profileModel.PERSON_ID = json["PERSON_ID"];
    profileModel.MARITAL_STATUS = json["MARITAL_STATUS"];
    profileModel.EMPLOYEE_NUMBER = json["EMPLOYEE_NUMBER"];
    profileModel.SUPERVISOR_NAME_ARABIC = json["SUPERVISOR_NAME_ARABIC"];
    profileModel.FULL_NAME_AR = json["FULL_NAME_AR"];
    profileModel.FULL_NAME_US = json["FULL_NAME_US"];
    profileModel.EMAIL_ADDRESS = json["EMAIL_ADDRESS"];
    profileModel.DATE_OF_BIRTH = json["DATE_OF_BIRTH"];
    profileModel.PHONE_NUMBER = json["PHONE_NUMBER"];
    profileModel.HIRE_DATE = json["HIRE_DATE"];
    profileModel.DEPARTMENT_NAME = json["DEPARTMENT_NAME"];
    profileModel.DEPARTMENT_NAME_US = json["Attribute1"];
    profileModel.NATIONALITY = json["NATIONALITY"];
    profileModel.AS_OF_DATE = json["AS_OF_DATE"];
    profileModel.AS_OF_DATE_CHAR = json["AS_OF_DATE_CHAR"];
    profileModel.USER_NAME = json["USER_NAME"];
    profileModel.YEARS_OF_SERVICE = json["YEARS_OF_SERVICE"];
    profileModel.NEXT_GLOBAL_HOLIDAY = json["NEXT_GLOBAL_HOLIDAY"];
    profileModel.JOB_NAME = json["JOB_NAME"];
    profileModel.JOB_NAME_AR = json["JOB_NAME_AR"];
    profileModel.BASIC_SALARY = json["BASIC_SALARY"];
    return profileModel;
  }

  @override
  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [USER_NAME];

  @override
  BaseEntity toEntity<T>() {
    return ProfileEntity();
  }
}

extension SourceModelExtension on ProfileModel {
  ProfileEntity toProfileEntity() {
    var profileEntity = ProfileEntity();
    profileEntity.PERSON_ID = PERSON_ID;
    profileEntity.MARITAL_STATUS = MARITAL_STATUS;
    profileEntity.EMPLOYEE_NUMBER = EMPLOYEE_NUMBER;
    profileEntity.SUPERVISOR_NAME_ARABIC = SUPERVISOR_NAME_ARABIC;
    profileEntity.FULL_NAME_AR = FULL_NAME_AR;
    profileEntity.FULL_NAME_US = FULL_NAME_US;
    profileEntity.EMAIL_ADDRESS = EMAIL_ADDRESS;
    profileEntity.DATE_OF_BIRTH = DATE_OF_BIRTH;
    profileEntity.PHONE_NUMBER = PHONE_NUMBER;
    profileEntity.HIRE_DATE = HIRE_DATE;
    profileEntity.DEPARTMENT_NAME = DEPARTMENT_NAME;
    profileEntity.DEPARTMENT_NAME_US = DEPARTMENT_NAME_US;
    profileEntity.NATIONALITY = NATIONALITY;
    profileEntity.AS_OF_DATE = AS_OF_DATE;
    profileEntity.AS_OF_DATE_CHAR = AS_OF_DATE_CHAR;
    profileEntity.USER_NAME = USER_NAME;
    profileEntity.YEARS_OF_SERVICE = YEARS_OF_SERVICE;
    profileEntity.NEXT_GLOBAL_HOLIDAY = NEXT_GLOBAL_HOLIDAY;
    profileEntity.JOB_NAME = JOB_NAME;
    profileEntity.JOB_NAME_AR = JOB_NAME_AR;
    profileEntity.BASIC_SALARY = BASIC_SALARY;
    return profileEntity;
  }
}
