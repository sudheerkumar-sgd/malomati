// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class HrApprovalEntity extends BaseEntity {
  String? nOTIFICATIONID;
  String? fROMUSER;
  String? sUBJECTAR;
  String? sUBJECTUS;
  String? bEGINDATE;
  String? bEGINDATECHAR;
  String? dUEDATECHAR;
  String? nOTIFICATIONTYPE;
  String? fNAME;
  String? fVALUE;

  HrApprovalEntity();

  @override
  List<Object?> get props => [];
}
