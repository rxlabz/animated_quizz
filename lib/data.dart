import 'package:animated_qcm/model.dart';

const Q1 = 'Flutter apps are written in...';
const PROPS1 = <Option<String>>[
  Option('Javascript', correct: false),
  Option('Dart', correct: true),
  Option('Kotlin', correct: false),
];

const Q2 = "Which widgets allow to listen to user gestures ?";
const PROPS2 = <Option<String>>[
  Option('GestureWidget', correct: false),
  Option('TapWidget', correct: false),
  Option('InkWell', correct: true),
  Option('TapDetector', correct: false),
  Option('GestureDetector', correct: true),
];

const Q3 =
    "Which widget displays a menu when pressed and calls onSelected when the menu is dismissed because an item was selected?";
const PROPS3 = <Option<String>>[
  Option('Popup', correct: false),
  Option('MenuManager', correct: false),
  Option('PopupMenuButton', correct: true),
  Option('MenuViewer', correct: false),
  Option('MenuWidget', correct: false),
];

const questions = [
  Question<String, String>(
      label: Q1, options: PROPS1, solution: [1], allowMultipleSelection: false),
  Question<String, String>(
    label: Q2,
    options: PROPS2,
    solution: [2, 4],
    allowMultipleSelection: true,
  ),
  Question<String, String>(
    label: Q3,
    options: PROPS3,
    solution: [2],
    allowMultipleSelection: false,
  ),
];
