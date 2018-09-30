import 'package:flutter/material.dart';

const duration1s = Duration(seconds: 1);
const duration150 = Duration(milliseconds: 150);
const duration300 = Duration(milliseconds: 300);
const duration500 = Duration(milliseconds: 300);

const margin32 = EdgeInsets.all(32.0);
const margin16 = EdgeInsets.all(16.0);
const margin8 = EdgeInsets.all(8.0);
const margin4 = EdgeInsets.all(4.0);

BoxDecoration rounded(Color color, {double radius = 12.0}) => BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    );

Widget roundedContainer(
        {@required Widget child,
        Color backgroundColor = Colors.white,
        double padding = 8.0}) =>
    AnimatedContainer(
      duration: duration150,
      decoration: rounded(backgroundColor),
      padding: EdgeInsets.all(padding),
      child: child,
    );

double computeTextHeight({
  String text,
  TextStyle style,
  double width,
}) {
  final tPainter = new TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr);
  tPainter.layout(minWidth: width, maxWidth: width);
  return tPainter.height;
}
