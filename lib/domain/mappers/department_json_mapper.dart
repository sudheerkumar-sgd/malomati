import 'package:malomati/domain/entities/department_entity.dart';
import 'package:malomati/domain/entities/thankyou_reason_entity.dart';

/// Maps API JSON to domain entities (no data-layer dependency).
class DepartmentJsonMapper {
  DepartmentJsonMapper._();

  static DepartmentEntity toDepartmentEntity(Map<String, dynamic> json) {
    final entity = DepartmentEntity();
    entity.deptNameEN = json['Dept_Name_EN'] as String?;
    entity.deptNameAR = json['Dept_Name_AR'] as String?;
    entity.pAYROLLID = '${json['PAYROLL_ID']}';
    return entity;
  }

  static ThankyouReasonEntity toThankyouReasonEntity(
      Map<String, dynamic> json) {
    final entity = ThankyouReasonEntity();
    entity.lOOKUP_CODE = '${json['LOOKUP_CODE']}';
    entity.mEANING = '${json['MEANING']}';
    entity.attribute8 = '${json['attribute8']}';
    return entity;
  }
}
