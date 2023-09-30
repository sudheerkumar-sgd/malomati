// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/data/model/event_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';

class DashboardModel extends BaseModel {
  bool? isSuccess;
  String? message;
  var pERSONID;
  String? mARITALSTATUS;
  String? eMPLOYEENUMBER;
  String? aTTRIBUTE1;
  String? pHONENUMBER;
  String? sUPERVISORNAMEARABIC;
  String? sUPERVISORNAMEENGLISH;
  String? fULLNAMEAR;
  String? fULLNAMEUS;
  String? eMAILADDRESS;
  String? nATIONALITY;
  String? dATEOFBIRTH;
  String? hIREDATE;
  String? dEPARTMENTNAME;
  String? aSOFDATE;
  String? aSOFDATECHAR;
  var aNNUALACCRUAL;
  var aNNUALTAKEN;
  var pERMISSIONACCRUAL;
  var pERMISSIONTAKEN;
  var oVERTIMEACCRUAL;
  var oVERTIMETAKEN;
  var sICKACCRUAL;
  var sICKTAKEN;
  String? uSERNAME;
  var yEARSOFSERVICE;
  String? jOBNAME;
  String? jOBNAMEAR;
  var bASICSALARY;
  var cOUNTBADGE;
  var cERTIFICATEBADGE;
  var iNITIATIVEBADGE;
  var tHANKYOUINMONTH;
  var tHANKYOUINYEAR;
  var sUGGESTOVERALLRATING;
  var tHANKYOUCOUNT;
  List<EventModel>? eventListModel;

