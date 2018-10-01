import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../question.dart';
import '../utils.dart';
import 'ui_blocs.dart';

class AnimatedQuestionWidget extends StatefulWidget {
  final Question question;
  final List<String> selection;

  final bool checked;

  final VoidCallback onValidate;
  final VoidCallback onFadeoutComplete;
  final ValueChanged<String> onSelection;

  final Duration delay;

  AnimatedQuestionWidget({
    Key key,
    this.delay = Duration.zero,
    this.question,
    this.checked,
    this.onValidate,
    this.onFadeoutComplete,
    this.selection,
    this.onSelection,
  }) : super(key: key);

  @override
  AnimatedQuestionWidgetState createState() => AnimatedQuestionWidgetState();
}

class AnimatedQuestionWidgetState extends State<AnimatedQuestionWidget>
    with TickerProviderStateMixin {
  final intervals = [
    [0.0, 0.20],
    [0.20, 0.40],
    [0.40, 0.60],
    [0.60, 0.80],
    [0.80, 1.0]
  ];
  final offsetYStart = 240.0;
  final offsetYEnd = 100.0;

  final double questionTopStart = -64.0;
  final double questionTopEnd = 20.0;

  AnimationController _animController;

  Animation<double> questionPosition;
  Animation<double> questionOpacity;

  List<Animation<double>> propositionPositions;
  List<Animation<double>> propositionOpacities;

  final forwardDuration = Duration(seconds: 1, milliseconds: 500);

  void reverse() {
    _animController
      ..duration = duration500
      ..addStatusListener(onReversed)
      ..reverse();
  }

  void onReversed(status) {
    if (status == AnimationStatus.dismissed) {
      _animController.removeStatusListener(onReversed);
      widget.onFadeoutComplete();
    }
  }

  @override
  void didUpdateWidget(AnimatedQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _animController.duration = forwardDuration;
      Future.delayed(widget.delay, _animController.forward);
    }
    if (oldWidget.checked != widget.checked) {}
  }

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: forwardDuration);

    _initQuestionAnim();

    _initPropsAnims();

    Future.delayed(widget.delay, _animController.forward);
  }

  void _initQuestionAnim() {
    questionPosition = Tween(begin: questionTopStart, end: questionTopEnd)
        .animate(CurvedAnimation(
            parent: _animController,
            curve: Interval(0.0, 0.20, curve: Curves.ease)));
    questionOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animController,
        curve: Interval(0.0, 0.25, curve: Curves.ease)));
  }

  void _initPropsAnims() {
    propositionPositions = enumerate(widget.question.propositions)
        .map((item) => _buildAnimation(
              begin: offsetYStart + (item.index * 60.0),
              end: offsetYEnd + (item.index * 40.0),
              intervalBegin: intervals[item.index + 1][0],
              intervalEnd: intervals[item.index + 1][1],
            ))
        .toList(growable: false);
    propositionOpacities = enumerate(widget.question.propositions)
        .map((item) => _buildAnimation(
              begin: 0.0,
              end: 1.0,
              intervalBegin: intervals[item.index + 1][0],
              intervalEnd: intervals[item.index + 1][1],
            ))
        .toList(growable: false);
  }

  Animation<double> _buildAnimation({
    double begin,
    double end,
    double intervalBegin,
    double intervalEnd,
  }) =>
      Tween(
        begin: begin,
        end: end,
      ).animate(CurvedAnimation(
        parent: _animController,
        curve: Interval(
          intervalBegin,
          intervalEnd,
          curve: Curves.ease,
        ),
      ));

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: _buildQuestionView,
    );
  }

  Widget _buildQuestionView(BuildContext context, Widget child) {
    return Stack(
      children: _buildAnimatedWidgets(),
    );
  }

  _buildAnimatedWidgets() {
    final props = widget.question.propositions.toList();
    return <Widget>[
      AnimatedBloc(
          opacity: questionOpacity.value,
          left: 24.0,
          right: 24.0,
          top: questionPosition.value,
          child: QuestionBloc(question: widget.question.label)),
    ]..addAll(enumerate(props).map((p) {
        final prop = props[p.index];
        return AnimatedBloc(
            opacity: propositionOpacities[p.index].value,
            left: 24.0,
            right: 24.0,
            top: propositionPositions[p.index].value,
            child: PropBloc(
              prop: prop,
              selected: widget.selection.contains(prop),
              onSelection: widget.onSelection,
            ));
      }).toList(growable: false));
  }
}
