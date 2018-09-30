import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../question.dart';
import '../utils.dart';
import 'ui_blocs.dart';

class AnimatedQuestionWidget extends StatefulWidget {
  final Question question;

  final bool checked;

  final VoidCallback onValidate;
  final VoidCallback onFadeoutComplete;

  AnimatedQuestionWidget({
    Key key,
    this.question,
    this.checked,
    this.onValidate,
    this.onFadeoutComplete,
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
      _animController.forward();
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

    _animController.forward();
  }

  void _initQuestionAnim() {
    questionPosition = Tween(begin: -64.0, end: 24.0).animate(CurvedAnimation(
        parent: _animController,
        curve: Interval(0.0, 0.20, curve: Curves.ease)));
    questionOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animController,
        curve: Interval(0.0, 0.25, curve: Curves.ease)));
  }

  void _initPropsAnims() {
    propositionPositions = enumerate(widget.question.propositions)
        .map(
          (item) => Tween(
                begin: offsetYStart + (item.index * 60.0),
                end: offsetYEnd + (item.index * 40.0),
              ).animate(CurvedAnimation(
                parent: _animController,
                curve: Interval(
                  intervals[item.index + 1][0],
                  intervals[item.index + 1][1],
                  curve: Curves.ease,
                ),
              )),
        )
        .toList(growable: false);
    propositionOpacities = enumerate(widget.question.propositions)
        .map(
          (item) => Tween(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: _animController,
                curve: Interval(
                  intervals[item.index + 1][0],
                  intervals[item.index + 1][1],
                  curve: Curves.ease,
                ),
              )),
        )
        .toList(growable: false);
  }

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
        return AnimatedBloc(
            opacity: propositionOpacities[p.index].value,
            left: 24.0,
            right: 24.0,
            top: propositionPositions[p.index].value,
            child: PropBloc(prop: props[p.index]));
      }).toList(growable: false));
  }
}
