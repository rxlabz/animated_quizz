import 'package:animated_qcm/animated_items/animated_qcm.dart';
import 'package:flutter/material.dart';

import 'question.dart';

void main() => runApp(new App());

class App extends StatefulWidget {
  @override
  AppState createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  int questionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedQuestionScreen<String, String>(
          question: questions[questionIndex], onComplete: _onQuestionComplete),
    );
  }

  void _onQuestionComplete() => setState(() => questionIndex += 1);
}
