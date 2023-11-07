// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class InvoiceListEntity extends BaseEntity {
  String? departmentId;
  String? departmentName;
  String? invoiceID;
  String? invoiceDate;
  String? invoiceNumber;
  String? vendorName;
  String? invoiceAmount;
  String? invoiceType;
  String? description;

  InvoiceListEntity();

  @override
  List<Object?> get props => [
        invoiceID,
      ];

  @override
  String toString() {
    return invoiceID ?? '';
  }
}
