import 'package:animated_qcm/utils.dart';
import 'package:flutter/material.dart';

import '../question.dart';
import 'question_view.dart';

class QuestionPlayerScreen extends StatefulWidget {
  final List<Question<String, String>> questions;
  final VoidCallback onComplete;

  const QuestionPlayerScreen({Key key, this.questions, this.onComplete})
      : super(key: key);

  @override
  _QuestionPlayerScreenState createState() => _QuestionPlayerScreenState();
}

class _QuestionPlayerScreenState extends State<QuestionPlayerScreen> {
  final pageKey = GlobalKey<AnimatedQuestionWidgetState>();

  final List<String> selection = [];

  int questionIndex;

  bool checked = false;

  bool get complete => questionIndex + 1 < widget.questions.length;

  Question get currentQuestion => widget.questions[questionIndex];

  @override
  void initState() {
    super.initState();
    questionIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeeedf2),
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
    print('_QuestionPlayerScreenState._onNext... ');
    setState(() {
      pageKey.currentState.reverse();
    });
  }

  void _onFadeoutComplete() {
    print('_QuestionPlayerScreenState._onFadeoutComplete... ');
    setState(() {
      selection.clear();
      checked = false;
      if (questionIndex == widget.questions.length - 1) {
        widget.onComplete();
        return;
      }

      questionIndex += 1;
    });
  }

  void _validate() {
    setState(() {
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
