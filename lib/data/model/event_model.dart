import 'package:malomati/domain/entities/events_entity.dart';

class EventModel {
  int? pERSONID;
  String? eVENTTYPE;
  String? eMPLOYEENUMBER;
  String? dEPARTMENTENG;
  String? fULLNAMEAR;
  String? fULLNAMEUS;
  String? eMAILADDRESS;
  String? nATIONALITY;
  String? dATEOFBIRTH;
  String? dEPARTMENTNAME;
  String? uSERNAME;
  String? sTARTDATE;
  String? nAME;

  EventModel(
      {this.pERSONID,
      this.eMPLOYEENUMBER,
      this.dEPARTMENTENG,
      this.fULLNAMEAR,
      this.fULLNAMEUS,
      this.eMAILADDRESS,
      this.nATIONALITY,
      this.dATEOFBIRTH,
      this.dEPARTMENTNAME,
      this.uSERNAME});

  EventModel.fromJson(Map<String, dynamic> json) {
    eVENTTYPE = json['EVENT_TYPE'];
    pERSONID = json['PERSON_ID'];
    eMPLOYEENUMBER = json['EMPLOYEE_NUMBER'];
    dEPARTMENTENG = json['DEPARTMENT_ENG'];
    fULLNAMEAR = json['FULL_NAME_AR'];
    fULLNAMEUS = json['FULL_NAME_US'];
    eMAILADDRESS = json['EMAIL_ADDRESS'];
    nATIONALITY = json['NATIONALITY'];
    dATEOFBIRTH = json['DATE_OF_BIRTH'];
    dEPARTMENTNAME = json['DEPARTMENT_NAME'];
    uSERNAME = json['USER_NAME'];
  }

  EventModel.fromHolidaysJson(Map<String, dynamic> json) {
    sTARTDATE = json['START_DATE'];
    nAME = json['NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EVENT_TYPE'] = eVENTTYPE;
    data['PERSON_ID'] = pERSONID;
    data['EMPLOYEE_NUMBER'] = eMPLOYEENUMBER;
    data['DEPARTMENT_ENG'] = dEPARTMENTENG;
    data['FULL_NAME_AR'] = fULLNAMEAR;
    data['FULL_NAME_US'] = fULLNAMEUS;
    data['EMAIL_ADDRESS'] = eMAILADDRESS;
    data['NATIONALITY'] = nATIONALITY;
    data['DATE_OF_BIRTH'] = dATEOFBIRTH;
    data['DEPARTMENT_NAME'] = dEPARTMENTNAME;
    data['USER_NAME'] = uSERNAME;
    return data;
  }
}

extension SourceModelExtension on EventModel {
  EventsEntity toEventsEntity() {
    var eventsEntity = EventsEntity();
    eventsEntity.eVENTTYPE = eVENTTYPE;
    eventsEntity.fULLNAMEAR = fULLNAMEAR;
    eventsEntity.fULLNAMEUS = fULLNAMEUS;
    return eventsEntity;
  }

  EventsEntity toHolidaysEventsEntity() {
    var eventsEntity = EventsEntity();
    eventsEntity.sTARTDATE = sTARTDATE;
    eventsEntity.nAME = nAME;
    return eventsEntity;
  }
}