  DashboardModel(
      {this.isSuccess,
      this.message,
      this.pERSONID,
      this.mARITALSTATUS,
      this.eMPLOYEENUMBER,
      this.aTTRIBUTE1,
      this.pHONENUMBER,
      this.sUPERVISORNAMEARABIC,
      this.sUPERVISORNAMEENGLISH,
      this.fULLNAMEAR,
      this.fULLNAMEUS,
      this.eMAILADDRESS,
      this.nATIONALITY,
      this.dATEOFBIRTH,
      this.hIREDATE,
      this.dEPARTMENTNAME,
      this.aSOFDATE,
      this.aSOFDATECHAR,
      this.aNNUALACCRUAL,
      this.aNNUALTAKEN,
      this.pERMISSIONACCRUAL,
      this.pERMISSIONTAKEN,
      this.oVERTIMEACCRUAL,
      this.oVERTIMETAKEN,
      this.sICKACCRUAL,
      this.sICKTAKEN,
      this.uSERNAME,
      this.yEARSOFSERVICE,
      this.jOBNAME,
      this.jOBNAMEAR,
      this.bASICSALARY,
      this.cOUNTBADGE,
      this.cERTIFICATEBADGE,
      this.iNITIATIVEBADGE,
      this.tHANKYOUINMONTH,
      this.tHANKYOUINYEAR,
      this.sUGGESTOVERALLRATING,
      this.tHANKYOUCOUNT});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    message = json['Message'];
    pERSONID = json['PERSON_ID'];
    mARITALSTATUS = json['MARITAL_STATUS'];
    eMPLOYEENUMBER = json['EMPLOYEE_NUMBER'];
    aTTRIBUTE1 = json['ATTRIBUTE1'];
    pHONENUMBER = json['PHONE_NUMBER'];
    sUPERVISORNAMEARABIC = json['SUPERVISOR_NAME_ARABIC'];
    sUPERVISORNAMEENGLISH = json['SUPERVISOR_NAME_ENGLISH'];
    fULLNAMEAR = json['FULL_NAME_AR'];
    fULLNAMEUS = json['FULL_NAME_US'];
    eMAILADDRESS = json['EMAIL_ADDRESS'];
    nATIONALITY = json['NATIONALITY'];
    dATEOFBIRTH = json['DATE_OF_BIRTH'];
    hIREDATE = json['HIRE_DATE'];
    dEPARTMENTNAME = json['DEPARTMENT_NAME'];
    aSOFDATE = json['AS_OF_DATE'];
    aSOFDATECHAR = json['AS_OF_DATE_CHAR'];
    aNNUALACCRUAL = json['ANNUAL_ACCRUAL'];
    aNNUALTAKEN = json['ANNUAL_TAKEN'];
    pERMISSIONACCRUAL = json['PERMISSION_ACCRUAL'];
    pERMISSIONTAKEN = json['PERMISSION_TAKEN'];
    oVERTIMEACCRUAL = json['OVERTIME_ACCRUAL'];
    oVERTIMETAKEN = json['OVERTIME_TAKEN'];
    sICKACCRUAL = json['SICK_ACCRUAL'];
    sICKTAKEN = json['SICK_TAKEN'];
    uSERNAME = json['USER_NAME'];
    yEARSOFSERVICE = json['YEARS_OF_SERVICE'];
    jOBNAME = json['JOB_NAME'];
    jOBNAMEAR = json['JOB_NAME_AR'];
    bASICSALARY = json['BASIC_SALARY'];
    cOUNTBADGE = json['COUNT_BADGE'];
    cERTIFICATEBADGE = json['CERTIFICATE_BADGE'];
    iNITIATIVEBADGE = json['INITIATIVE_BADGE'];
    tHANKYOUINMONTH = json['THANK_YOU_IN_MONTH'];
    tHANKYOUINYEAR = json['THANK_YOU_IN_YEAR'];
    sUGGESTOVERALLRATING = json['SUGGEST_OVERALL_RATING'];
    tHANKYOUCOUNT = json['THANKYOU_COUNT'];
    eventListModel = json['EVENTLIST'] != null ? (json['EVENTLIST']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsSuccess'] = this.isSuccess;
    data['Message'] = this.message;
    data['PERSON_ID'] = this.pERSONID;
    data['MARITAL_STATUS'] = this.mARITALSTATUS;
    data['EMPLOYEE_NUMBER'] = this.eMPLOYEENUMBER;
    data['ATTRIBUTE1'] = this.aTTRIBUTE1;
    data['PHONE_NUMBER'] = this.pHONENUMBER;
    data['SUPERVISOR_NAME_ARABIC'] = this.sUPERVISORNAMEARABIC;
    data['SUPERVISOR_NAME_ENGLISH'] = this.sUPERVISORNAMEENGLISH;
    data['FULL_NAME_AR'] = this.fULLNAMEAR;
    data['FULL_NAME_US'] = this.fULLNAMEUS;
    data['EMAIL_ADDRESS'] = this.eMAILADDRESS;
    data['NATIONALITY'] = this.nATIONALITY;
    data['DATE_OF_BIRTH'] = this.dATEOFBIRTH;
    data['HIRE_DATE'] = this.hIREDATE;
    data['DEPARTMENT_NAME'] = this.dEPARTMENTNAME;
    data['AS_OF_DATE'] = this.aSOFDATE;
    data['AS_OF_DATE_CHAR'] = this.aSOFDATECHAR;
    data['ANNUAL_ACCRUAL'] = this.aNNUALACCRUAL;
    data['ANNUAL_TAKEN'] = this.aNNUALTAKEN;
    data['PERMISSION_ACCRUAL'] = this.pERMISSIONACCRUAL;
    data['PERMISSION_TAKEN'] = this.pERMISSIONTAKEN;
    data['OVERTIME_ACCRUAL'] = this.oVERTIMEACCRUAL;
    data['OVERTIME_TAKEN'] = this.oVERTIMETAKEN;
    data['SICK_ACCRUAL'] = this.sICKACCRUAL;
    data['SICK_TAKEN'] = this.sICKTAKEN;
    data['USER_NAME'] = this.uSERNAME;
    data['YEARS_OF_SERVICE'] = this.yEARSOFSERVICE;
    data['JOB_NAME'] = this.jOBNAME;
    data['JOB_NAME_AR'] = this.jOBNAMEAR;
    data['BASIC_SALARY'] = this.bASICSALARY;
    data['COUNT_BADGE'] = this.cOUNTBADGE;
    data['CERTIFICATE_BADGE'] = this.cERTIFICATEBADGE;
    data['INITIATIVE_BADGE'] = this.iNITIATIVEBADGE;
    data['THANK_YOU_IN_MONTH'] = this.tHANKYOUINMONTH;
    data['THANK_YOU_IN_YEAR'] = this.tHANKYOUINYEAR;
    data['SUGGEST_OVERALL_RATING'] = this.sUGGESTOVERALLRATING;
    data['THANKYOU_COUNT'] = this.tHANKYOUCOUNT;
    return data;
  }

  @override
  List<Object?> get props => [];

  @override
  BaseEntity toEntity<T>() {
    return DashboardEntity();
  }

  List<EventModel>? getEventList(dynamic jsonEventArray) {
    var eventsJson = jsonEventArray as List;
    List<EventModel> events =
        eventsJson.map((eventJson) => EventModel.fromJson(eventJson)).toList();
    return events;
  }
}

extension SourceModelExtension on DashboardModel {
  DashboardEntity toDashboardEntity() {
    var dashboardEntity = DashboardEntity();
    dashboardEntity.aNNUALACCRUAL = aNNUALACCRUAL;
    dashboardEntity.sICKACCRUAL = sICKACCRUAL;
    dashboardEntity.pERMISSIONACCRUAL = pERMISSIONACCRUAL;
    dashboardEntity.tHANKYOUCOUNT = tHANKYOUCOUNT;
    dashboardEntity.tHANKYOUINYEAR = tHANKYOUINYEAR;
    dashboardEntity.eventsEntity =
        eventListModel?.map((e) => e.toEventsEntity()).toList();
    return dashboardEntity;
  }
}
