import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

void main() {
  runApp(const ProviderScope(child: WordPuzzleApp()));
}

class WordPuzzleApp extends StatelessWidget {
  const WordPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Puzzle Solver',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const SolverPage(),
    );
  }
}

class SolverPage extends ConsumerStatefulWidget {
  const SolverPage({super.key});

  @override
  ConsumerState<SolverPage> createState() => _SolverPageState();
}

class _SolverPageState extends ConsumerState<SolverPage> {
  final _formKey = GlobalKey<FormState>();
  final _lettersController = TextEditingController();
  final _sizeController = TextEditingController(text: '4');
  final _dictionaryController = TextEditingController(
    text: 'resources/dictionary',
  );
  bool _repeats = false;

  @override
  void dispose() {
    _lettersController.dispose();
    _sizeController.dispose();
    _dictionaryController.dispose();
    super.dispose();
  }

  void _solve() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(solverProvider.notifier)
          .solve(
            letters: _lettersController.text,
            size: int.parse(_sizeController.text),
            repeats: _repeats,
            dictionary: _dictionaryController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final solverState = ref.watch(solverProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Puzzle Solver'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Input Panel
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 0,
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _lettersController,
                              decoration: const InputDecoration(
                                labelText: 'Letters (7+ required)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.type_specimen),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 7) {
                                  return 'Enter at least 7 letters';
                                }
                                if (!RegExp(r'^[a-z]+$').hasMatch(value)) {
                                  return 'Only lowercase letters allowed';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _sizeController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Min Size',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.numbers),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter a minimum size';
                                      }
                                      final n = int.tryParse(value);
                                      if (n == null || n < 1) {
                                        return 'Enter a valid size (1 or more)';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SwitchListTile(
                                    title: const Text('Repeats'),
                                    value: _repeats,
                                    onChanged: (val) =>
                                        setState(() => _repeats = val),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _dictionaryController,
                              decoration: const InputDecoration(
                                labelText: 'Dictionary Path',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.book),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: solverState.isLoading ? null : _solve,
                      icon: solverState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.search),
                      label: const Text('Solve Puzzle'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (solverState.error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        solverState.error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          // Results Panel
          const VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: solverState.words.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No results yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: solverState.groupedWords.length,
                    itemBuilder: (context, index) {
                      final group = solverState.groupedWords[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Chip(label: Text('${group.length} Letters')),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Divider(color: Colors.grey[200]),
                                ),
                              ],
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: group.words
                                .map(
                                  (word) => Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: Colors.grey[200]!,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        word,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
