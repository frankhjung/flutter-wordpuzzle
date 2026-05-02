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

  PuzzleInput copyWith({
    String? letters,
    int? size,
    bool? repeats,
    String? dictionaryPath,
  }) {
    return PuzzleInput(
      letters: letters ?? this.letters,
      size: size ?? this.size,
      repeats: repeats ?? this.repeats,
      dictionaryPath: dictionaryPath ?? this.dictionaryPath,
    );
  }
}

class WordGroup {
  final int length;
  final List<String> words;
  WordGroup({required this.length, required this.words});
}

class PuzzleResult {
  final List<WordGroup> groups;
  final String? error;
  final bool isLoading;

  PuzzleResult({this.groups = const [], this.error, this.isLoading = false});

  /// Total count of words across all groups.
  int get totalWords =>
      groups.fold(0, (sum, group) => sum + group.words.length);

  /// Checks if a specific word is present in any group.
  bool contains(String word) =>
      groups.any((group) => group.words.contains(word));

  PuzzleResult copyWith({
    List<WordGroup>? groups,
    String? error,
    bool? isLoading,
  }) {
    return PuzzleResult(
      groups: groups ?? this.groups,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
