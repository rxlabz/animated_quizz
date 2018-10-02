import 'package:animated_qcm/model.dart';
import 'package:flutter/foundation.dart';

class QuizzState {
  final int currentIndex;
  final Question currentQuestion;
  final List<Option<String>> selection;
  final List<Option<String>> options;
  final bool validated;
  final ItemStatus pageStatus;

  final int questionCount;
  final int score;

  bool get complete => currentIndex == questionCount;
  bool get isLast => currentIndex == questionCount - 1;

  double get finalScore => score / questionCount * 100;

  const QuizzState({
    @required this.questionCount,
    @required this.options,
    @required this.score,
    @required this.currentIndex,
    @required this.currentQuestion,
    @required this.pageStatus,
    @required this.validated,
    @required this.selection,
  });

  QuizzState copyWith({
    int currentIndex,
    bool validated,
    Question currentQuestion,
    List<Option<String>> options,
    List<Option<String>> selection,
    ItemStatus pageStatus,
    int score,
  }) {
    if (selection?.isNotEmpty ?? false) {
      options = this.options.map((option) {
        return option.copyWith(selected: selection.contains(option));
      }).toList(growable: false);
    }
    return QuizzState(
      options: options ?? this.options,
      currentIndex: currentIndex ?? this.currentIndex,
      validated: validated ?? this.validated,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      selection: selection ?? this.selection,
      pageStatus: pageStatus ?? this.pageStatus,
      questionCount: questionCount ?? this.questionCount,
      score: score ?? this.score,
    );
  }

  @override
  String toString() {
    return 'QuizzState{currentIndex: $currentIndex, currentQuestion: $currentQuestion, selection: $selection, validated: $validated, pageStatus: $pageStatus, questionCount: $questionCount, score: $score , isLast $isLast}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizzState &&
          runtimeType == other.runtimeType &&
          currentIndex == other.currentIndex &&
          currentQuestion == other.currentQuestion &&
          selection == other.selection &&
          options == other.options &&
          validated == other.validated &&
          pageStatus == other.pageStatus &&
          questionCount == other.questionCount &&
          score == other.score;

  @override
  int get hashCode =>
      currentIndex.hashCode ^
      currentQuestion.hashCode ^
      selection.hashCode ^
      options.hashCode ^
      validated.hashCode ^
      pageStatus.hashCode ^
      questionCount.hashCode ^
      score.hashCode;
}
