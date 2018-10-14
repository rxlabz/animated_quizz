import 'package:animated_qcm/model.dart';
import 'package:animated_qcm/theme.dart';
import 'package:animated_qcm/utils.dart';
import 'package:flutter/material.dart';

class AnimatedBloc extends StatelessWidget {
  final Widget child;
  final double top;
  final double left;
  final double right;
  final double bottom;
  final double opacity;

  const AnimatedBloc(
      {Key key,
      this.child,
      this.top,
      this.opacity,
      this.left,
      this.right,
      this.bottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: Opacity(
          opacity: opacity,
          child: child,
        ));
  }
}

class TextBloc extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double padding;

  final Color backgroundColor;

  const TextBloc(
      {Key key,
      @required this.text,
      this.style,
      this.padding,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? Theme.of(context).textTheme.title;
    return roundedContainer(
        child: Text(text, style: textStyle),
        backgroundColor: backgroundColor,
        padding: padding);
  }
}

class OptionBloc extends TextBloc {
  final ValueChanged<Option<String>> onSelection;

  OptionStatus get status => option.status;

  bool get selected => option.selected;

  final Option<String> option;

  final Color color;
  final double opacity;

  const OptionBloc({
    Key key,
    @required String label,
    @required this.option,
    @required this.onSelection,
    this.color,
    this.opacity,
    TextStyle style,
    double padding,
    Color backgroundColor,
  }) : super(
            key: key,
            text: label,
            style: style,
            padding: padding,
            backgroundColor: backgroundColor);

  get inactive =>
      status != OptionStatus.none && status != OptionStatus.selected;

  get correct => status == OptionStatus.correctAndSelected;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = QuizzThemeProvider.of(context);
    final textStyle = theme.defaultTextStyle.copyWith(color: color);
    final textHeight = computeTextHeight(
        text: text, style: textStyle, width: width - 4 * padding);
    return InkWell(
      child: Opacity(
        opacity: opacity,
        child: Stack(children: [
          ConstrainedBox(
            constraints:
                BoxConstraints.expand(height: textHeight + 2 * padding),
            child: roundedContainer(
                child: Text(text, style: textStyle),
                backgroundColor: backgroundColor,
                padding: padding),
          ),
          Positioned(right: -4.0, top: padding, child: _buildIcon(color))
        ]),
      ),
      onTap: inactive ? null : () => onSelection(option),
    );
  }

  Widget _buildIcon(Color color) => correct
      ? Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            padding: margin4,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.lime),
            child: Icon(
              Icons.check,
              color: color,
              size: 16.0,
            ),
          ))
      : SizedBox();
}
