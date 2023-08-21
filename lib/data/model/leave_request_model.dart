// ignore_for_file: must_be_immutable
class LeaveRequestModel {
  String? lEAVETYPE;
  String? uSERNAME;
  String? cREATORUSERNAME;
  String? aBSENCETYPEID;
  String? sTARTDATE;
  String? eNDDATE;
  String? sTARTTIME;
  String? eNDTIME;
  String? uSERCOMMENTS;
  String? fILENAME;
  String? bLOBFILE;
  String? fILENAMENEW_;
  String? bLOBFILENEW_;
  String? fILENAMENEW;
  String? bLOBFILENEW;
  String? aBSENCEATTENDANCEID;

  LeaveRequestModel();
}

extension SourceModelExtension on LeaveRequestModel {
  Map<String, dynamic> toJson() => {
        "LEAVE_TYPE": lEAVETYPE,
        "USER_NAME": uSERNAME,
        "CREATOR_USER_NAME": cREATORUSERNAME,
        "ABSENCE_TYPE_ID": aBSENCETYPEID,
        "START_DATE": sTARTDATE,
        "END_DATE": eNDDATE,
        "START_TIME": sTARTTIME ?? '',
        "END_TIME": eNDTIME ?? '',
        "USER_COMMENTS": uSERCOMMENTS,
        "FILE_NAME": fILENAME,
        "BLOB_FILE": bLOBFILE,
        "FILE_NAME_NEW_": fILENAMENEW_,
        "BLOB_FILE_NEW_": bLOBFILENEW_,
        "FILE_NAME_NEW": fILENAMENEW,
        "BLOB_FILE_NEW": bLOBFILENEW,
        "ABSENCE_ATTENDANCE_ID": aBSENCEATTENDANCEID,
      };
}
