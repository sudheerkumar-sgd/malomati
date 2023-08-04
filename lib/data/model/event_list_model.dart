import 'package:malomati/domain/entities/events_entity.dart';

class EventListModel {
  int? pERSONID;
  String? eMPLOYEENUMBER;
  String? dEPARTMENTENG;
  String? fULLNAMEAR;
  String? fULLNAMEUS;
  String? eMAILADDRESS;
  String? nATIONALITY;
  String? dATEOFBIRTH;
  String? dEPARTMENTNAME;
  String? uSERNAME;

  EventListModel(
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

  EventListModel.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PERSON_ID'] = this.pERSONID;
    data['EMPLOYEE_NUMBER'] = this.eMPLOYEENUMBER;
    data['DEPARTMENT_ENG'] = this.dEPARTMENTENG;
    data['FULL_NAME_AR'] = this.fULLNAMEAR;
    data['FULL_NAME_US'] = this.fULLNAMEUS;
    data['EMAIL_ADDRESS'] = this.eMAILADDRESS;
    data['NATIONALITY'] = this.nATIONALITY;
    data['DATE_OF_BIRTH'] = this.dATEOFBIRTH;
    data['DEPARTMENT_NAME'] = this.dEPARTMENTNAME;
    data['USER_NAME'] = this.uSERNAME;
    return data;
  }
}

extension SourceModelExtension on EventListModel {
  EventsEntity toEventsEntity() {
    var eventsEntity = EventsEntity();
    eventsEntity.fULLNAMEAR = fULLNAMEAR;
    eventsEntity.fULLNAMEUS = fULLNAMEUS;
    return eventsEntity;
  }
}
