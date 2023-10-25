// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class WarningListEntity extends BaseEntity {
  String? date;
  String? receivedBy;
  String? reasonEN;
  String? reasonAR;
  String? note;

  WarningListEntity();

  @override
  List<Object?> get props => [date, receivedBy, reasonEN, reasonAR, note];
}
