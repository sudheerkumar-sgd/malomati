import 'package:malomati/domain/entities/finance_details_item_entity.dart';

class FinanceDetailsItemModel {
  int? nOTIFICATIONID;
  String? iNVOICENUM;
  String? dESCRIPTION;
  var aMOUNT;
  var qUANTITYINVOICED;
  var uNITMEASLOOKUPCODE;
  var uNITPRICE;
  var uOM;
  var pONUMBER;
  int? iNVOICEID;
  String? iNVOICEDATE;
  var iNVOICEAMOUNT;
  var tOTALTAXAMOUNT;
  var iNVOICEBEFOREAMOUNT;
  String? pAYMENTMETHODCODE;
  int? lINENUM;
  String? iTEMDESCRIPTION;
  int? qUANTITY;
  String? nEEDBYDATE;
  String? sEGMENT1;
  int? pOHEADERID;
  var lINEAMOUNT;
  String? iTEMNUMBER;
  String? vENDORNAME;

  FinanceDetailsItemModel();

  FinanceDetailsItemModel.fromJson(Map<String, dynamic> json) {
    nOTIFICATIONID = json['NOTIFICATION_ID'];
    iNVOICENUM = json['INVOICE_NUM'];
    dESCRIPTION = json['DESCRIPTION'];
    aMOUNT = json['AMOUNT'];
    qUANTITYINVOICED = json['QUANTITY_INVOICED'];
    uNITMEASLOOKUPCODE = json['UNIT_MEAS_LOOKUP_CODE'];
    uNITPRICE = json['UNIT_PRICE'];
    uOM = json['UOM'];
    pONUMBER = json['PO_NUMBER'];
    iNVOICEID = json['INVOICE_ID'];
    iNVOICEDATE = json['INVOICE_DATE'];
    iNVOICEAMOUNT = json['INVOICE_AMOUNT'];
    tOTALTAXAMOUNT = json['TOTAL_TAX_AMOUNT'];
    iNVOICEBEFOREAMOUNT = json['INVOICE_BEFORE_AMOUNT'];
    pAYMENTMETHODCODE = json['PAYMENT_METHOD_CODE'];
    pOHEADERID = json['PO_HEADER_ID'];
    iTEMDESCRIPTION = json['ITEM_DESCRIPTION'];
    lINENUM = json['LINE_NUM'];
    qUANTITY = json['QUANTITY'];
    lINEAMOUNT = json['LINE_AMOUNT'];
    nEEDBYDATE = json['NEED_BY_DATE'];
    iTEMNUMBER = json['ITEM_NUMBER'];
    vENDORNAME = json['VENDOR_NAME'];
    sEGMENT1 = json['SEGMENT1'];
  }
}

extension SourceModelExtension on FinanceDetailsItemModel {
  FinanceDetailsItemEntity toFinanceDetailsItemEntity() {
    final financeDetailsItemEntity = FinanceDetailsItemEntity();
    financeDetailsItemEntity.nOTIFICATIONID = nOTIFICATIONID;
    financeDetailsItemEntity.iNVOICENUM = iNVOICENUM;
    financeDetailsItemEntity.dESCRIPTION = dESCRIPTION;
    financeDetailsItemEntity.aMOUNT = aMOUNT;
    financeDetailsItemEntity.qUANTITYINVOICED = qUANTITYINVOICED;
    financeDetailsItemEntity.uNITMEASLOOKUPCODE = uNITMEASLOOKUPCODE;
    financeDetailsItemEntity.uNITPRICE = uNITPRICE;
    financeDetailsItemEntity.uOM = uOM;
    financeDetailsItemEntity.pONUMBER = pONUMBER;
    financeDetailsItemEntity.iNVOICEID = iNVOICEID;
    financeDetailsItemEntity.iNVOICEDATE = iNVOICEDATE;
    financeDetailsItemEntity.iNVOICEAMOUNT = iNVOICEAMOUNT;
    financeDetailsItemEntity.tOTALTAXAMOUNT = tOTALTAXAMOUNT;
    financeDetailsItemEntity.iNVOICEBEFOREAMOUNT = iNVOICEBEFOREAMOUNT;
    financeDetailsItemEntity.pAYMENTMETHODCODE = pAYMENTMETHODCODE;
    financeDetailsItemEntity.lINENUM = lINENUM;
    financeDetailsItemEntity.iTEMDESCRIPTION = iTEMDESCRIPTION;
    financeDetailsItemEntity.qUANTITY = qUANTITY;
    financeDetailsItemEntity.nEEDBYDATE = nEEDBYDATE;
    financeDetailsItemEntity.sEGMENT1 = sEGMENT1;
    financeDetailsItemEntity.pOHEADERID = pOHEADERID;
    financeDetailsItemEntity.lINEAMOUNT = lINEAMOUNT;
    financeDetailsItemEntity.iTEMNUMBER = iTEMNUMBER;
    financeDetailsItemEntity.vENDORNAME = vENDORNAME;
    return financeDetailsItemEntity;
  }
}
