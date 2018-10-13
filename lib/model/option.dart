import 'package:flutter/foundation.dart';

enum OptionStatus {
  none, // before validation
  selected, // selected not validated
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
  OptionStatus get status {
    if (validated) {
      if (correct && selected) return OptionStatus.correctAndSelected;
      if (correct && !selected) return OptionStatus.correctButNotSelected;
      if (!correct && selected) return OptionStatus.incorrectButSelected;
      if (!correct && !selected) return OptionStatus.incorrectNotSelected;
    }
    return selected ? OptionStatus.selected : OptionStatus.none;
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
