import 'package:animated_qcm/bloc.dart';
import 'package:animated_qcm/model.dart';
import 'package:test/test.dart';

import 'mock_quizz.dart';

void main() {
  QuizzBloc bloc;
  setUp(() {
    bloc = new QuizzBloc(mockQuestions);
  });
  group('QUIZZ BLOC', () {
    test('initial value', () {
      bloc.quizzState.listen((state) {
        expect(state.currentIndex, equals(0));
        expect(state.questionCount, equals(2));
        expect(state.validated, equals(false));
        expect(state.pageStatus, equals(ItemStatus.none));
        expect(state.selection.length, equals(0));
      });
    });

    test('proposition selection & validation', () {
      final q = mockQuestions.first;
      bloc.newSelection(q.propositions.first);
      bloc.quizzState.listen((state) {
        expect(state.selection.length, equals(1));
        expect(state.selection.first, equals(q.propositions.first));
        expect(q.isSelectionCorrect(state.selection), equals(true));
      });
    });

    test('clear on navigate', () {
      final q = mockQuestions.first;
      bloc.newSelection(q.propositions.first);
      bloc.jump(1);
      bloc.quizzState.where((state) => state.currentIndex == 1).listen((state) {
        expect(state.selection.length, equals(0));
        expect(state.pageStatus, equals(ItemStatus.none));
        expect(state.validated, equals(false));
      });
    });

    test('proposition selection & fail', () {
      final q = mockQuestions.last;
      bloc.newSelection(q.propositions.first);
      bloc.quizzState.listen((state) {
        expect(state.selection.length, equals(1));
        expect(state.selection.first, equals(q.propositions.first));
        expect(q.isSelectionCorrect(state.selection), equals(false));
      });
    });

    test('multi proposition selection & validation success', () {
      bloc.jump(1);
      final q = mockQuestions.last;
      bloc.newSelection(q.propositions.toList()[1]);
      bloc.newSelection(q.propositions.toList()[2]);
      bloc.quizzState.skip(2).listen((state) {
        expect(state.selection.length, equals(2));
        expect(q.isSelectionCorrect(state.selection), equals(true));
      });
    });
  });
}
