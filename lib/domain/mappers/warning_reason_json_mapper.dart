import 'package:malomati/domain/entities/name_id_entity.dart';

/// Maps warning reason JSON to [NameIdEntity] (same behavior as [WarningReasonsModel]).
class WarningReasonJsonMapper {
  WarningReasonJsonMapper._();

  static NameIdEntity toNameIdEntity(
    Map<String, dynamic> json, {
    required bool isLocalEn,
  }) {
    final nameAR = json['VALUE_AR'] as String?;
    final nameEN = json['VALUE_AR'] as String?;
    final id = '${json['ID']}';
    return NameIdEntity(id, isLocalEn ? nameEN : nameAR);
  }
}
