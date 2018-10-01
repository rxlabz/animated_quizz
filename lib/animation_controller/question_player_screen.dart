import 'package:animated_qcm/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../question.dart';
import 'question_view.dart';

class QuestionPlayerScreen extends StatefulWidget {
  final List<Question<String, String>> questions;
  final ValueChanged<double> onComplete;

  const QuestionPlayerScreen({Key key, this.questions, this.onComplete})
      : super(key: key);

  @override
  _QuestionPlayerScreenState createState() => _QuestionPlayerScreenState();
}

class _QuestionPlayerScreenState extends State<QuestionPlayerScreen> {
  final pageKey = GlobalKey<AnimatedQuestionWidgetState>();

  final List<String> selection = [];

  ItemStatus questionStatus;

  int questionIndex;

  bool checked;

  int _score;

  bool get complete => questionIndex + 1 < widget.questions.length;

  Question get currentQuestion => widget.questions[questionIndex];

  Color get _backgroundColor {
    Color color;
    switch (questionStatus) {
      case ItemStatus.none:
        color = Color(0xffeeedf2);
        break;
      case ItemStatus.correct:
        color = Colors.lime;
        break;
      case ItemStatus.incorrect:
        color = Colors.deepOrangeAccent;
        break;
    }
    return color;
  }

  double get _finalScore => _score / widget.questions.length * 100;

  @override
  void initState() {
    super.initState();
    questionIndex = 0;
    _score = 0;
    checked = false;
    questionStatus = ItemStatus.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      floatingActionButton: _buildFAB(),
      body: SafeArea(
        bottom: false,
        child: AnimatedQuestionWidget(
            key: pageKey,
            delay: questionIndex == 0 ? duration500 : Duration.zero,
            question: widget.questions[questionIndex],
            checked: checked,
            onValidate: _onQuestionValidated,
            onFadeoutComplete: _onFadeoutComplete,
            selection: selection,
            onSelection: _onSelection),
      ),
    );
  }

  void _onQuestionValidated() {
    print('_QuestionPlayerScreenState._onQuestionValidated... ');
  }

  void _onSelection(String prop) {
    setState(() {
      if (!currentQuestion.allowMultipleSelection)
        selection
          ..clear()
          ..add(prop);
      else if (selection.contains(prop)) {
        selection.remove(prop);
      } else {
        selection.add(prop);
      }
    });
  }

  void _onNext() {
    setState(() {
      pageKey.currentState.reverse();
    });
  }

  void _onFadeoutComplete() {
    setState(() {
      selection.clear();
      questionStatus = ItemStatus.none;
      checked = false;

      if (questionIndex == widget.questions.length - 1) {
        widget.onComplete(_finalScore);
        return;
      }

      questionIndex += 1;
    });
  }

  void _validate() {
    final isCorrect = listEquals(
        currentQuestion.solution.toList(growable: false)..sort(),
        selection
            .map((p) =>
                currentQuestion.propositions.toList(growable: false).indexOf(p))
            .toList(growable: false)
              ..sort());
    setState(() {
      questionStatus = isCorrect ? ItemStatus.correct : ItemStatus.incorrect;
      _score += isCorrect ? 1 : 0;
      checked = true;
    });
  }

  Widget _buildFAB() {
    final buttonLabel = checked ? (complete ? 'Next' : 'End') : 'Validate';
    return FloatingActionButton.extended(
        onPressed:
            selection.isNotEmpty ? (checked ? _onNext : _validate) : null,
        icon: Icon(Icons.check),
        backgroundColor: selection.isNotEmpty
            ? (checked ? Colors.lightGreen.shade600 : Colors.cyan.shade600)
            : Colors.grey.shade200,
        label: Text(buttonLabel));
  }
}
