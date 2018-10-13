import 'package:animated_qcm/model.dart';

const mockQuestions = [
  Question(
    label: "Qui ?",
    options: [
      Option('a', correct: true),
      Option('b', correct: false),
      Option('c', correct: false),
    ],
    solution: [0],
    allowMultipleSelection: false,
  ),
  Question(
    label: "Quand ?",
    options: [
      Option('1', correct: false),
      Option('2', correct: true),
      Option('3', correct: true),
    ],
    solution: [1, 2],
    allowMultipleSelection: true,
  ),
];
