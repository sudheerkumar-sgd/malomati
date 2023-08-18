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
  String? fILENAMENEW_;
  String? fILENAMENEW;
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
        "FILE_NAME_NEW_": fILENAMENEW_,
        "FILE_NAME_NEW": fILENAMENEW,
        "ABSENCE_ATTENDANCE_ID": aBSENCEATTENDANCEID,
      };
}
