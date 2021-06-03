import 'package:water_tracker/Utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Utils isToday should return true when it is today', () {
    DateTime dateTimeToday = DateTime.now();

    expect(isToday(dateTimeToday), true);
  });

  test('Utils isToday should return false when it is not today', () {
    DateTime dateTimeNotToday = DateTime.parse("2001-02-27 13:27:00");

    expect(isToday(dateTimeNotToday), false);
  });
}