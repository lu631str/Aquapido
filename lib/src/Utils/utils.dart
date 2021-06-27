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

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay plusMinutes(int minutes) {
    if (minutes == 0) {
      return this;
    } else {
      int mofd = this.hour * 60 + this.minute;
      int newMofd = ((minutes % 1440) + mofd + 1440) % 1440;
      if (mofd == newMofd) {
        return this;
      } else {
        int newHour = newMofd ~/ 60;
        int newMinute = newMofd % 60;
        return TimeOfDay(hour: newHour, minute: newMinute);
      }
    }
  }
}

double getTimeOfDayRange(TimeOfDay first, TimeOfDay second) {
  if (_toDouble(first) < _toDouble(second)) {
    return _toDouble(second) - _toDouble(first);
  } else if (_toDouble(first) > _toDouble(second)) {
    return 24 - _toDouble(second) - _toDouble(first);
  }
  // if the start time equals the end time, return 15 because 15min is the smallest intervall you can select
  // So it would only rreminds you 1 time at startTime / endTime
  return 15;
}

double _toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

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
