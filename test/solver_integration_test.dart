import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wordpuzzle/main.dart';
import 'dart:io';

void main() {
  final dictionary = File('assets/dictionary.txt').readAsStringSync();

  group('Solver Integration Tests - Repeats Toggle', () {
    testWidgets(
        'With letters "mitncao" and repeats DISABLED: finds "manic" but not "maniac"',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.runAsync(() async {
        await tester.pumpWidget(
          ProviderScope(
            child: DefaultAssetBundle(
              bundle: TestAssetBundle(dictionary),
              child: const MyApp(),
            ),
          ),
        );

        final lettersField = find.byType(TextFormField).first;
        await tester.enterText(lettersField, 'mitncao');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Solve Puzzle'));
        await tester.pump();

        int count = 0;
        while (count < 50) {
          await Future.delayed(const Duration(milliseconds: 50));
          await tester.pump();
          if (find.byKey(const Key('word-manic')).evaluate().isNotEmpty) break;
          count++;
        }
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('word-manic')), findsOneWidget);
        expect(find.byKey(const Key('word-maniac')), findsNothing);
      });
    });

    testWidgets(
        'With letters "mitncao" and repeats ENABLED: finds both "manic" and "maniac"',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.runAsync(() async {
        await tester.pumpWidget(
          ProviderScope(
            child: DefaultAssetBundle(
              bundle: TestAssetBundle(dictionary),
              child: const MyApp(),
            ),
          ),
        );

        final lettersField = find.byType(TextFormField).first;
        await tester.enterText(lettersField, 'mitncao');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Allow repeating letters?'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Solve Puzzle'));
        await tester.pump();

        int count = 0;
        while (count < 50) {
          await Future.delayed(const Duration(milliseconds: 50));
          await tester.pump();
          final maniacFound =
              find.byKey(const Key('word-maniac')).evaluate().isNotEmpty;
          if (maniacFound) break;
          count++;
        }
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('word-manic')), findsOneWidget);
        expect(find.byKey(const Key('word-maniac')), findsOneWidget);
      });
    });
  });

  group('Solver Logic - Edge Cases', () {
    testWidgets('Entering invalid characters displays error message',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const ProviderScope(child: MyApp()));
        final lettersField = find.byType(TextFormField).first;
        await tester.enterText(lettersField, 'abc1234');
        await tester.tap(find.text('Solve Puzzle'));
        await tester.pumpAndSettle();
        expect(find.text('Only alphabet characters allowed'), findsOneWidget);
      });
    });
  });
}

class TestAssetBundle extends CachingAssetBundle {
  final String dictionary;
  TestAssetBundle(this.dictionary);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key == 'assets/dictionary.txt') {
      return dictionary;
    }
    return super.loadString(key, cache: cache);
  }

  @override
  Future<ByteData> load(String key) async {
    if (key == 'assets/dictionary.txt') {
      return ByteData.view(Uint8List.fromList(dictionary.codeUnits).buffer);
    }
    return ByteData(0);
  }
}
