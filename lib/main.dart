import 'package:animated_qcm/quizz_service.dart';
import 'package:flutter/material.dart';

import 'quizz_app.dart';

void main() async {
  final quizzs = await QuizzService().loadQuizzs();

  runApp(QuizzDemoApp(quizzs));
}
