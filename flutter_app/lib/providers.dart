import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

class SolverState {
  final List<String> words;
  final bool isLoading;
  final String? error;

  SolverState({
    this.words = const [],
    this.isLoading = false,
    this.error,
  });

  List<WordGroup> get groupedWords {
    final Map<int, List<String>> groups = {};
    for (var word in words) {
      final len = word.length;
      groups.putIfAbsent(len, () => []).add(word);
    }
    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    return sortedKeys.map((len) => WordGroup(length: len, words: groups[len]!)).toList();
  }

  SolverState copyWith({
    List<String>? words,
    bool? isLoading,
    String? error,
  }) {
    return SolverState(
      words: words ?? this.words,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class WordGroup {
  final int length;
  final List<String> words;
  WordGroup({required this.length, required this.words});
}

class SolverNotifier extends StateNotifier<SolverState> {
  final ApiService _apiService;

  SolverNotifier(this._apiService) : super(SolverState());

  Future<void> solve({
    required String letters,
    required int size,
    required bool repeats,
    required String dictionary,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final words = await _apiService.solve(
        letters: letters,
        size: size,
        repeats: repeats,
        dictionary: dictionary,
      );
      state = state.copyWith(words: words, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final apiServiceProvider = Provider((ref) => ApiService(baseUrl: 'http://localhost:3000'));

final solverProvider = StateNotifierProvider<SolverNotifier, SolverState>((ref) {
  return SolverNotifier(ref.watch(apiServiceProvider));
});
