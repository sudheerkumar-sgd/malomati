// ignore_for_file: must_be_immutable
class ApiRequestModel {
  String? uSERNAME;
  String? cREATORUSERNAME;

  //Certificate REQUEST PARAMS
  String? eNTITYNAME;
  String? sHOWSALARY;

  //THANKYOU REQUEST PARAMS
  String? dEPARTMENTNAME;
  String? eMPLOYEE;
  String? rEASON;
  String? nOTE;

  //AdvanceSalary REQUEST PARAMS
  String? lEAVE;
  String? aPPROVALCOMMENT;

  //Badge REQUEST PARAMS
  String? hIRINGDATE;

  //Overtime REQUEST PARAMS
  String? oVERTIMEDATE;
  String? fROMTIME;
  String? tOTIME;
  String? nOOFHOURS;
  String? fILENAME;
  String? bLOBFILE;
  String? fILENAMENEW_;
  String? bLOBFILENEW_;
  String? fILENAMENEW;
  String? bLOBFILENEW;

  ApiRequestModel();
}

extension SourceModelExtension on ApiRequestModel {
  Map<String, dynamic> toCertificateRequest() => {
        "USER_NAME": uSERNAME,
        "CREATOR_USER_NAME": cREATORUSERNAME,
        "ENTITY_NAME": eNTITYNAME,
        "SHOW_SALARY": sHOWSALARY,
      };
  Map<String, dynamic> toThankyouRequest() => {
        "USER_NAME": uSERNAME,
        "CREATOR_USER_NAME": cREATORUSERNAME,
        "DEPARTMENT_NAME": dEPARTMENTNAME,
        "EMPLOYEE": eMPLOYEE,
        "REASON": rEASON,
        "NOTE": nOTE,
      };
  Map<String, dynamic> toAdvanceSalaryRequest() => {
        "USER_NAME": uSERNAME,
        "CREATOR_USER_NAME": cREATORUSERNAME,
        "LEAVE": lEAVE,
        "APPROVAL_COMMENT": aPPROVALCOMMENT,
      };
  Map<String, dynamic> toBadgeRequest() => {
        "USER_NAME": uSERNAME,
        "HIRING_DATE": hIRINGDATE,
      };
  Map<String, dynamic> toOvertimeRequest() => {
        "USER_NAME": uSERNAME,
        "CREATOR_USER_NAME": cREATORUSERNAME,
        "OVERTIME_DATE": oVERTIMEDATE,
        "FROM_TIME": fROMTIME,
        "TO_TIME": tOTIME,
        "NO_OF_HOURS": nOOFHOURS,
        "REASON": rEASON,
        "FILE_NAME": fILENAME,
        "BLOB_FILE": bLOBFILE,
        "FILE_NAME_NEW_": fILENAMENEW_,
        "BLOB_FILE_NEW_": bLOBFILENEW_,
        "FILE_NAME_NEW": fILENAMENEW,
        "BLOB_FILE_NEW": bLOBFILENEW,
      };
  Map<String, dynamic> toDeleteLeaveRequest() => {
        "USER_NAME": uSERNAME,
        "CREATOR_USER_NAME": cREATORUSERNAME,
        "LEAVE": lEAVE,
        "DELETED_LEAVE": lEAVE,
        "REASON": aPPROVALCOMMENT,
      };
  Map<String, dynamic> toWarningRequest() => {
        "USER_NAME": uSERNAME,
        "CREATOR_USER_NAME": cREATORUSERNAME,
        "REASON": rEASON,
        "APPROVAL_COMMENT": nOTE,
        "START_DATE": "",
        "END_DATE": "",
        "FILE_NAME": "",
        "BLOB_FILE": ""
      };
}
