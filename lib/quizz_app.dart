import 'package:animated_qcm/bloc.dart';
import 'package:animated_qcm/model.dart';
import 'package:animated_qcm/screens.dart';
import 'package:flutter/material.dart';

/// application global
/// gestion navigation
class QuizzDemoApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  final QuizzBloc _quizzBloc;

  QuizzDemoApp(List<Question> questions) : _quizzBloc = QuizzBloc(questions);

  NavigatorState get _navigator => _navKey.currentState;

  @override
  Widget build(BuildContext context) {
    _quizzBloc.quizzState
        .where((q) => q.complete)
        .listen((state) => _onQuizzComplete(state.finalScore));

    final routes = <String, WidgetBuilder>{
      '/home': (_) => HomeScreen(onStart: _launchQuizz),
      '/quizz': (_) =>
          QuizzBlocProvider(bloc: _quizzBloc, child: QuizzPlayerScreen()),
    };

    return MaterialApp(
      navigatorKey: _navKey,
      home: HomeScreen(onStart: _launchQuizz),
      routes: routes,
    );
  }

  void _launchQuizz() => _navigator.pushNamed('/quizz');

  /// on quizz complete
  /// displays ResultScreen & reinit the bloc
  void _onQuizzComplete(double score) {
    _navigator.pushReplacement(_buildResultRoute(score));
    _quizzBloc.jump(0);
  }

  PageRoute _buildResultRoute(double score) => MaterialPageRoute(
        builder: (_) => ResultScreen(score: score, onClose: _closeQuizz),
      );

  void _closeQuizz() => _navigator.pop();
}
