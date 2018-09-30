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
  int questionIndex;

  final pageKey = GlobalKey<AnimatedQuestionWidgetState>();

  bool checked = false;

  bool get complete => questionIndex + 1 < widget.questions.length;

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
          question: widget.questions[questionIndex],
          checked: checked,
          onValidate: _onQuestionValidated,
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
      pageKey.currentState.reverse();
    });
  }

  void _onFadeoutComplete() {
    print('_QuestionPlayerScreenState._onFadeoutComplete... ');
    setState(() {
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
        onPressed: checked ? _onNext : _validate,
        icon: Icon(Icons.check),
        backgroundColor:
            checked ? Colors.lightGreen.shade600 : Colors.cyan.shade600,
        label: Text(buttonLabel));
  }
}
