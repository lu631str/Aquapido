
import 'package:flutter/material.dart';

/// Checks if [dateTime1] and [dateTime2] are the same day.
bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
  if (dateTime1.day == dateTime2.day &&
      dateTime1.month == dateTime2.month &&
      dateTime1.year == dateTime2.year) {
    return true;
  }
  return false;
}

double _toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0;

bool isCurrentTimeOfDayOutsideTimes(TimeOfDay current, TimeOfDay startTime, TimeOfDay endTime) {

  if(_toDouble(startTime) == _toDouble(endTime)) {
    return false;
  }

  // Starttime is BEFORE 0 Uhr and Endtime is AFTER 0 Uhr
  if(_toDouble(startTime) > _toDouble(endTime)) {
    // is current time between starttime and 0 Uhr?
    if(_toDouble(current) >= _toDouble(startTime) && _toDouble(current) <= 23.99) {
      return false;
    }

    // is current time between 0 Uhr and endtime?
    if(_toDouble(current) <= _toDouble(endTime) && _toDouble(current) >= 0.0) {
      return false;
    }

  } else { // Starttime and Endtime are both before or both after 0 Uhr
    if(_toDouble(current) >= _toDouble(startTime) && _toDouble(current) <= _toDouble(endTime)) {
      return false;
    }
  }
  return true;
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
