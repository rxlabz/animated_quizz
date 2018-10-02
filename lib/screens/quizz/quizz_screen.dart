import 'package:animated_qcm/bloc.dart';
import 'package:animated_qcm/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'question_view.dart';

///
/// widget d'affichage d'une série de [questions]
///
class QuizzPlayerScreen extends StatelessWidget {
  /// clé globale du widget d'animation de la question utilisée pour lancer
  /// l'animation de sortie avant de passer à une nouvelle question
  ///
  final pageKey = GlobalKey<AnimatedQuestionWidgetState>();

  /// lancement de l'anim de sortie avant navigation
  void _onNext() {
    // FIXME ?
    pageKey.currentState.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = QuizzBlocProvider.of(context);
    return StreamBuilder(
        stream: bloc.quizzState,
        builder: (BuildContext context, AsyncSnapshot<QuizzState> snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: CircularProgressIndicator(backgroundColor: Colors.cyan));

          final quizz = snapshot.data;
          return Scaffold(
            floatingActionButton: _buildFAB(
              validated: quizz.validated,
              isLast: quizz.isLast,
              selection: quizz.selection,
              onValidate: () => bloc.validate.add(null),
              onNext: _onNext,
            ),
            body: SafeArea(
              bottom: false,
              child: Stack(
                children: <Widget>[
                  buildAnimatedBackground(quizz.pageStatus),
                  AnimatedQuestionWidget(
                    key: pageKey,
                    delay: quizz.currentIndex == 0 ? duration500 : duration150,
                    question: quizz.currentQuestion,
                    options: quizz.options,
                    checked: quizz.validated,
                    onFadeoutComplete: () => bloc.jump(1),
                    selection: quizz.selection,
                    onSelection: bloc.newSelection,
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildFAB<T>({
    bool validated,
    bool isLast,
    List<T> selection,
    VoidCallback onValidate,
    VoidCallback onNext,
  }) {
    final buttonLabel = validated ? (!isLast ? 'Next' : 'End') : 'Validate';
    return FloatingActionButton.extended(
        onPressed:
            selection.isNotEmpty ? (validated ? onNext : onValidate) : null,
        icon: Icon(Icons.check),
        backgroundColor: selection.isNotEmpty
            ? (validated ? Colors.lightGreen.shade600 : Colors.pink.shade600)
            : Colors.grey.shade300,
        label: Text(buttonLabel));
  }
}
