import 'package:flutter/material.dart';

import 'model/question.dart';

const duration1s = Duration(seconds: 1);
const duration150 = Duration(milliseconds: 150);
const duration300 = Duration(milliseconds: 300);
const duration500 = Duration(milliseconds: 300);

const margin32 = EdgeInsets.all(32.0);
const margin16 = EdgeInsets.all(16.0);
const margin8 = EdgeInsets.all(8.0);
const margin4 = EdgeInsets.all(4.0);

const validatedQuizzColor = Color(0xFFE6EE9C);
const failQuizzColor = Color(0xFFFFE082);

const defaultPageColor = Color(0xffeeedf2);
const correctPageColor = Color(0xFFCDDC39);
const incorrectPageColor = Color(0xFFFFD740);

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

Widget buildAnimatedBackground(ItemStatus status) {
  return SizedBox.expand(
    child: AnimatedContainer(
      duration: duration500,
      color: getPageStatusBackgroundColor(status),
    ),
  );
}

Color getPageStatusBackgroundColor(ItemStatus pageStatus) {
  Color color;
  switch (pageStatus) {
    case ItemStatus.none:
      color = defaultPageColor;
      break;
    case ItemStatus.correct:
      color = correctPageColor;
      break;
    case ItemStatus.incorrect:
      color = incorrectPageColor;
      break;
  }
  return color;
}

class ThemeProvider extends InheritedWidget {
  final QuizzTheme theme;

  ThemeProvider(this.theme);

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return oldWidget.theme != theme;
  }
}

class QuizzTheme {
  final TextStyle defaultTextStyle;

  final TextStyle questionTextStyle;
  final Color questionBackgroundColor;
  final Color questionColor;

  final Color optionBackgroundColor;
  final Color optionColor;

  QuizzTheme({
    this.defaultTextStyle,
    this.questionTextStyle,
    this.questionBackgroundColor,
    this.questionColor,
    this.optionBackgroundColor,
    this.optionColor,
  });
}
