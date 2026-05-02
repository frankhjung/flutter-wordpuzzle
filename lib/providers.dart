import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/puzzle_model.dart';
import 'services/solver_service.dart';

class SolverState {
  final PuzzleInput input;
  final PuzzleResult result;

  SolverState({required this.input, required this.result});

  SolverState copyWith({PuzzleInput? input, PuzzleResult? result}) {
    return SolverState(
      input: input ?? this.input,
      result: result ?? this.result,
    );
  }
}

class SolverNotifier extends Notifier<SolverState> {
  SolverService get _solverService => ref.watch(solverServiceProvider);

  @override
  SolverState build() {
    return SolverState(
      input: PuzzleInput(letters: ''),
      result: PuzzleResult(),
    );
  }

  void updateInput({
    String? letters,
    int? size,
    bool? repeats,
    String? dictionaryPath,
  }) {
    state = state.copyWith(
      input: PuzzleInput(
        letters: letters ?? state.input.letters,
        size: size ?? state.input.size,
        repeats: repeats ?? state.input.repeats,
        dictionaryPath: dictionaryPath ?? state.input.dictionaryPath,
      ),
    );
  }

  Future<void> solve() async {
    state = state.copyWith(result: state.result.copyWith(isLoading: true));

    try {
      final result = await _solverService.solve(state.input);
      state = state.copyWith(result: result);
    } catch (e) {
      state = state.copyWith(
        result: PuzzleResult(error: e.toString(), isLoading: false),
      );
    }
  }

  void reset() {
    state = SolverState(
      input: PuzzleInput(letters: ''),
      result: PuzzleResult(),
    );
  }
}

final solverServiceProvider = Provider<SolverService>((ref) => SolverService());

final solverProvider = NotifierProvider<SolverNotifier, SolverState>(
  SolverNotifier.new,
);
