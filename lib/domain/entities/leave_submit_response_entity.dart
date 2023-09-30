// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class LeaveSubmitResponseEntity extends BaseEntity {
  String? nTFID;
  String? iTEMKEY;
  String? sTATUS;
  List<String> aPPROVERSLIST = [];
  String? oRIGINALRECIPIENT;

  LeaveSubmitResponseEntity();

  @override
  List<Object?> get props =>
      [nTFID, iTEMKEY, sTATUS, aPPROVERSLIST, oRIGINALRECIPIENT];
}
