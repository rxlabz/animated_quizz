import 'dart:async';

import 'package:animated_qcm/question.dart';
import 'package:animated_qcm/utils.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

class AnimatedProposition<T> extends StatefulWidget {
  final T prop;
  final int index;
  final TextStyle style;
  final Duration delay;
  final ValueChanged<T> onSelection;
  final Color backgroundColor;

  final double hMargin;
  final double padding;

  final bool selected;
  final ItemStatus status;

  AnimatedProposition(
    IndexedValue<T> item, {
    Key key,
    @required this.onSelection,
    @required this.style,
    @required this.status,
    this.delay = Duration.zero,
    this.backgroundColor = Colors.white,
    this.hMargin,
    this.padding,
    this.selected = false,
  })  : index = item.index,
        prop = item.value,
        super(key: key);

  @override
  _AnimatedPropositionState createState() => _AnimatedPropositionState();
}

class _AnimatedPropositionState extends State<AnimatedProposition> {
  double currentTop = 100.0;
  double currentLeft = 0.0;
  double currentOpacity = 0.0;

  Color get _backgroundColor =>
      widget.selected ? Colors.cyan : widget.backgroundColor;

  @override
  Widget build(BuildContext context) {
    Future.delayed(widget.delay, _animate);

    return setPosition(
        applyOpacity(
          InkWell(
            onTap: _select,
            child: AnimatedContainer(
              duration: duration150,
              decoration: rounded(_backgroundColor),
              padding: EdgeInsets.all(widget.padding),
              child: Text(
                widget.prop,
                style: widget.style.copyWith(
                  color: widget.selected ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ),
          ),
        ),
        widget.hMargin);
  }

  Widget applyOpacity(Widget child) => AnimatedOpacity(
        duration: duration300,
        opacity: currentOpacity,
        child: child,
      );

  Widget setPosition(Widget child, double hMargin) => AnimatedPositioned(
        top: currentTop * (widget.index + 1),
        left: hMargin,
        right: hMargin,
        child: child,
        duration: duration150,
      );

  void _animate() => setState(() {
        currentOpacity = 1.0;
        currentTop = 72.0;
      });

  void _select() => widget.onSelection(widget.prop);
}
