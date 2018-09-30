import 'package:flutter/material.dart';

import '../question.dart';
import 'question_player_screen.dart';

class AnimControllerApp extends StatefulWidget {
  @override
  _AnimControllerAppState createState() => _AnimControllerAppState();
}

class _AnimControllerAppState extends State<AnimControllerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuestionPlayerScreen(questions: questions),
    );
  }
}
