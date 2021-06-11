import 'package:flutter/material.dart';

class Constants {
  static const double IMAGE_HEIGHT = 100.0;
  static const List<int> cupSizes = [100, 200, 300, 330, 400, 500];

  static final List<Image> cupImages = [
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
}
