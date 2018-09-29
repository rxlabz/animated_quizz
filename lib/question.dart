import 'package:flutter/foundation.dart';

const Q1 =
    'De quelle couleur est le cheval blanc d\'Henri IV ? De quelle couleur est le cheval blanc d\'Henri IV ?';
const PROPS1 = <String>['Vert', 'Jaune', 'Rouge', 'Bleu'];

const Q2 = "Quelle est la capitale de l'Espagne ?";
const PROPS2 = <String>['Paris', 'Rome', 'Madrid', 'Londres'];

const questions = [
  MultipleChoice(
    question: Q1,
    propositions: PROPS1,
    solution: [1, 2],
  ),
  MultipleChoice(
      question: Q2,
      propositions: PROPS2,
      solution: [1, 2],
      allowMultipleSelection: false),
];

class MultipleChoice<Q, P> {
  final Q question;
  final Iterable<P> propositions;
  final Iterable<int> solution;
  final bool allowMultipleSelection;

  Iterable<P> get solutionPropositions =>
      solution.map((index) => propositions.toList()[index]);

  const MultipleChoice({
    @required this.question,
    @required this.propositions,
    @required this.solution,
    this.allowMultipleSelection = true,
  });

  @override
  String toString() {
    return 'Question{question: $question, props: $propositions}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultipleChoice &&
          runtimeType == other.runtimeType &&
          question == other.question &&
          listEquals(propositions.toList(), other.propositions);

  @override
  int get hashCode => question.hashCode ^ propositions.hashCode;
}

enum ItemStatus { none, correct, incorrect }
