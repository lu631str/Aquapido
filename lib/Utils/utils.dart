import 'package:flutter/material.dart';

const double IMAGE_HEIGHT = 100.0;

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

final List<Image> cupImages = [
  Image.asset(
    'assets/images/cup_100ml.png',
    height: IMAGE_HEIGHT,
  ),
  Image.asset(
    'assets/images/cup_200ml.png',
    height: IMAGE_HEIGHT,
  ),
  Image.asset(
    'assets/images/cup_300ml.png',
    height: IMAGE_HEIGHT,
  ),
  Image.asset(
    'assets/images/cup_330ml.png',
    height: IMAGE_HEIGHT,
  ),
  Image.asset(
    'assets/images/cup_400ml.png',
    height: IMAGE_HEIGHT,
  ),
  Image.asset(
    'assets/images/cup_500ml.png',
    height: IMAGE_HEIGHT,
  ),
  Image.asset(
    'assets/images/cup_custom.png',
    height: IMAGE_HEIGHT,
  ),
];

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
