import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';

class DashboardEntity extends BaseEntity {
  int? pERSONID;
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
  int? aNNUALACCRUAL;
  int? aNNUALTAKEN;
  int? pERMISSIONACCRUAL;
  int? pERMISSIONTAKEN;
  int? oVERTIMEACCRUAL;
  int? oVERTIMETAKEN;
  int? sICKACCRUAL;
  int? sICKTAKEN;
  String? uSERNAME;
  double? yEARSOFSERVICE;
  String? jOBNAME;
  String? jOBNAMEAR;
  int? bASICSALARY;
  int? cOUNTBADGE;
  int? cERTIFICATEBADGE;
  int? iNITIATIVEBADGE;
  int? tHANKYOUINMONTH;
  int? tHANKYOUINYEAR;
  int? sUGGESTOVERALLRATING;
  int? tHANKYOUCOUNT;
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
