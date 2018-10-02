import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../question.dart';
import '../utils.dart';
import 'question_view.dart';

/// widget d'affichage d'une série de [questions]
/// renvoie le score(%) via [onComplete]
class QuestionPlayerScreen extends StatefulWidget {
  final List<Question<String, String>> questions;
  final ValueChanged<double> onComplete;

  const QuestionPlayerScreen({Key key, this.questions, this.onComplete})
      : super(key: key);

  @override
  _QuestionPlayerScreenState createState() => _QuestionPlayerScreenState();
}

class _QuestionPlayerScreenState extends State<QuestionPlayerScreen> {
  /// clé global du widget d'animation de la question
  /// utilisé pour lancer l'animation de sortie avant de passer à une nouvelle
  /// question
  final pageKey = GlobalKey<AnimatedQuestionWidgetState>();

  /// selection de l'utilisateur
  final List<String> selection = [];

  /// status de la question => [ItemStatus] none, correct, incorrect
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
        color = Colors.amberAccent;
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
      floatingActionButton: _buildFAB(),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
                child: AnimatedContainer(
              duration: duration500,
              color: _backgroundColor,
            )),
            AnimatedQuestionWidget(
                key: pageKey,
                delay: questionIndex == 0 ? duration500 : duration150,
                question: widget.questions[questionIndex],
                checked: checked,
                onFadeoutComplete: _onFadeoutComplete,
                selection: selection,
                onSelection: _onSelection),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    final buttonLabel = checked ? (complete ? 'Next' : 'End') : 'Validate';
    return FloatingActionButton.extended(
        onPressed:
            selection.isNotEmpty ? (checked ? _onNext : _validate) : null,
        icon: Icon(Icons.check),
        backgroundColor: selection.isNotEmpty
            ? (checked ? Colors.lightGreen.shade600 : Colors.pink.shade600)
            : Colors.grey.shade200,
        label: Text(buttonLabel));
  }

  /// à la selection d'une proposition
  /// remplace la selection si !allowMultipleSelection
  /// sinon ajoute|supprime à la selection
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

  /// lancement de l'anim de sortie avant navigation
  void _onNext() {
    setState(() {
      pageKey.currentState.reverse();
    });
  }

  /// à la fin de l'animation de sortie
  void _onFadeoutComplete() {
    setState(() {
      selection.clear();
      questionStatus = ItemStatus.none;
      checked = false;

      // si toutes les questions ont été visualisées
      if (questionIndex == widget.questions.length - 1) {
        widget.onComplete(_finalScore);
        return;
      }

      questionIndex += 1;
    });
  }

  /// vérifie si selection est égale à solution
  void _validate() {
    final solutions = currentQuestion.solution.toList(growable: false)..sort();
    final userSelection = selection
        .map((p) =>
            currentQuestion.propositions.toList(growable: false).indexOf(p))
        .toList(growable: false)
          ..sort();
    final isCorrect = listEquals(solutions, userSelection);
    setState(() {
      questionStatus = isCorrect ? ItemStatus.correct : ItemStatus.incorrect;
      _score += isCorrect ? 1 : 0;
      checked = true;
    });
  }
}
