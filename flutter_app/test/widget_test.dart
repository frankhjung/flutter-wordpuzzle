import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wordpuzzle/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('WordPuzzleApp renders without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: WordPuzzleApp()));
    expect(find.text('Word Puzzle Solver'), findsOneWidget);
  });
}
