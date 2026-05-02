import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wordpuzzle/main.dart';
import 'package:flutter_wordpuzzle/models/puzzle_model.dart';
import 'package:flutter_wordpuzzle/services/solver_service.dart';

void main() {
  /// Polls until every [finders] entry is non-empty, or fails with a clear
  /// message on timeout. Inside [tester.runAsync] the fake-async clock is
  /// suspended, so we advance the widget tree with a zero-duration [pump]
  /// then wait in real time with [Future.delayed] instead of relying on
  /// [pump(duration)] to advance time.
  Future<void> waitForFinders(
    WidgetTester tester,
    List<Finder> finders, {
    int maxTicks = 200,
    Duration step = const Duration(milliseconds: 50),
  }) async {
    for (var i = 0; i < maxTicks; i++) {
      await tester.pump();
      if (finders.every((f) => f.evaluate().isNotEmpty)) return;
      await Future.delayed(step);
    }

    for (final finder in finders) {
      if (finder.evaluate().isEmpty) {
        fail(
          'Timed out waiting for ${finder.describeMatch((_) => finder.toString())} '
          'after ${maxTicks * step.inMilliseconds}ms',
        );
      }
    }
  }

  group('Solver Integration Tests - Repeats Toggle', () {
    testWidgets(
      'With letters "mitncao" and repeats ENABLED: finds both "manic" and "maniac"',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.runAsync(() async {
          await tester.pumpWidget(const MyApp());

          // Ensure the form is present.
          await tester.pump();

          final mandatoryField = find.byKey(const Key('mandatory-letter'));
          final otherLettersField = find.byKey(const Key('other-letters'));

          await tester.enterText(mandatoryField, 'm');
          await tester.enterText(otherLettersField, 'itncao');
          await tester.pump();

          // Explicitly enable repeats.
          await tester.tap(find.byKey(const Key('repeats-toggle')));
          await tester.pump();

          await tester.tap(find.text('Solve Puzzle'));
          await tester.pump();

          await waitForFinders(tester, [
            find.byKey(const Key('word-manic')),
            find.byKey(const Key('word-maniac')),
          ]);

          expect(find.byKey(const Key('word-manic')), findsOneWidget);
          expect(find.byKey(const Key('word-maniac')), findsOneWidget);
        });
      },
    );
  });

  test('repeats-enabled solver returns both manic and maniac', () {
    final solver = SolverService();
    final input = PuzzleInput.fromStrings(
      mandatoryLetter: 'm',
      otherLetters: 'itncao',
      repeats: true,
    );

    final result = solver.solve(input);
    expect(result.contains('manic'), isTrue);
    expect(result.contains('maniac'), isTrue);
  });
}
