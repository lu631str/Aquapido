import 'package:water_tracker/Utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Utils isSameDay should return true when it is today', () {
    DateTime dateTimeToday = DateTime.now();

    expect(isSameDay(dateTimeToday, DateTime.now()), true);
  });

  test('Utils isSameDay should return false when it is not today', () {
    DateTime dateTimeNotToday = DateTime.parse("2001-02-27 13:27:00");

    expect(isSameDay(dateTimeNotToday, DateTime.now()), false);
  });
}