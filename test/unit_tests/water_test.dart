import 'package:flutter_test/flutter_test.dart';
import 'package:water_tracker/src/Water.dart';

final DateTime dateTime = DateTime.parse("2021-02-27 13:27:00");
final Water water = Water(dateTime: dateTime, cupSize: 300);

void main() {

  test('Water should be a placeholder when initialized with placeholder constructor', () {
    Water waterPlaceholder = Water.placeholder(300);

    expect(waterPlaceholder.isPlaceholder, true);
    expect(waterPlaceholder.cupSize, 300);
    expect(waterPlaceholder.toString(), "Add your first glass of water!");
  });

test('Water toCupSizeString should be correct', () {
    expect(water.toCupSizeString(), "300ml");
  });

  test('Water toDateString should be correct', () {
    expect(water.toDateString(), "27.02.21 - 13:27");
  });

  test('Water toString should be correct', () {
    expect(water.toString(), "300ml 27.02.21 - 13:27");
  });

  test('Water toMap should return correct map', () {
    var map = water.toMap();
    expect(map['date_time'], dateTime.millisecondsSinceEpoch);
    expect(map['cup_size'], 300);
  });
}