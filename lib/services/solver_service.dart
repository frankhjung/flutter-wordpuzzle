import 'package:flutter/services.dart' show rootBundle;
import '../models/puzzle_model.dart';

class SolverService {
  List<String>? _dictionaryWords;
  String? _dictionaryPath;

  Future<void> _loadDictionary(String path) async {
    if (_dictionaryWords != null && _dictionaryPath == path) {
      return;
    }
    final content = await rootBundle.loadString(path);
    _dictionaryPath = path;
    _dictionaryWords = content
        .split(RegExp(r'\r?\n'))
        .map((w) => w.trim())
        .where((w) => w.isNotEmpty)
        .toList();
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

    if (_dictionaryWords == null || _dictionaryWords!.isEmpty) {
      return PuzzleResult(error: 'Dictionary is empty or failed to load.');
    }

    final inputLetters = input.letters.toLowerCase();
    final mandatoryLetter = inputLetters[0];
    final availableLetters = inputLetters.split('');

    // Pre-calculate the letter counts if repeats are not allowed.
    // This is more efficient than doing it for every word in the dictionary.
    final Map<String, int> availableLetterCounts = {};
    if (!input.repeats) {
      for (var l in availableLetters) {
        availableLetterCounts[l] = (availableLetterCounts[l] ?? 0) + 1;
      }
    }

    final solvedWords = _dictionaryWords!.where((word) {
      final wordLower = word.toLowerCase();

      // 1. Minimum size
      if (wordLower.length < input.size) return false;

      // 2. Must contain the mandatory letter
      if (!wordLower.contains(mandatoryLetter)) return false;

      // 3. Optionally restrict to words that start with the mandatory letter
      if (input.startsWithMandatory && !wordLower.startsWith(mandatoryLetter)) {
        return false;
      }

      // 4. Must only use provided letters
      final wordLetters = wordLower.split('');

      if (input.repeats) {
        return wordLetters.every((l) => availableLetters.contains(l));
      } else {
        // Create a copy of the pre-calculated counts for this word check.
        final counts = Map<String, int>.from(availableLetterCounts);

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
