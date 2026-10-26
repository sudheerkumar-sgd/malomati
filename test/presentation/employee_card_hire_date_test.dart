import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:malomati/presentation/ui/home/widgets/employee_card_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

void main() {
  group('formatEmployeeCardHireDate', () {
    test('empty and null stay empty', () {
      expect(formatEmployeeCardHireDate(null), '');
      expect(formatEmployeeCardHireDate(''), '');
    });

    test('parses slash and dash formats to dd.MM.yyyy', () {
      expect(formatEmployeeCardHireDate('02/08/2015'), '02.08.2015');
      expect(formatEmployeeCardHireDate('2015-08-02'), '02.08.2015');
      expect(formatEmployeeCardHireDate('02.08.2015'), '02.08.2015');
    });

    test('returns raw value when format is unknown', () {
      expect(formatEmployeeCardHireDate('not-a-date'), 'not-a-date');
    });
  });

  group('employeeCardPlaceholderPath', () {
    test('picks emirati woman, emirati man, other woman, other man', () {
      expect(
        employeeCardPlaceholderPath(
          nationality: 'United Arab Emirates',
          sex: 'F',
        ),
        DrawableAssets.icPlaceholderEmiratiWoman,
      );
      expect(
        employeeCardPlaceholderPath(
          nationality: 'United Arab Emirates',
          sex: 'M',
        ),
        DrawableAssets.icPlaceholderEmiratiMale,
      );
      expect(
        employeeCardPlaceholderPath(nationality: 'Indian', sex: 'F'),
        DrawableAssets.icPlaceholderOtherWoman,
      );
      expect(
        employeeCardPlaceholderPath(nationality: 'Indian', sex: 'M'),
        DrawableAssets.icPlaceholderOtherMale,
      );
    });
  });

  group('employeeCardNumberSpans', () {
    test('keeps digits on the number style', () {
      const textStyle = TextStyle(fontFamily: 'AR');
      const numberStyle = TextStyle(fontFamily: 'Inter');
      final spans = employeeCardNumberSpans(
        'ص.ب: 225 +971',
        textStyle,
        numberStyle,
      );
      expect(spans, hasLength(4));
      expect((spans[1] as TextSpan).text, '225 ');
      expect((spans[1] as TextSpan).style?.fontFamily, 'Inter');
      expect((spans[3] as TextSpan).text, '971');
      expect((spans[3] as TextSpan).style?.fontFamily, 'Inter');
    });
  });
}
