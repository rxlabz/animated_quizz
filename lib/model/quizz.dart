import 'question.dart';

class Quizz<Q, P> {
  final String id;
  final num minimumScore;
  final String title;
  final String description;
  final List<Question<Q, P>> questions;

  const Quizz({
    this.title,
    this.questions,
    this.id,
    this.minimumScore = 50,
    this.description = '',
  });

  factory Quizz.fromJson(Map<String, dynamic> data) {
    return Quizz<Q, P>(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      minimumScore: data['minimumScore'],
      questions: List.from(data['questions'])
          .map<Question<Q, P>>((data) => Question.fromJson(data))
          .toList(),
    );
  }
}
