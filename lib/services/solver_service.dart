import 'package:flutter/services.dart' show rootBundle;
import '../models/puzzle_model.dart';

class SolverService {
  String? _dictionaryContent;

  Future<void> _loadDictionary(String path) async {
    _dictionaryContent ??= await rootBundle.loadString(path);
  }

  Future<PuzzleResult> solve(PuzzleInput input) async {
    if (input.letters.length < 7) {
      return PuzzleResult(error: 'Required 7+ letters not provided.');
    }

    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(input.letters)) {
      return PuzzleResult(
        error: 'Letters must only contain alphabetical characters.',
      );
    }

    try {
      await _loadDictionary(input.dictionaryPath);
    } catch (e) {
      return PuzzleResult(error: 'Failed to read dictionary file.');
    }

    if (_dictionaryContent == null || _dictionaryContent!.isEmpty) {
      return PuzzleResult(error: 'Dictionary is empty or failed to load.');
    }

    final allWords = _dictionaryContent!
        .split(RegExp(r'\r?\n'))
        .map((w) => w.trim())
        .where((w) => w.isNotEmpty)
        .toList();

    final inputLetters = input.letters.toLowerCase();
    final mandatoryLetter = inputLetters[0];
    final availableLetters = inputLetters.split('');

    final solvedWords = allWords.where((word) {
      final wordLower = word.toLowerCase();

      // 1. Minimum size
      if (wordLower.length < input.size) return false;

      // 2. Must contain the mandatory letter
      if (!wordLower.contains(mandatoryLetter)) return false;

      // 3. Must only use provided letters
      final wordLetters = wordLower.split('');

      if (input.repeats) {
        return wordLetters.every((l) => availableLetters.contains(l));
      } else {
        // Create a copy of the available letters count
        final Map<String, int> counts = {};
        for (var l in availableLetters) {
          counts[l] = (counts[l] ?? 0) + 1;
        }

        // For standard word puzzles, you can often use letters as many times
        // as you want IF you have at least one.
        // BUT the requirements said "Must only use provided letters".
        // Let's assume the user meant "Allow repeating letters" toggle should work.
        // If maniac is desired, we must ensure repeats=true works.

        for (var l in wordLetters) {
          if (!counts.containsKey(l) || counts[l]! <= 0) return false;
          counts[l] = counts[l]! - 1;
        }
        return true;
      }
    }).toList();

    // Sort by length descending, then alphabetically
    solvedWords.sort((a, b) {
      int lenCompare = b.length.compareTo(a.length);
      if (lenCompare != 0) return lenCompare;
      return a.compareTo(b);
    });

    return PuzzleResult(words: solvedWords);
  }
}
