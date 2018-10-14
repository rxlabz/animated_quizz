import 'dart:async';

import 'package:animated_qcm/bloc.dart';
import 'package:animated_qcm/model.dart';
import 'package:animated_qcm/screens.dart';
import 'package:animated_qcm/theme.dart';
import 'package:flutter/material.dart';

class QuizzDemoApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  final List<Quizz<String, String>> quizzs;
  final QuizzBloc _quizzBloc;

  QuizzDemoApp(this.quizzs) : _quizzBloc = QuizzBloc(quizzs.first.questions);

  NavigatorState get _navigator => _navKey.currentState;

  @override
  Widget build(BuildContext context) {
    final routes = <String, WidgetBuilder>{
      '/home': (_) => HomeScreen(onStart: _launchQuizz),
      '/quizz': _buildQuizzScreen,
    };

    return MaterialApp(
      navigatorKey: _navKey,
      home: HomeScreen(onStart: _launchQuizz),
      routes: routes,
    );
  }

  Widget _buildQuizzScreen(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.title;
    final theme = QuizzTheme(
        defaultTextStyle: textStyle,
        optionStyle: OptionStyle(textStyle: textStyle));
    return QuizzThemeProvider(
        theme: theme,
        child: QuizzBlocProvider(
          bloc: _quizzBloc,
          child: QuizzPlayerScreen(),
        ));
  }

  void _launchQuizz() {
    StreamSubscription _quizzSubscription;
    _quizzSubscription =
        _quizzBloc.quizzState.where((q) => q.complete).listen((state) {
      _onQuizzComplete(state.finalScore);
      _quizzSubscription.cancel();
    });
    _navigator.pushNamed('/quizz');
  }

  void _onQuizzComplete(double score) {
    _navigator.pushReplacement(_buildResultRoute(score));
    _quizzBloc.jump(0);
  }

  PageRoute _buildResultRoute(double score) => MaterialPageRoute(
        builder: (_) => ResultScreen(score: score, onClose: _closeQuizz),
      );

  void _closeQuizz() => _navigator.pop();
}
