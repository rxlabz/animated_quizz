import 'package:flutter/foundation.dart';

enum PropositionStatus {
  none, // before validation
  correctAndSelected, // correct & selected
  correctButNotSelected, // correct but not selected
  incorrectButSelected, // incorrect but selected
  incorrectNotSelected // incorrect and not selected
}

class Option<T> {
  final T label;
  final bool selected;
  final bool correct;
  final bool validated;
  PropositionStatus get status {
    if (validated) {
      if (correct && selected) return PropositionStatus.correctAndSelected;
      if (correct && !selected) return PropositionStatus.correctButNotSelected;
      if (!correct && selected) return PropositionStatus.incorrectButSelected;
      if (!correct && !selected) return PropositionStatus.incorrectNotSelected;
    }
    return PropositionStatus.none;
  }

  const Option(
    this.label, {
    this.validated = false,
    this.selected = false,
    @required this.correct,
  });

  Option<T> copyWith({bool selected, bool validated}) {
    return Option<T>(label,
        selected: selected ?? this.selected,
        validated: validated ?? this.validated,
        correct: correct);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Option &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          correct == other.correct;

  @override
  int get hashCode => label.hashCode ^ correct.hashCode;
}
