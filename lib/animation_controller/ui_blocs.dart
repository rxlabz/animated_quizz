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
    return roundedContainer(child: Text(question));
  }
}

class PropBloc extends StatelessWidget {
  final ValueChanged<String> onSelection;

  final String prop;

  const PropBloc({Key key, @required this.prop, @required this.onSelection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: roundedContainer(child: Text(prop)),
      onTap: () => onSelection(prop),
    );
  }
}
