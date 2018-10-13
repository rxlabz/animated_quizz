import 'package:flutter/widgets.dart';

import 'theme.dart';

class QuizzThemeProvider extends StatefulWidget {
  final QuizzTheme theme;
  final Widget child;

  const QuizzThemeProvider(
      {Key key, @required this.theme, @required this.child})
      : super(key: key);

  @override
  _QuizzThemeProviderState createState() => _QuizzThemeProviderState();

  static QuizzTheme of(BuildContext context) {
    return ((context.inheritFromWidgetOfExactType(_QuizzThemeProvider)
            as _QuizzThemeProvider)
        .theme);
  }
}

class _QuizzThemeProviderState extends State<QuizzThemeProvider> {
  @override
  Widget build(BuildContext context) {
    return _QuizzThemeProvider(
      theme: widget.theme,
      child: widget.child,
    );
  }
}

class _QuizzThemeProvider extends InheritedWidget {
  final QuizzTheme theme;

  _QuizzThemeProvider({Key key, @required Widget child, this.theme})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_QuizzThemeProvider oldWidget) =>
      theme != oldWidget.theme;
}
