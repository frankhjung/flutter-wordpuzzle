import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class PuzzleResults extends ConsumerWidget {
  const PuzzleResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(solverProvider);
    final result = state.result;
    final input = state.input;

    if (result.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                'Error Occurred',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.red),
              ),
              const SizedBox(height: 8),
              Text(
                result.error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    if (result.words.isEmpty) {
      if (input.letters.isEmpty) {
        return const Center(
          child: Text('Enter letters and submit to solve the puzzle.'),
        );
      } else {
        return const Center(
          child: Text('No words found for the given criteria.'),
        );
      }
    }

    final groupedWords = result.groupedWords;
    final mandatoryLetter =
        input.letters.isNotEmpty ? input.letters[0].toLowerCase() : '';

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: groupedWords.length,
      itemBuilder: (context, index) {
        final group = groupedWords[index];
        final length = group.length;
        final words = group.words;

        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$length-Letter Words (${words.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: words.map((word) {
                    return _buildWordChip(context, word, mandatoryLetter);
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWordChip(
    BuildContext context,
    String word,
    String mandatoryLetter,
  ) {
    final spans = <TextSpan>[];
    for (int i = 0; i < word.length; i++) {
      final char = word[i].toLowerCase();
      if (char == mandatoryLetter) {
        spans.add(
          TextSpan(
            text: word[i],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: word[i]));
      }
    }

    return Container(
      key: Key('word-$word'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: spans,
        ),
      ),
    );
  }
}
