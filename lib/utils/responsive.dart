import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double _textScaleFactor;

  // Call this at the start of a build method (or in a top-level widget)
  static void init(BuildContext context) {
    final mq = MediaQuery.of(context);
    screenWidth = mq.size.width;
    screenHeight = mq.size.height;
    _textScaleFactor = mq.textScaleFactor;
  }

  // Width percentage (0-100)
  static double wp(double percent) => screenWidth * percent / 100;

  // Height percentage (0-100)
  static double hp(double percent) => screenHeight * percent / 100;

  // Scales a font size relative to a base width of 375 (iPhone 8-ish)
  static double sp(double fontSize) =>
      fontSize * (screenWidth / 375) * _textScaleFactor;
}
