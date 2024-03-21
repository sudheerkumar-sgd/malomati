// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class DelegationCategoryEntity extends BaseEntity {
  String? name;
  String? displayName;
  String? description;
  String? valueType;
  String? textValue;
  String? numberValue;
  String? dateValue;
  String? type;
  String? format;
  String? messageType;
  String? messageName;
  DelegationCategoryEntity();
  @override
  String toString() {
    return displayName ?? '';
  }

  @override
  List<Object?> get props => [
        name,
        displayName,
        description,
        valueType,
        textValue,
        numberValue,
        dateValue,
        type,
        format,
        messageType,
        messageName
      ];
}
