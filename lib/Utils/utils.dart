
import 'package:flutter/material.dart';

/// Checks [dateTime] if it is today.
bool isToday(DateTime dateTime) {
  final DateTime now = DateTime.now();
  if (dateTime.day == now.day &&
      dateTime.month == now.month &&
      dateTime.year == now.year) {
    return true;
  }
  return false;
}

double _toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0;

bool isCurrentTimeOfDayInBetweenTimes(TimeOfDay current, TimeOfDay startTime, TimeOfDay endTime) {

  if(_toDouble(startTime) == _toDouble(endTime)) {
    return true;
  }

  // Starttime is BEFORE 0 Uhr and Endtime is AFTER 0 Uhr
  if(_toDouble(startTime) > _toDouble(endTime)) {
    // is current time between starttime and 0 Uhr?
    debugPrint('=======');
    debugPrint('startTime: ' + _toDouble(startTime).toString());
    debugPrint('endTime: ' + _toDouble(endTime).toString());
    debugPrint('current: ' + _toDouble(current).toString());
    debugPrint('=======');
    if(_toDouble(current) >= _toDouble(startTime) && _toDouble(current) <= 23.99) {
      return true;
    }

    // is current time between 0 Uhr and endtime?
    if(_toDouble(current) <= _toDouble(endTime) && _toDouble(current) >= 0.0) {
      return true;
    }

  } else { // Starttime and Endtime are both before or both after 0 Uhr
    if(_toDouble(current) >= _toDouble(startTime) && _toDouble(current) >= _toDouble(endTime)) {
      return true;
    }
  }
  return false;
}

int getImageIndex(int cupSize) {
    switch (cupSize) {
      case 100:
        return 0;
        break;
      case 200:
        return 1;
        break;
      case 300:
        return 2;
        break;
      case 330:
        return 3;
        break;
      case 400:
        return 4;
        break;
      case 500:
        return 5;
        break;
      default:
        return 6;
    }
  }
