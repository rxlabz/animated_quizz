import 'package:flutter/foundation.dart';

const Q1 =
    'De quelle couleur est le cheval blanc d\'Henri IV ? De quelle couleur est le cheval blanc d\'Henri IV ?';
const PROPS1 = <String>['Vert', 'Jaune', 'Rouge', 'Bleu'];

const Q2 = "Quelle est la capitale de l'Espagne ?";
const PROPS2 = <String>['Paris', 'Rome', 'Madrid', 'Londres'];

const Q3 = "Quelle est la capitale de la France ?";
const PROPS3 = <String>['Paris', 'Rome', 'Madrid', 'Londres'];

const questions = [
  Question<String, String>(
    label: Q1,
    propositions: PROPS1,
    solution: [1, 2],
  ),
  Question<String, String>(
    label: Q2,
    propositions: PROPS2,
    solution: [1, 2],
    allowMultipleSelection: false,
  ),
  Question<String, String>(
    label: Q3,
    propositions: PROPS3,
    solution: [1, 2],
    allowMultipleSelection: false,
  ),
];

class Question<Q, P> {
  final Q label;
  final Iterable<P> propositions;
  final Iterable<int> solution;
  final bool allowMultipleSelection;

  Iterable<P> get solutionPropositions =>
      solution.map((index) => propositions.toList()[index]);

  const Question({
    @required this.label,
    @required this.propositions,
    @required this.solution,
    this.allowMultipleSelection = true,
  });

  @override
  String toString() {
    return 'Question{question: $label, props: $propositions}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          listEquals(propositions.toList(), other.propositions);

  @override
  int get hashCode => label.hashCode ^ propositions.hashCode;
}

enum ItemStatus { none, correct, incorrect }
