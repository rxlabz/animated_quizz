import 'package:flutter/material.dart';

import '../theme.dart';

class ResultScreen extends StatelessWidget {
  final VoidCallback onClose;
  final double score;

  final double minAcceptedScore = 50.0;

  const ResultScreen({Key key, this.onClose, this.score}) : super(key: key);

  get _validated => score > minAcceptedScore;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final subtitleStyle = textTheme.subhead.copyWith(color: Colors.white);
    final style = textTheme.headline.copyWith(color: Colors.white);
    return Scaffold(
      backgroundColor:
          _validated ? Colors.lime.shade200 : Colors.amber.shade200,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.grey.shade800,
          onPressed: onClose,
          icon: Icon(Icons.close),
          label: Text('Close')),
      body: Center(
        child: _buildScoreBox(subtitleStyle, style),
      ),
    );
  }

  Widget _buildScoreBox(TextStyle subtitleStyle, TextStyle style) {
    return roundedContainer(
      padding: 24.0,
      backgroundColor:
          _validated ? Colors.lightGreen : Colors.deepOrange.shade300,
      child: Text.rich(
        TextSpan(text: 'Score\n\n', style: subtitleStyle, children: [
          TextSpan(text: '${score.toStringAsFixed(2)}%', style: style)
        ]),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
