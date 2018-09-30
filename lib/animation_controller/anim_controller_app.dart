import 'package:animated_qcm/utils.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../question.dart';

class AnimControllerApp extends StatefulWidget {
  @override
  _AnimControllerAppState createState() => _AnimControllerAppState();
}

class _AnimControllerAppState extends State<AnimControllerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuestionPlayerScreen(questions: questions),
    );
  }
}

class QuestionPlayerScreen extends StatefulWidget {
  final List<Question> questions;

  const QuestionPlayerScreen({Key key, this.questions}) : super(key: key);

  @override
  _QuestionPlayerScreenState createState() => _QuestionPlayerScreenState();
}

class _QuestionPlayerScreenState extends State<QuestionPlayerScreen> {
  int questionIndex;

  final pageKey = GlobalKey<_AnimatedQuestionWidgetState>();

  bool checked = false;

  bool get complete => questionIndex + 1 < widget.questions.length;

  @override
  void initState() {
    super.initState();
    print('_QuestionPlayerScreenState.initState... ${questions.length}');
    questionIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    print('_QuestionPlayerScreenState.build... $questionIndex');
    return Scaffold(
      backgroundColor: Color(0xffeeedf2),
      floatingActionButton: _buildFAB(),
      body: SafeArea(
        bottom: false,
        child: AnimatedQuestionWidget(
          key: pageKey,
          question: widget.questions[questionIndex],
          checked: checked,
          onValidate: _onQuestionValidated,
          /*onNext: _onNext,*/
          onFadeoutComplete: _onFadeoutComplete,
        ),
      ),
    );
  }

  void _onQuestionValidated() {
    print('_QuestionPlayerScreenState._onQuestionValidated... ');
  }

  void _onNext() {
    print('_QuestionPlayerScreenState._onNext... ');
    setState(() {
      //questionIndex += 1;
      pageKey.currentState.reverse();
    });
  }

  void _onFadeoutComplete() {
    print('_QuestionPlayerScreenState._onFadeoutComplete... ');
    setState(() {
      checked = false;
      if (questionIndex == widget.questions.length - 1) return;

      questionIndex += 1;
    });
  }

  void _validate() {
    setState(() {
      checked = true;
    });
    //pageKey.currentState.reverse();
  }

  Widget _buildFAB() {
    final buttonLabel = checked ? (complete ? 'Next' : 'End') : 'Validate';
    return FloatingActionButton.extended(
        onPressed: checked ? _onNext : _validate,
        icon: Icon(Icons.check),
        backgroundColor:
            checked ? Colors.lightGreen.shade600 : Colors.cyan.shade600,
        label: Text(buttonLabel));
  }
}

class AnimatedQuestionWidget extends StatefulWidget {
  final Question question;

  final bool checked;

  final VoidCallback onValidate;
  //final VoidCallback onNext;
  final VoidCallback onFadeoutComplete;

  AnimatedQuestionWidget({
    Key key,
    this.question,
    this.checked,
    this.onValidate,
    /*this.onNext,*/
    this.onFadeoutComplete,
  }) : super(key: key);

  @override
  _AnimatedQuestionWidgetState createState() => _AnimatedQuestionWidgetState();
}

class _AnimatedQuestionWidgetState extends State<AnimatedQuestionWidget>
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
    print('_AnimatedQuestionWidgetState.validate... ');
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
            AnimationController(vsync: this, duration: forwardDuration)
        /*..addStatusListener((status) {
        if (status == AnimationStatus.completed) _animController.reverse();
      })*/
        ;

    questionPosition = Tween(begin: -64.0, end: 24.0).animate(CurvedAnimation(
        parent: _animController,
        curve: Interval(0.0, 0.20, curve: Curves.ease)));
    questionOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animController,
        curve: Interval(0.0, 0.25, curve: Curves.ease)));

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

    _animController.forward();
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
  final String prop;

  const PropBloc({Key key, this.prop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return roundedContainer(child: Text(prop));
  }
}
