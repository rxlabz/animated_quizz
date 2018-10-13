import 'package:flutter/widgets.dart';

import 'quizz_bloc.dart';

class QuizzBlocProvider extends StatefulWidget {
  final QuizzBloc bloc;
  final Widget child;

  const QuizzBlocProvider({Key key, @required this.bloc, @required this.child})
      : super(key: key);

  @override
  _QuizzBlocProviderState createState() => _QuizzBlocProviderState();

  static QuizzBloc of(BuildContext context) {
    return ((context.inheritFromWidgetOfExactType(_QuizzBlocProvider)
            as _QuizzBlocProvider)
        .bloc);
  }
}

class _QuizzBlocProviderState extends State<QuizzBlocProvider> {
  @override
  Widget build(BuildContext context) {
    return _QuizzBlocProvider(
      bloc: widget.bloc,
      child: widget.child,
    );
  }
}

class _QuizzBlocProvider extends InheritedWidget {
  final QuizzBloc bloc;

  _QuizzBlocProvider({Key key, @required Widget child, this.bloc})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_QuizzBlocProvider oldWidget) =>
      bloc != oldWidget.bloc;
}
