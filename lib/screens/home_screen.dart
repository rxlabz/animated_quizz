import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onStart;

  const HomeScreen({Key key, this.onStart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.display1.copyWith(color: Colors.white);
    return Scaffold(
      backgroundColor: Colors.cyan,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: onStart,
          backgroundColor: Colors.limeAccent,
          foregroundColor: Colors.black87,
          icon: Icon(Icons.play_arrow),
          label: Text('Start')),
      body: Center(
        child: Text('Quizz', style: style),
      ),
    );
  }
}
