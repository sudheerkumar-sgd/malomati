// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class DelegationUserEntity extends BaseEntity {
  String? username;
  String? displayName;
  String? orgiSystem;
  String? emailAddress;
  int? origSystemId;
  int? partitionId;
  DelegationUserEntity();
  @override
  String toString() {
    return displayName ?? '';
  }

  @override
  List<Object?> get props => [username];
}

class DelegationItemEntity extends BaseEntity {
  int? rULEID;
  String? mESSAGETYPE;
  String? bEGINDATE;
  String? eNDDATE;
  String? delegateTO;
  String? tYPEDISPLAY;
  String? aCTIONDISPLAY;
  String? nAME;
  DelegationItemEntity();

  @override
  List<Object?> get props => [rULEID];
}
