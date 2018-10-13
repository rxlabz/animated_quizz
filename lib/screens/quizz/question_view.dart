import 'dart:async';

import 'package:animated_qcm/model.dart';
import 'package:animated_qcm/screens/quizz/quizz_widgets.dart';
import 'package:animated_qcm/theme.dart';
import 'package:animated_qcm/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

const _hPaddingRatio = 20.0;
const _animationVerticalGap = 150.0;

/// widget d'animation de la question
/// organise les tweens d'opacités et de positions
/// de la question et des propositions
class AnimatedQuestionWidget extends StatefulWidget {
  final Question question;
  final List<Option<String>> selection;

  final bool validated;

  final VoidCallback onFadeoutComplete;
  final ValueChanged<Option<String>> onSelection;

  final Duration delay;

  final List<Option<String>> options;

  AnimatedQuestionWidget({
    Key key,
    @required this.question,
    @required this.options,
    this.delay = Duration.zero,
    this.validated,
    this.onFadeoutComplete,
    this.selection,
    this.onSelection,
  }) : super(key: key);

  @override
  AnimatedQuestionWidgetState createState() => AnimatedQuestionWidgetState();
}

class AnimatedQuestionWidgetState extends State<AnimatedQuestionWidget>
    with TickerProviderStateMixin {
  final double questionTopStart = -_animationVerticalGap;
  final double questionTopEnd = 20.0;

  AnimationController _animController;

  Animation<double> questionPosition;
  Animation<double> questionOpacity;

  List<Animation<double>> propositionPositions;
  List<Animation<double>> propositionOpacities;

  final forwardDuration = Duration(seconds: 1, milliseconds: 500);

  final double questionBottomMargin = 24.0;

  final double blocPadding = 12.0;

  void reverse() {
    if (_animController.status != AnimationStatus.reverse) {
      _animController
        ..duration = duration1s
        ..addStatusListener(onReversed)
        ..reverse();
    }
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
      Future.delayed(widget.delay, () {
        if (_animController != null) _animController.forward();
      });
    }
    if (oldWidget.validated != widget.validated) {}
  }

  @override
  void initState() {
    super.initState();
    _initAnim();
  }

  void _initAnim() {
    _animController =
        AnimationController(vsync: this, duration: forwardDuration);
    Future.delayed(widget.delay, _animController.forward);
  }

  void _initQuestionAnim({Interval interval}) {
    questionPosition = Tween(
      begin: questionTopStart,
      end: questionTopEnd,
    ).animate(CurvedAnimation(parent: _animController, curve: interval));

    questionOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: interval));
  }

  void _initPropsAnims(double questionHeight, TextStyle style,
      double deviceWidth, List<Interval> intervals) {
    // liste des hauteurs des propositions
    final propositionHeights = widget.question.options
        .map((p) =>
            computeTextHeight(text: p.label, style: style, width: deviceWidth) +
            blocPadding * 2 +
            blocPadding / 2)
        .toList(growable: false);

    // construit une liste d'objets d'anims de la position de chaque proposition
    propositionPositions = enumerate(widget.question.options).map((item) {
      final propositionTopOffset = questionHeight +
          questionTopEnd +
          blocPadding * 2 +
          questionBottomMargin;

      final beginVerticalPosition = propositionTopOffset +
          sum(values: propositionHeights, endIndex: item.index) +
          _animationVerticalGap;

      return _buildAnimation(
          begin: beginVerticalPosition,
          end: propositionTopOffset +
              sum(values: propositionHeights, endIndex: item.index),
          interval: intervals[item.index]);
    }).toList(growable: false);

    // construit une liste d'objets d'anims de l"opacité de chaque proposition
    propositionOpacities = enumerate(widget.question.options)
        .map((item) => _buildAnimation(
              begin: 0.0,
              end: 1.0,
              interval: intervals[item.index],
            ))
        .toList(growable: false);
  }

  Animation<double> _buildAnimation(
          {double begin, double end, Interval interval}) =>
      Tween(
        begin: begin,
        end: end,
      ).animate(CurvedAnimation(
        parent: _animController,
        curve: interval,
      ));

  @override
  void dispose() {
    if (_animController != null) {
      _animController.stop();
      _animController.dispose();
      _animController = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _animController,
      builder: (_, __) => Stack(
            children: _buildAnimatedWidgets(),
          ));

  List<Widget> _buildAnimatedWidgets() {
    final question = widget.question;
    final props = widget.options;

    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width / _hPaddingRatio;

    final theme = QuizzThemeProvider.of(context);
    final defaultTextStyle = theme.defaultTextStyle;

    _initAnimations(props, size, horizontalPadding, question, defaultTextStyle);

    return <Widget>[
      _buildQuestion(horizontalPadding, question.label, theme),
    ]..addAll(
        _buildPropositions(props, horizontalPadding),
      );
  }

  void _initAnimations(
    List props,
    Size size,
    double horizontalPadding,
    Question question,
    TextStyle style,
  ) {
    final timeline = buildTimeline(props.length + 1);
    final blocWidth = size.width - horizontalPadding * 2 - blocPadding * 2;

    final questionHeight =
        computeTextHeight(text: question.label, style: style, width: blocWidth);

    _initQuestionAnim(interval: timeline[0]);
    _initPropsAnims(questionHeight, style, blocWidth,
        timeline.getRange(1, props.length + 1).toList());
  }

  AnimatedBloc _buildQuestion(
    double horizontalPadding,
    String question,
    QuizzTheme theme,
  ) {
    return AnimatedBloc(
        opacity: questionOpacity.value,
        left: horizontalPadding,
        right: horizontalPadding,
        top: questionPosition.value,
        child: TextBloc(
          text: question,
          style: widget.validated
              ? theme.questionValidatedTextStyle
              : theme.questionTextStyle,
          padding: blocPadding,
          backgroundColor: widget.validated
              ? theme.questionValidatedBackgroundColor
              : theme.questionBackgroundColor,
        ));
  }

  List<AnimatedBloc> _buildPropositions(
    List<Option<String>> props,
    double hPadding,
  ) {
    final theme = QuizzThemeProvider.of(context);
    return enumerate(props).map((p) {
      final prop = props[p.index];
      return AnimatedBloc(
        opacity: propositionOpacities[p.index].value,
        left: hPadding,
        right: hPadding,
        top: propositionPositions[p.index].value,
        child: OptionBloc(
          option: prop,
          label: prop.label,
          padding: blocPadding,
          style: theme.optionStyle.textStyle,
          onSelection: widget.onSelection,
          color: theme.optionStyle.getColor(prop.status),
          backgroundColor: theme.optionStyle.getBackgroundColor(prop.status),
          opacity: theme.optionStyle.getOpacity(prop.status),
        ),
      );
    }).toList(growable: false);
  }
}
