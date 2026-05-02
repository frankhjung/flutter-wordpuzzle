import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          'Timed out waiting for ${finder.describeMatch(Plurality.one)} '
          'after ${maxTicks * step.inMilliseconds}ms',
        );
      }
    }
  }

  group('Solver Integration Tests - Repeats Toggle', () {
    testWidgets(
      'With letters "mitncao" and repeats ENABLED: finds both "manic" and "maniac"',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 8000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.runAsync(() async {
          await tester.pumpWidget(const ProviderScope(child: MyApp()));

          // Ensure the form is present.
          await tester.pump();

          final mandatoryField = find.byKey(const Key('mandatory-letter'));
          final otherLettersField = find.byKey(const Key('other-letters'));

          await tester.enterText(mandatoryField, 'm');
          await tester.enterText(otherLettersField, 'itncao');
          await tester.pump();

          // Ensure repeats are enabled (it defaults to true, so no need to tap unless it's false).
          final switchFinder = find.byType(Switch);
          expect(tester.widget<Switch>(switchFinder).value, isTrue);

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

  test('repeats-enabled solver returns both manic and maniac', () async {
    final solver = SolverService();
    final input = PuzzleInput(
      letters: 'mitncao',
      size: 4,
      repeats: true,
      dictionaryPath: 'assets/dictionary.txt',
    );

    final result = await solver.solve(input);
    expect(result.contains('manic'), isTrue);
    expect(result.contains('maniac'), isTrue);
  });
}
