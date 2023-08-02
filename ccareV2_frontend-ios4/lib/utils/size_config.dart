import 'package:flutter/material.dart';
import 'package:path/path.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData = MediaQuery.of(context as BuildContext);
  static double bottomInsets = _mediaQueryData.viewInsets.bottom;
  static double screenWidth = _mediaQueryData.size.width;
  static double screenHeight = _mediaQueryData.size.height;
  static Orientation orientation = _mediaQueryData.orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    bottomInsets = _mediaQueryData.viewInsets.bottom;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;

  return (inputWidth / 375.0) * screenWidth;
}
