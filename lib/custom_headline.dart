import 'package:flutter/material.dart';
import 'package:flutter_stok/theme.dart';

class CustomHeadline extends StatelessWidget {
  final String text;
  final double? fSize;
  final Color? myColor;
  final FontWeight? myFW;
  final TextOverflow? myoF;
  final TextAlign? myTa;
  final String? fontFamily;

  const CustomHeadline({
    Key? key,
    required this.text,
    this.fSize = 1,
    this.myColor,
    this.myoF,
    this.myTa,
    this.fontFamily,
    this.myFW,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: myoF,
      textAlign: myTa,
      style: TextStyle(
        fontFamily: fontFamily,
        color: myColor,
        fontWeight: myFW,
        fontSize: deviceWidth(context) * 0.065 * fSize,
      ),
    );
  }
}
