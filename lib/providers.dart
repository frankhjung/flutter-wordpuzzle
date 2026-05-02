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
      input: state.input.copyWith(
        letters: letters,
        size: size,
        repeats: repeats,
        dictionaryPath: dictionaryPath,
      ),
    );
  }

  Future<void> solve() async {
    state = state.copyWith(result: state.result.copyWith(isLoading: true));

    try {
      // Background offloading using compute.
      // This helps keep the UI thread free during heavy dictionary filtering.
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
