import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wordpuzzle/main.dart';

void main() {
  testWidgets('MyApp renders without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that our app renders the title.
    expect(find.text('Word Puzzle Solver'), findsWidgets);
  });
}
