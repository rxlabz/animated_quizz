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

class QuestionBloc extends StatelessWidget {
  final String question;

  const QuestionBloc({Key key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.title;
    return roundedContainer(child: Text(question, style: style));
  }
}

class PropBloc extends StatelessWidget {
  final ValueChanged<String> onSelection;

  final bool selected;
  final String prop;

  const PropBloc(
      {Key key, @required this.prop, @required this.onSelection, this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : Colors.grey.shade800;
    final style = Theme.of(context).textTheme.title.copyWith(color: textColor);
    return InkWell(
      child: roundedContainer(
        child: Text(prop, style: style),
        backgroundColor: selected ? Colors.blueGrey : Colors.white,
      ),
      onTap: () => onSelection(prop),
    );
  }
}
