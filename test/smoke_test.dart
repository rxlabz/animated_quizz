import 'package:animated_qcm/quizz_app.dart';
import 'package:animated_qcm/screens/quizz/quizz_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/time.dart';

import 'mock_quizz.dart';

void main() {
  testWidgets('Quizz demo app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(QuizzDemoApp([mockQuizz]));

    // Verify that our counter starts at 0.
    expect(find.text('Quizz'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Validate'), findsNothing);

    // Tap the start button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Quizz'), findsNothing);
    expect(find.text('Qui ?'), findsOneWidget);
    expect(find.text('Validate'), findsOneWidget);

    // button is disabled
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(find.text('Validate'), findsOneWidget);
    expect(find.text('Next'), findsNothing);

    await tester.tap(find.byType(OptionBloc).last);
    await tester.tap(find.byType(OptionBloc).first);
    await tester.pumpAndSettle(aSecond);

    // after prop selection button is enabled
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(find.text('Validate'), findsNothing);
    expect(find.text('Next'), findsOneWidget);

    // next question => allowMultipleSelection solution [1,2]
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(aSecond * 2);

    expect(find.text('Quand ?'), findsOneWidget);
    expect(find.text('Validate'), findsOneWidget);
    expect(find.text('Next'), findsNothing);

    // select 2 last correct props
    await tester.tap(find.byType(OptionBloc).last);
    await tester.pump();
    await tester.tap(find.byType(OptionBloc).at(1));
    await tester.pump();

    // validate
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(aSecond);

    expect(find.text('Quand ?'), findsOneWidget);
    expect(find.text('Validate'), findsNothing);
    expect(find.text('End'), findsOneWidget);

    // end
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(aSecond * 2);

    expect(find.text('Close'), findsOneWidget);
    expect(find.text('Score\n\n100.00%'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(aSecond * 2);

    // back to home
    expect(find.text('Start'), findsOneWidget);
  });
}
