import '../../domain/entities/requests_count_entity.dart';

class RequstsCountModel {
  bool? isSuccess;
  String? messageEN;
  String? uSERNAME;
  int? pRCOUNT;
  int? iNVCOUNT;
  int? pOCOUNT;
  int? hRCOUNT;

  RequstsCountModel();

  RequstsCountModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    messageEN = json['MessageEN'];
    uSERNAME = json['USER_NAME'];
    pRCOUNT = json['PR_COUNT'];
    iNVCOUNT = json['INV_COUNT'];
    pOCOUNT = json['PO_COUNT'];
    hRCOUNT = json['HR_COUNT'];
  }
}

extension SourceModelExtension on RequstsCountModel {
  RequestsCountEntity toRequstsCountEntity() {
    var requstsCountEntity = RequestsCountEntity();
    requstsCountEntity.isSuccess = isSuccess;
    requstsCountEntity.messageEN = messageEN;
    requstsCountEntity.uSERNAME = uSERNAME;
    requstsCountEntity.pRCOUNT = pRCOUNT;
    requstsCountEntity.iNVCOUNT = iNVCOUNT;
    requstsCountEntity.pOCOUNT = pOCOUNT;
    requstsCountEntity.hRCOUNT = hRCOUNT;
    return requstsCountEntity;
  }
}
