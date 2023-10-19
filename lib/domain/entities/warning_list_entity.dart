// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class WarningListEntity extends BaseEntity {
  String? date;
  String? receivedBy;
  String? reason;
  String? notes;

  WarningListEntity();

  @override
  List<Object?> get props => [date, receivedBy, reason, notes];
}
