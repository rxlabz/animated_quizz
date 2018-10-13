import 'package:flutter/material.dart';
import 'package:quiver/time.dart';

///
/// calcul la taille d'un Text en fonction de sa police et largeur
///
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

///
/// calcul la somme des valeurs d'un tableau entre 2 index ou total
///
num sum({List<num> values, int startIndex = 0, int endIndex}) {
  if (values.isEmpty) return 0;
  endIndex = endIndex ?? values.length - 1;
  return values
      .sublist(startIndex, endIndex)
      .fold(0, (previous, current) => previous + current);
}

///
/// construit un tableau d'intervals réguliers sur 1second
/// en fonction d'un nombre de pas
///
List<Interval> buildTimeline(int stepCount, {Curve curve = Curves.ease}) {
  final stepDuration = aSecond * (1 / stepCount);
  final List<Interval> timeline = List.generate(stepCount, (value) {
    return Interval(value * stepDuration.inMilliseconds / 1000,
        (value + 1) * stepDuration.inMilliseconds / 1000,
        curve: curve);
  });
  return timeline;
}
