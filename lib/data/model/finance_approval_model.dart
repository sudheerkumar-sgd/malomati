import 'package:malomati/domain/entities/finance_approval_entity.dart';

class FinanceApprovalModel {
  var nOTIFICATIONID;
  var iTEMKEY;
  String? uSERNAME;
  String? mESSAGETYPE;
  String? oRIGINALRECIPIENT;
  String? sUBJECT;
  String? sENT;
  var cLOSED;
  String? sUPPLIERNAME;
  String? sUPPLIERSITE;
  var pODESCRIPTION;
  var tOTALAMOUNT;
  var tAXAMOUNT;
  String? fROMROLE;
  int? pOHEADERID;
  String? nOTIFICATIONDESCRIPTION;
  var jUSTIFICATION;
  String? hDRDESCRIPTION;
  String? hDRTOTAL;
  String? tAXNONRECOVERABLE;
  String? iNVOICENUMBER;
  var tOTAL;
  String? iNVOICEDATE;
  var iNVDESCRIPTION;
  var iTEMAMOUNT;
  String? bEGINDATE;
  String? dOCUMENTNUMBER;
  String? pURREQNUM;
  String? cREATIONDATE;
  String? aCTION;
  String? sTATUS;

  FinanceApprovalModel();

  FinanceApprovalModel.fromJson(Map<String, dynamic> json) {
    nOTIFICATIONID = json['NOTIFICATION_ID'];
    iTEMKEY = json['ITEM_KEY'];
    uSERNAME = json['USER_NAME'];
    mESSAGETYPE = json['MESSAGE_TYPE'];
    oRIGINALRECIPIENT = json['ORIGINAL_RECIPIENT'];
    sUBJECT = json['SUBJECT'];
    sENT = json['SENT'];
    cLOSED = json['CLOSED'];
    sUPPLIERNAME = json['SUPPLIER_NAME'] ?? json['FROM_ROLE'];
    sUPPLIERSITE = json['SUPPLIER_SITE'];
    pODESCRIPTION = json['PO_DESCRIPTION'];
    tOTALAMOUNT = json['TOTAL_AMOUNT'];
    tAXAMOUNT = json['TAX_AMOUNT'];
    fROMROLE = json['FROM_ROLE'];
    pOHEADERID = json['PO_HEADER_ID'];

    jUSTIFICATION = json['JUSTIFICATION'];
    hDRDESCRIPTION = json['HDR_DESCRIPTION'];
    hDRTOTAL = json['HDR_TOTAL'];
    tAXNONRECOVERABLE = json['TAX_NON_RECOVERABLE'];

    iNVOICENUMBER = json['INVOICE_NUMBER'];
    tOTAL = json['TOTAL'];
    iNVOICEDATE = json['INVOICE_DATE'];
    iNVDESCRIPTION = json['INV_DESCRIPTION'];
    iTEMAMOUNT = json['ITEM_AMOUNT'];
    nOTIFICATIONDESCRIPTION = json['NOTIFICATION_DESCRIPTION'];
    bEGINDATE = json['BEGIN_DATE'];
    dOCUMENTNUMBER = '${json['DOCUMENT_NUMBER']}';
    pURREQNUM = '${json['PUR_REQ_NUM']}';
    cREATIONDATE = json['CREATION_DATE'];
    aCTION = json['ACTION'];
    sTATUS = json['STATUS'];
  }
}

extension SourceModelExtension on FinanceApprovalModel {
  FinanceApprovalEntity toFinanceApprovalEntity() {
    final financeApprovalEntity = FinanceApprovalEntity();
    financeApprovalEntity.nOTIFICATIONID = nOTIFICATIONID;
    financeApprovalEntity.iTEMKEY = iTEMKEY;
    financeApprovalEntity.uSERNAME = uSERNAME;
    financeApprovalEntity.mESSAGETYPE = mESSAGETYPE;
    financeApprovalEntity.oRIGINALRECIPIENT = oRIGINALRECIPIENT;
    financeApprovalEntity.sUBJECT = sUBJECT;
    financeApprovalEntity.sENT = sENT;
    financeApprovalEntity.cLOSED = cLOSED;
    financeApprovalEntity.sUPPLIERNAME = sUPPLIERNAME;
    financeApprovalEntity.sUPPLIERSITE = sUPPLIERSITE;
    financeApprovalEntity.pODESCRIPTION = pODESCRIPTION;
    financeApprovalEntity.tOTALAMOUNT = tOTALAMOUNT;
    financeApprovalEntity.tAXAMOUNT = tAXAMOUNT;
    financeApprovalEntity.fROMROLE = fROMROLE;
    financeApprovalEntity.pOHEADERID = pOHEADERID;
    financeApprovalEntity.nOTIFICATIONDESCRIPTION = nOTIFICATIONDESCRIPTION;

    financeApprovalEntity.jUSTIFICATION = jUSTIFICATION;
    financeApprovalEntity.hDRDESCRIPTION = hDRDESCRIPTION;
    financeApprovalEntity.hDRTOTAL = hDRTOTAL;
    financeApprovalEntity.tAXNONRECOVERABLE = tAXNONRECOVERABLE;

    financeApprovalEntity.iNVOICENUMBER = iNVOICENUMBER;
    financeApprovalEntity.tOTAL = tOTAL;
    financeApprovalEntity.iNVOICEDATE = iNVOICEDATE;
    financeApprovalEntity.iNVDESCRIPTION = iNVDESCRIPTION;
    financeApprovalEntity.iTEMAMOUNT = iTEMAMOUNT;
    financeApprovalEntity.dOCUMENTNUMBER = dOCUMENTNUMBER;
    financeApprovalEntity.pURREQNUM = pURREQNUM;
    financeApprovalEntity.bEGINDATE = bEGINDATE;
    financeApprovalEntity.cREATIONDATE = cREATIONDATE;
    financeApprovalEntity.aCTION = aCTION;
    financeApprovalEntity.sTATUS = sTATUS;
    return financeApprovalEntity;
  }
}
