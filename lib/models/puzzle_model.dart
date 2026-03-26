class PuzzleInput {
  final String letters;
  final int size;
  final bool repeats;
  final String dictionaryPath;

  PuzzleInput({
    required this.letters,
    this.size = 4,
    this.repeats = true,
    this.dictionaryPath = 'assets/dictionary.txt',
  });
}

class WordGroup {
  final int length;
  final List<String> words;
  WordGroup({required this.length, required this.words});
}

class PuzzleResult {
  final List<String> words;
  final String? error;
  final bool isLoading;

  PuzzleResult({this.words = const [], this.error, this.isLoading = false});

  List<WordGroup> get groupedWords {
    if (words.isEmpty) return [];
    final Map<int, List<String>> groups = {};
    for (var word in words) {
      final len = word.length;
      groups.putIfAbsent(len, () => []).add(word);
    }
    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    return sortedKeys
        .map((len) => WordGroup(length: len, words: groups[len]!))
        .toList();
  }

  PuzzleResult copyWith({List<String>? words, String? error, bool? isLoading}) {
    return PuzzleResult(
      words: words ?? this.words,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
