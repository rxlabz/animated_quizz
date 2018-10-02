import 'package:animated_qcm/model.dart';
import 'package:animated_qcm/theme.dart';
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

class PropBloc extends TextBloc {
  final ValueChanged<Option<String>> onSelection;

  PropositionStatus get status => option.status;

  bool get selected => option.selected;

  final Option<String> option;

  const PropBloc(
      {Key key,
      @required this.option,
      @required String label,
      @required this.onSelection,
      TextStyle style,
      double padding,
      Color backgroundColor})
      : super(
            key: key,
            text: label,
            style: style,
            padding: padding,
            backgroundColor: backgroundColor);

  Color get _backgroundColor {
    Color color;
    switch (status) {
      case PropositionStatus.none:
        color = selected ? Colors.cyan : Colors.white;
        break;
      case PropositionStatus.correctAndSelected:
      case PropositionStatus.correctButNotSelected:
        color = Colors.green.shade700;
        break;
      case PropositionStatus.incorrectButSelected:
        color = Colors.deepOrange.shade400;
        break;
      case PropositionStatus.incorrectNotSelected:
        color = Colors.white;
        break;
    }
    return color;
  }

  Color get _color {
    Color color;
    switch (status) {
      case PropositionStatus.none:
        color = selected ? Colors.white : Colors.grey.shade800;
        break;
      case PropositionStatus.correctAndSelected:
      case PropositionStatus.correctButNotSelected:
        color = Colors.white;
        break;
      case PropositionStatus.incorrectButSelected:
      case PropositionStatus.incorrectNotSelected:
        color = Colors.grey.shade600;
        break;
    }
    return color;
  }

  double get _opacity {
    double opacity;
    switch (status) {
      case PropositionStatus.none:
        opacity = inactive ? 0.5 : 1.0;
        break;
      case PropositionStatus.correctAndSelected:
      case PropositionStatus.correctButNotSelected:
        opacity = 1.0;
        break;
      case PropositionStatus.incorrectButSelected:
      case PropositionStatus.incorrectNotSelected:
        opacity = 0.5;
        break;
    }
    return opacity;
  }

  get inactive => status != PropositionStatus.none;
  get correct => status == PropositionStatus.correctAndSelected;

  @override
  Widget build(BuildContext context) {
    final _style =
        (style ?? Theme.of(context).textTheme.title).copyWith(color: _color);

    return InkWell(
      child: Opacity(
        opacity: _opacity,
        child: roundedContainer(
            child: Row(
              children: <Widget>[
                correct
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.check,
                          color: _color,
                        ),
                      )
                    : SizedBox(),
                Text(text, style: _style),
              ],
            ),
            backgroundColor: _backgroundColor,
            padding: padding),
      ),
      onTap: inactive ? null : () => onSelection(option),
    );
  }
}
