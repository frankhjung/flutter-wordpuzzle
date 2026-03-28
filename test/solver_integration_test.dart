import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wordpuzzle/main.dart';
import 'package:flutter_wordpuzzle/models/puzzle_model.dart';
import 'package:flutter_wordpuzzle/services/solver_service.dart';

void main() {
  Future<void> waitForFinder(
    WidgetTester tester,
    Finder finder, {
    int maxTicks = 200,
    Duration step = const Duration(milliseconds: 50),
  }) async {
    for (var i = 0; i < maxTicks; i++) {
      if (finder.evaluate().isNotEmpty) return;
      await tester.pump(step);
    }
  }

  group('Solver Integration Tests - Repeats Toggle', () {
    testWidgets(
      'With letters "mitncao" and repeats DISABLED: includes "manic" but excludes "maniac"',
      (WidgetTester tester) async {
        await tester.runAsync(() async {
          final service = SolverService();
          final result = await service.solve(
            PuzzleInput(letters: 'mitncao', repeats: false, size: 4),
          );

          expect(result.error, isNull);
          expect(result.words, contains('manic'));
          expect(result.words, isNot(contains('maniac')));
        });
      },
    );

    testWidgets(
      'With letters "mitncao" and repeats ENABLED: finds both "manic" and "maniac"',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.runAsync(() async {
          await tester.pumpWidget(const ProviderScope(child: MyApp()));

          final mandatoryField = find.byType(TextFormField).at(0);
          final otherLettersField = find.byType(TextFormField).at(1);
          await tester.enterText(mandatoryField, 'm');
          await tester.enterText(otherLettersField, 'itncao');
          await tester.pump();

          await tester.tap(find.text('Solve Puzzle'));
          await waitForFinder(tester, find.byKey(const Key('word-maniac')));

          expect(find.byKey(const Key('word-manic')), findsOneWidget);
          expect(find.byKey(const Key('word-maniac')), findsOneWidget);
        });
      },
    );
  });

  group('Solver Logic - Edge Cases', () {
    testWidgets('Entering invalid characters displays error message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      final mandatoryField = find.byType(TextFormField).at(0);
      final otherLettersField = find.byType(TextFormField).at(1);
      await tester.enterText(mandatoryField, 'm');
      await tester.enterText(otherLettersField, 'abcdeFg');
      await tester.tap(find.text('Solve Puzzle'));
      await tester.pump();
      expect(
        find.text('Only lowercase alphabet characters allowed'),
        findsOneWidget,
      );
    });
  });
}
