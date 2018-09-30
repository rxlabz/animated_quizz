import 'package:animated_qcm/animated_items/animated_prop.dart';
import 'package:animated_qcm/animated_items/animated_question.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../question.dart';
import '../utils.dart';

class AnimatedQuestionScreen<Q, T> extends StatefulWidget {
  final Question question;

  final VoidCallback onComplete;

  const AnimatedQuestionScreen(
      {Key key, @required this.question, this.onComplete})
      : super(key: key);

  @override
  _AnimatedQuestionScreenState createState() =>
      _AnimatedQuestionScreenState<Q, T>();
}

class _AnimatedQuestionScreenState<Q, T> extends State<AnimatedQuestionScreen> {
  List<T> _selection = [];

  bool get _hasSelection => _selection.isNotEmpty;

  bool complete;

  @override
  void initState() {
    super.initState();
    initQuestion();
  }

  void initQuestion() {
    complete = false;
    _selection.clear();
  }

  @override
  void didUpdateWidget(AnimatedQuestionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      initQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_AnimatedQuestionScreenState.build... complete $complete ');
    return Scaffold(
      backgroundColor: Color(0xFFAACC99),
      body: QuestionView<Q, T>(
          question: widget.question.label,
          propositions: widget.question.propositions,
          onSelectionChanged: _onSelectionChanged,
          complete: complete),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: complete
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.centerFloat,
      /*floatingActionButtonAnimator: FloatingActionButtonAnimator(),*/
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return complete
        ? FloatingActionButton.extended(
            onPressed: _next,
            backgroundColor: Colors.lime.shade600,
            icon: Icon(Icons.skip_next),
            label: Text('Suite'))
        : FloatingActionButton.extended(
            onPressed: _hasSelection ? _validate : null,
            backgroundColor:
                _hasSelection ? Colors.pink.shade600 : Colors.grey.shade200,
            icon: Icon(Icons.check),
            label: Text('Valider'));
  }

  void _validate() {
    setState(() {
      complete = true;
    });
  }

  void _onSelectionChanged(List<T> value) {
    print('_AnimatedQuestionScreenState._onSelectionChanged... ');
    setState(() {
      _selection = value;
    });
  }

  void _next() {
    print('_AnimatedQuestionScreenState._next... ');
    widget.onComplete();
  }
}

class QuestionView<Q, T> extends StatefulWidget {
  final ValueChanged<List<T>> onSelectionChanged;

  final Iterable<T> propositions;
  final Q question;

  final bool complete;

  const QuestionView({
    Key key,
    @required this.propositions,
    @required this.onSelectionChanged,
    @required this.question,
    this.complete = false,
  }) : super(key: key);

  @override
  _QuestionViewState createState() => _QuestionViewState<Q, T>();
}

class _QuestionViewState<Q, T> extends State<QuestionView> {
  List<T> _selection = [];

  final double offsetY = 48.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final hMargin = size.width / 10;
    final padding = size.height / 50;

    final screenSize = MediaQuery.of(context).size;
    print('screenSize... $screenSize');
    final questionStyle = theme.textTheme.title;
    final questionHeight = computeTextHeight(
      text: widget.question,
      style: questionStyle,
      width: size.width - 2 * hMargin,
    );

    return Stack(
      children: <Widget>[
        SizedBox.expand(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.grey.shade200, Colors.grey.shade300])),
        )),
        AnimatedQuestionText(
          question: widget.question,
          style: questionStyle,
          backgroundColor: Colors.blueGrey.shade600,
          padding: padding,
          top: offsetY,
        ),
        Positioned.fill(
            top: questionHeight + padding * 4,
            child: Stack(
              children: _buildPropositionList(
                  theme.textTheme.title, hMargin, padding),
            ))
      ],
    );
  }

  List<AnimatedProposition> _buildPropositionList(
      TextStyle style, double hMargin, double padding) {
    return enumerate<T>(widget.propositions)
        .map<AnimatedProposition>(
            (p) => _buildAnimatePropositions(p, style, hMargin, padding))
        .toList();
  }

  void _onSelection(T value) {
    final newSelection = (_selection.contains(value))
        ? _selection.where((item) => item != value).toList(growable: false)
        : (_selection.map((p) => p).toList()..add(value));
    setState(() {
      _selection = newSelection;
      widget.onSelectionChanged(_selection);
    });
  }

  AnimatedProposition _buildAnimatePropositions(
    IndexedValue<T> prop,
    TextStyle style,
    double hMargin,
    double padding,
  ) {
    final delay = Duration(milliseconds: 300 * (prop.index + 1)) + duration1s;
    return AnimatedProposition<T>(
      prop,
      onSelection: _onSelection,
      style: style,
      delay: delay,
      hMargin: hMargin,
      padding: padding,
      selected: _selection.contains(prop.value),
      status: ItemStatus.none,
      key: Key('prop${prop.index}'),
    );
  }
}
