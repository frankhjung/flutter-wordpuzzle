import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

// Sentinel used to distinguish "not provided" from explicit null in copyWith.
const _undefined = Object();

class SolverState {
  final List<String> words;
  final bool isLoading;
  final String? error;

  SolverState({this.words = const [], this.isLoading = false, this.error});

  List<WordGroup> get groupedWords {
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

  /// Pass [error] explicitly to update it; omit the parameter to preserve the
  /// existing value; pass `null` to clear it.
  SolverState copyWith({
    List<String>? words,
    bool? isLoading,
    Object? error = _undefined,
  }) {
    return SolverState(
      words: words ?? this.words,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _undefined) ? this.error : error as String?,
    );
  }
}

class WordGroup {
  final int length;
  final List<String> words;
  WordGroup({required this.length, required this.words});
}

class SolverNotifier extends Notifier<SolverState> {
  ApiService get _apiService => ref.watch(apiServiceProvider);

  @override
  SolverState build() => SolverState();

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
      state = state.copyWith(words: words, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

class FoundWordsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void reset() {
    state = <String>{};
  }

  void addWord(String word) {
    final value = word.trim();
    if (value.isEmpty || state.contains(value)) return;
    state = <String>{...state, value};
  }

  void removeWord(String word) {
    if (!state.contains(word)) return;
    state = state.where((w) => w != word).toSet();
  }
}

final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiService(baseUrl: 'http://localhost:3000'),
);

final solverProvider = NotifierProvider<SolverNotifier, SolverState>(
  SolverNotifier.new,
);

final foundWordsProvider =
    NotifierProvider<FoundWordsNotifier, Set<String>>(FoundWordsNotifier.new);
