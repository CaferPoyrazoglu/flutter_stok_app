import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData myTheme = ThemeData(
    fontFamily: mainFont,
    iconTheme: const IconThemeData(color: Colors.black),
  );
  static const String appName = "Stok App";
  static const String mainFont = "OpenSans";
  static const double radius = 16.0;
  static const double padding = 16.0;
  static const BorderRadius myRadius =
      BorderRadius.all(Radius.circular(radius));
  static const Radius myRadiusOnly = Radius.circular(radius);
  static const EdgeInsetsGeometry myPadding = EdgeInsets.all(padding);
  static Border myBorder = Border.all(color: Colors.black45, width: 0.5);
  static BoxShadow myShadow = const BoxShadow(
    color: Colors.grey,
    offset: Offset(0.0, 0.0), //(x,y)
    blurRadius: 8.5,
  );
  //COLORS
  static const Color renkAna = Color(0xFF00704A);
  static const Color renkBeyaz = Color(0xFFffffff);
  static const Color renkSiyah = Color(0xFF242431);
}

deviceWidth(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  double mySize = size.width;
  return mySize;
}

deviceHeight(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  double mySize = size.height;
  return mySize;
}
