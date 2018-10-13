import 'package:animated_qcm/model.dart';
import 'package:flutter/material.dart';

import 'model/question.dart';

export 'quizz_theme_provider.dart';

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

  final OptionStyle optionStyle;

  final Color questionBackgroundColor;
  final Color questionColor;
  final Color questionValidatedColor;
  final Color questionValidatedBackgroundColor;

  final Color fabColor;
  final Color fabValidatedColor;
  final Color fabDisabledColor;

  final Color spinnerColor;

  TextStyle get questionTextStyle =>
      defaultTextStyle.copyWith(color: questionColor);

  TextStyle get questionValidatedTextStyle =>
      defaultTextStyle.copyWith(color: questionValidatedColor);

  QuizzTheme({
    this.defaultTextStyle,
    this.optionStyle,
    this.questionColor = Colors.white,
    this.questionValidatedColor =
        const Color(0xFF616161) /*Colors.grey.shade700*/,
    this.questionBackgroundColor = Colors.blueGrey,
    this.questionValidatedBackgroundColor = Colors.white,
    this.fabColor = const Color(0xFFD81B60) /* Pink 600 */,
    this.fabValidatedColor = const Color(0xFF7CB342) /* LightGreen 600*/,
    this.fabDisabledColor = const Color(0xFFE0E0E0) /* Grey 300*/,
    this.spinnerColor = Colors.cyan,
  });

  Duration animationDelay({bool isFirst}) =>
      isFirst ? duration500 : duration150;
}

class OptionStyle {
  final TextStyle textStyle;
  final Color optionBackgroundColor;
  final Color optionSelectedBackgroundColor;
  final Color optionCorrectBackgroundColor;
  final Color optionIncorrectBackgroundColor;
  final Color optionIncorrectSelectedBackgroundColor;
  final Color optionColor;
  final Color optionSelectedColor;
  final Color optionCorrectColor;
  final Color optionIncorrectColor;
  final Color optionIncorrectSelectedColor;

  OptionStyle(
      {this.optionColor = const Color(0xFF424242) /*Colors.grey.shade800*/,
      this.optionSelectedColor = Colors.white,
      this.optionCorrectColor = Colors.white,
      this.optionIncorrectColor =
          const Color(0xFF757575) /*Colors.grey.shade600*/,
      this.optionIncorrectSelectedColor = Colors.white,
      this.optionBackgroundColor = Colors.white,
      this.optionSelectedBackgroundColor = Colors.cyan,
      this.optionCorrectBackgroundColor =
          const Color(0xFF388E3C) /*Colors.green.shade700*/,
      this.optionIncorrectBackgroundColor = Colors.white,
      this.optionIncorrectSelectedBackgroundColor =
          const Color(0xFFFF7043) /*Colors.deepOrange.shade400*/,
      @required this.textStyle});

  Color getBackgroundColor(OptionStatus status) {
    Color color;
    switch (status) {
      case OptionStatus.none:
        color = optionBackgroundColor;
        break;
      case OptionStatus.selected:
        color = optionSelectedBackgroundColor;
        break;
      case OptionStatus.correctAndSelected:
      case OptionStatus.correctButNotSelected:
        color = optionCorrectBackgroundColor;
        break;
      case OptionStatus.incorrectButSelected:
        color = optionIncorrectSelectedBackgroundColor;
        break;
      case OptionStatus.incorrectNotSelected:
        color = optionIncorrectBackgroundColor;
        break;
    }
    return color;
  }

  Color getColor(OptionStatus status) {
    Color color;
    switch (status) {
      case OptionStatus.none:
        color = optionColor;
        break;
      case OptionStatus.selected:
        color = optionSelectedColor;
        break;
      case OptionStatus.correctAndSelected:
      case OptionStatus.correctButNotSelected:
        color = optionCorrectColor;
        break;
      case OptionStatus.incorrectButSelected:
        color = optionIncorrectSelectedColor;
        break;
      case OptionStatus.incorrectNotSelected:
        color = optionIncorrectColor;
        break;
    }
    return color;
  }

  double getOpacity(OptionStatus status) {
    double opacity;
    switch (status) {
      case OptionStatus.none:
      case OptionStatus.selected:
        opacity = 1.0;
        break;
      case OptionStatus.correctAndSelected:
      case OptionStatus.correctButNotSelected:
        opacity = 1.0;
        break;
      case OptionStatus.incorrectButSelected:
      case OptionStatus.incorrectNotSelected:
        opacity = 0.5;
        break;
    }
    return opacity;
  }
}
