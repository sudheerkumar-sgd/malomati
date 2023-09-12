import '../../domain/entities/requests_count_entity.dart';

class RequstsCountModel {
  bool? isSuccess;
  String? messageEN;
  String? uSERNAME;
  int? pRCOUNT;
  int? iNVCOUNT;
  int? pOCOUNT;
  int? hRCOUNT;
  int? requestsApprovalCount = 0;
  int? requestsRejectCount = 0;
  int? requestsPendingCount = 0;

  RequstsCountModel();

  RequstsCountModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'];
    messageEN = json['MessageEN'];
    uSERNAME = json['USER_NAME'];
    pRCOUNT = json['PR_COUNT'];
    iNVCOUNT = json['INV_COUNT'];
    pOCOUNT = json['PO_COUNT'];
    hRCOUNT = json['HR_COUNT'];
    if (json['ReqStatusCounts'] != null) {
      json['ReqStatusCounts'].forEach((v) {
        switch (v['ACTION']) {
          case 'APPROVED':
            {
              requestsApprovalCount = v['COUNT_NTF'];
            }
          case 'REJECTED':
            {
              requestsRejectCount = v['COUNT_NTF'];
            }
          case 'PENDING':
            {
              requestsPendingCount = v['COUNT_NTF'];
            }
        }
      });
    }
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
    requstsCountEntity.requestsApprovalCount = requestsApprovalCount;
    requstsCountEntity.requestsRejectCount = requestsRejectCount;
    requstsCountEntity.requestsPendingCount = requestsPendingCount;
    return requstsCountEntity;
  }
}
