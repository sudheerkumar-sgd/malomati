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

  ProfileEntity();
  @override
  List<Object?> get props => [
        USER_NAME,
      ];
}
