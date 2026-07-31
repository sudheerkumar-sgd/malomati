import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:malomati/core/common/common_utils.dart';

void main() {
  group('isSummerMonth', () {
    test('covers July through 28 Aug', () {
      expect(isSummerMonth(DateTime(2026, 7, 1)), isFalse);
      expect(isSummerMonth(DateTime(2026, 7, 31)), isFalse);
      expect(isSummerMonth(DateTime(2026, 8, 28)), isTrue);
      expect(isSummerMonth(DateTime(2026, 8, 29)), isFalse);
      expect(isSummerMonth(DateTime(2026, 9, 1)), isFalse);
    });
  });

  group('getWorkingHours / getWorkingEndTime', () {
    test('weekday summer is 7h ending 15:00', () {
      final thu = DateTime(2026, 8, 1); // Thursday
      expect(getWorkingHours(thu), const Duration(hours: 7));
      expect(getWorkingEndTime(thu), const TimeOfDay(hour: 15, minute: 0));
    });

    test('weekday non-summer is 8h ending 16:00', () {
      final thu = DateTime(2026, 9, 3); // Thursday
      expect(getWorkingHours(thu), const Duration(hours: 8));
      expect(getWorkingEndTime(thu), const TimeOfDay(hour: 16, minute: 0));
    });

    test('Friday stays 4h30 ending 12:30 even in summer', () {
      final fri = DateTime(2026, 7, 31); // Friday
      expect(getWorkingHours(fri), const Duration(hours: 4, minutes: 30));
      expect(getWorkingEndTime(fri), const TimeOfDay(hour: 12, minute: 30));
    });
  });
}
