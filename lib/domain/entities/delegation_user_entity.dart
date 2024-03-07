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
