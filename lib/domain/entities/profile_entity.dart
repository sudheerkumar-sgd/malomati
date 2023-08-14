// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class ProfileEntity extends BaseEntity {
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

  String getFullName(bool isLocalEn) {
    return isLocalEn ? FULL_NAME_US ?? '' : FULL_NAME_AR ?? '';
  }

  String getJobName(bool isLocalEn) {
    return isLocalEn ? JOB_NAME ?? '' : JOB_NAME_AR ?? '';
  }

  String getDepartmentName(bool isLocalEn) {
    return isLocalEn ? DEPARTMENT_NAME_US ?? '' : DEPARTMENT_NAME ?? '';
  }

  String getMaritalStatus(bool isLocalEn) {
    return isLocalEn ? MARITAL_STATUS ?? '' : MARITAL_STATUS ?? '';
  }

  String getManager(bool isLocalEn) {
    return isLocalEn
        ? SUPERVISOR_NAME_ENGLISH ?? ''
        : SUPERVISOR_NAME_ARABIC ?? '';
  }

  ProfileEntity();
  @override
  List<Object?> get props => [
        USER_NAME,
      ];
}
