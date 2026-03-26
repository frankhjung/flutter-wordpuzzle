import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'views/puzzle_form.dart';
import 'views/puzzle_results.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Puzzle Solver',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: const PuzzleScreen(),
    );
  }
}

class PuzzleScreen extends ConsumerWidget {
  const PuzzleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(solverProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Word Puzzle Solver')),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Form
          const Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: PuzzleForm(),
            ),
          ),

          // Divider
          const VerticalDivider(width: 1, thickness: 1),

          // Right side: Results
          Expanded(
            flex: 2,
            child: state.result.isLoading
                ? const Center(child: CircularProgressIndicator())
                : const PuzzleResults(),
          ),
        ],
      ),
    );
  }
}
