import 'dart:async';

import 'package:animated_qcm/bloc.dart';
import 'package:animated_qcm/model.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/*
gestion du questionnaire et de la question en cours

- liste des questions en entrée

- stream un QuizzState

TODO => automatiser update quizzState
=> Streamer la concatenation des différents stream
ou au moins réagir aux streams => flux d'update
*/
class QuizzBloc {
  QuizzBloc(this.questions, {int currentIndex = 0}) {
    final state = initState(currentIndex);

    _quizzStateStreamer = BehaviorSubject<QuizzState>(seedValue: state);

    _selectionSubscription =
        _newSelectionStreamer.stream.listen(_onOptionSelection);

    _validationSubscription = _validationStreamer.stream.listen(_onValidation);

    _goToQuestionSubscription =
        _goToQuestionStreamer.stream.listen(_onIndexChange);

    _initZipStream();
  }

  //ZipStream<> _zippedQuizzState;

  void _initZipStream() {
    //_zippedQuizzState = new ZipStream([streams], zipper)
  }

  final List<Question<String, String>> questions;

  /// abonnement au flux de selection
  /// de l'utilisateur pour la question en cours
  /// validation de la question en cours
  StreamSubscription<Option<String>> _selectionSubscription;

  StreamSubscription<Null> _validationSubscription;

  StreamSubscription<int> _goToQuestionSubscription;

  /*
  INPUTS
   */

  /// streamer
  StreamController<Option<String>> _newSelectionStreamer =
      StreamController<Option<String>>();

  /// sink des nouvelles selection utilisateurs
  /// chaque question peut
  ValueChanged<Option<String>> get newSelection =>
      _newSelectionStreamer.sink.add;

  /// streamer
  StreamController<Null> _validationStreamer = StreamController<Null>();

  /// sink des nouvelles selection utilisateurs
  /// chaque question peut
  Sink<Null> get validate => _validationStreamer.sink;

  /// streamer
  StreamController<int> _goToQuestionStreamer = StreamController<int>();

  /// sink des nouvelles selection utilisateurs
  /// chaque question peut
  ValueChanged<int> get jump => _goToQuestionStreamer.sink.add;

  /*
  OUTPUT
   */

  /// bloc state
  QuizzState _quizzState;

  /// streamer
  StreamController<QuizzState> _quizzStateStreamer;

  /// stream de la liste des propositions sélectionnées
  /// par l'utilisateur pour la question en cours
  Stream<QuizzState> get quizzState => _quizzStateStreamer.stream;

  /*-------------------------------------*/

  OptionStatus currentQuestionStatus = OptionStatus.none;

  bool get currentQuestionValidated =>
      currentQuestionStatus != OptionStatus.none;

  QuizzState initState(int currentIndex) {
    _quizzState = QuizzState(
      currentIndex: currentIndex,
      validated: false,
      currentQuestion: questions[currentIndex],
      selection: [],
      questionCount: questions.length,
      pageStatus: ItemStatus.none,
      score: 0,
      options: questions[currentIndex].options,
    );

    return _quizzState;
  }

  void dispose() {
    _newSelectionStreamer.close();
    _goToQuestionStreamer.close();
    _quizzStateStreamer.close();
    _validationStreamer.close();

    _selectionSubscription.cancel();
    _validationSubscription.cancel();
    _goToQuestionSubscription.cancel();
  }

  void _onOptionSelection(Option<String> option) {
    List<Option<String>> userSelection = _quizzState.selection;
    if (!_quizzState.currentQuestion.allowMultipleSelection)
      userSelection
        ..clear()
        ..add(option);
    else if (userSelection.contains(option))
      userSelection.remove(option);
    else
      userSelection.add(option);

    _quizzState = _quizzState.copyWith(selection: userSelection);
    if (userSelection.isEmpty)
      _quizzState = _quizzState.copyWith(
          options: _quizzState.options
              .map((option) => option.copyWith(selected: false))
              .toList(growable: false));
    _quizzStateStreamer.add(_quizzState);
  }

  void _onValidation(_) {
    final isCorrect =
        _quizzState.currentQuestion.isSelectionCorrect(_quizzState.selection);
    _quizzState = _quizzState.copyWith(
        score: _quizzState.score + (isCorrect ? 1 : 0),
        options: _quizzState.options
            .map((option) => option.copyWith(validated: true))
            .toList(),
        validated: true,
        pageStatus: isCorrect ? ItemStatus.correct : ItemStatus.incorrect);
    _quizzStateStreamer.add(_quizzState);
  }

  void _onIndexChange(int indexChange) {
    if (indexChange == 0) {
      _clear();
      return;
    }

    int currentIndex = _quizzState.currentIndex;
    currentIndex += indexChange;

    // terminé
    if (currentIndex == questions.length) {
      _quizzState = _quizzState.copyWith(currentIndex: currentIndex);
    } else {
      final question =
          currentIndex == questions.length ? null : questions[currentIndex];
      _quizzState = _quizzState.copyWith(
        currentIndex: currentIndex,
        currentQuestion: question,
        options: question?.options ?? [],
        validated: false,
        selection: [],
        pageStatus: ItemStatus.none,
      );
    }
    _quizzStateStreamer.add(_quizzState);
  }

  void _clear() {
    _quizzState = QuizzState(
      currentIndex: 0,
      validated: false,
      currentQuestion: questions[0],
      selection: [],
      questionCount: questions.length,
      pageStatus: ItemStatus.none,
      score: 0,
      options: questions[0].options,
    );
    _quizzStateStreamer.add(_quizzState);
  }
}
