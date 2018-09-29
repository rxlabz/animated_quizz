import 'dart:async';

import 'package:flutter/material.dart';

import '../utils.dart';

class AnimatedQuestionText extends StatefulWidget {
  final String question;
  final TextStyle style;

  final Color backgroundColor;
  final Color color;

  final double padding;

  final double top;

  const AnimatedQuestionText(
      {Key key,
      @required this.question,
      this.style,
      this.top = 48.0,
      this.backgroundColor = Colors.white,
      this.color = Colors.white,
      this.padding = 16.0})
      : super(key: key);
  @override
  AnimatedQuestionTextState createState() {
    return new AnimatedQuestionTextState();
  }
}

class AnimatedQuestionTextState extends State<AnimatedQuestionText> {
  double currentTop;
  double currentOpacity;

  @override
  void initState() {
    super.initState();
    _initializePosition();
  }

  _initializePosition() {
    currentTop = 0.0;
    currentOpacity = 0.0;
  }

  @override
  void didUpdateWidget(AnimatedQuestionText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      setState(() {
        _initializePosition();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(duration1s, _animate);
    return setPosition(
      applyOpacity(
        _buildCard(),
      ),
    );
  }

  Container _buildCard() {
    return Container(
      padding: EdgeInsets.all(widget.padding),
      decoration: rounded(widget.backgroundColor),
      child: Text(
        widget.question,
        style: widget.style.copyWith(color: widget.color),
      ),
    );
  }

  Widget setPosition(Widget child) {
    final hMargin = MediaQuery.of(context).size.width / 10;
    return AnimatedPositioned(
        duration: duration300,
        top: currentTop,
        left: hMargin,
        right: hMargin,
        curve: Curves.easeInOut,
        child: child);
  }

  Widget applyOpacity(Widget child) => AnimatedOpacity(
        opacity: currentOpacity,
        duration: duration300,
        child: child,
      );

  void _animate() => setState(() {
        currentTop = widget.top;
        currentOpacity = 1.0;
      });
}
