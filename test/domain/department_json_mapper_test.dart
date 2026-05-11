import 'package:flutter_test/flutter_test.dart';
import 'package:malomati/domain/mappers/department_json_mapper.dart';

void main() {
  group('DepartmentJsonMapper', () {
    test('toDepartmentEntity maps payroll and names', () {
      final json = <String, dynamic>{
        'Dept_Name_EN': 'IT',
        'Dept_Name_AR': 'تقنية',
        'PAYROLL_ID': 42,
      };
      final e = DepartmentJsonMapper.toDepartmentEntity(json);
      expect(e.deptNameEN, 'IT');
      expect(e.deptNameAR, 'تقنية');
      expect(e.pAYROLLID, '42');
    });
  });
}
