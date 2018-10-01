import 'package:flutter/material.dart';

import '../question.dart';
import 'question_player_screen.dart';

class AnimControllerApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      home: HomeScreen(
        onStart: _onStart,
      ),
      routes: <String, WidgetBuilder>{
        '/home': _homeBuilder,
        '/question': _questionScreenBuilder,
      },
    );
  }

  Widget _questionScreenBuilder(BuildContext context) =>
      QuestionPlayerScreen(questions: questions, onComplete: _onComplete);

  Widget _homeBuilder(BuildContext context) => HomeScreen(
        onStart: _onStart,
      );

  void _onStart() {
    navKey.currentState.pushNamed('/question');
  }

  void _onComplete(double score) {
    navKey.currentState.pushReplacement(
        MaterialPageRoute(builder: (c) => _buildResult(c, score)));
  }

  Widget _buildResult(BuildContext context, double score) {
    final style = Theme.of(context).textTheme.headline;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _backHome, icon: Icon(Icons.close), label: Text('Close')),
      body: Center(
        child: Text(
          'Score : ${score.toStringAsFixed(2)}%',
          style: style,
        ),
      ),
    );
  }

  void _backHome() {
    //navKey.currentState.popUntil(ModalRoute.withName('/home'));
    navKey.currentState.pop();
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback onStart;

  const HomeScreen({Key key, this.onStart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: onStart,
          icon: Icon(Icons.play_arrow),
          label: Text('Start')),
      body: Center(
        child: Text('home'),
      ),
    );
  }
}
