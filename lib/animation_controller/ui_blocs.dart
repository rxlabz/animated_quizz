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
    final textStyle = style != null ? style : Theme.of(context).textTheme.title;
    return LayoutBuilder(builder: (context, constraints) {
      return roundedContainer(
          child: Text(text, style: textStyle),
          backgroundColor: backgroundColor,
          padding: padding);
    });
  }
}

class PropBloc extends StatelessWidget {
  final ValueChanged<String> onSelection;

  final bool selected;
  final String prop;
  final TextStyle style;
  final double padding;

  const PropBloc({
    Key key,
    @required this.prop,
    @required this.onSelection,
    this.selected,
    this.style,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : Colors.grey.shade800;
    final _style =
        (style ?? Theme.of(context).textTheme.title).copyWith(color: textColor);
    return InkWell(
      child: roundedContainer(
          child: Text(prop, style: _style),
          backgroundColor: selected ? Colors.cyan : Colors.white,
          padding: padding),
      onTap: () => onSelection(prop),
    );
  }
}
