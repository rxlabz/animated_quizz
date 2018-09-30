import 'package:flutter/material.dart';

import '../animated_items/animated_qcm.dart';
import '../question.dart';

class AnimatedItemsApp extends StatefulWidget {
  @override
  AnimatedItemsAppState createState() {
    return new AnimatedItemsAppState();
  }
}

class AnimatedItemsAppState extends State<AnimatedItemsApp> {
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
