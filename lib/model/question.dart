import 'package:animated_qcm/model.dart';
import 'package:flutter/foundation.dart';
import 'package:quiver/iterables.dart';

enum ItemStatus { none, correct, incorrect }

class Question<Q, P> {
  final Q label;
  final List<Option<P>> options;
  final List<int> solution;
  final bool allowMultipleSelection;

  Iterable<Option<P>> get solutionPropositions =>
      solution.map((index) => options.toList()[index]);

  const Question({
    @required this.label,
    @required this.options,
    @required this.solution,
    this.allowMultipleSelection = true,
  });

  bool isSelectionCorrect(List<Option> selection) {
    final _selection =
        selection.map((p) => options.indexOf(p)).toList(growable: false);
    return listEquals(List.from(solution)..sort(), _selection..sort());
  }

  @override
  String toString() {
    return 'Question{question: $label, props: $options}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          listEquals(options.toList(), other.options);

  @override
  int get hashCode => label.hashCode ^ options.hashCode;

  factory Question.fromJson(Map<String, dynamic> data) {
    List<int> solution = List.from(data['solution']);
    return Question<Q, P>(
        solution: solution,
        label: data['question'],
        options: enumerate(List.from(data['options']))
            .map<Option<P>>((option) => Option<P>(option.value,
                correct: solution.contains(option.index)))
            .toList());
  }
}
