// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';

class DashboardEntity extends BaseEntity {
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
  double? yEARSOFSERVICE;
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
  List<EventsEntity>? eventsEntity;

  DashboardEntity();

  @override
  List<Object?> get props => [
        pERSONID,
        mARITALSTATUS,
        eMPLOYEENUMBER,
        aTTRIBUTE1,
        pHONENUMBER,
        sUPERVISORNAMEARABIC,
        sUPERVISORNAMEENGLISH,
        fULLNAMEAR,
        fULLNAMEUS,
        eMAILADDRESS,
        nATIONALITY,
        dATEOFBIRTH,
        hIREDATE,
        dEPARTMENTNAME,
        aSOFDATE,
        aSOFDATECHAR,
        aNNUALACCRUAL,
        aNNUALTAKEN,
        pERMISSIONACCRUAL,
        pERMISSIONTAKEN,
        oVERTIMEACCRUAL,
        oVERTIMETAKEN,
        sICKACCRUAL,
        sICKTAKEN,
        uSERNAME,
        yEARSOFSERVICE,
        jOBNAME,
        jOBNAMEAR,
        bASICSALARY,
        cOUNTBADGE,
        cERTIFICATEBADGE,
        iNITIATIVEBADGE,
        tHANKYOUINMONTH,
        tHANKYOUINYEAR,
        sUGGESTOVERALLRATING,
        tHANKYOUCOUNT
      ];
}
