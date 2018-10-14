import 'dart:convert';

import 'package:animated_qcm/model.dart';
import 'package:flutter/services.dart' show rootBundle;

class QuizzService {
  Future<List<Quizz<String, String>>> loadQuizzs() async {
    final rawData = await rootBundle.loadString('data/quizz.json');
    List<Map<String, dynamic>> rawQuizzs = List.from(json.decode(rawData));
    return rawQuizzs
        .map<Quizz<String, String>>((data) => Quizz.fromJson(data))
        .toList();
  }
}
