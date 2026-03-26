import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class PuzzleForm extends ConsumerStatefulWidget {
  const PuzzleForm({super.key});

  @override
  ConsumerState<PuzzleForm> createState() => _PuzzleFormState();
}

class _PuzzleFormState extends ConsumerState<PuzzleForm> {
  final _formKey = GlobalKey<FormState>();
  final _lettersController = TextEditingController();
  final _sizeController = TextEditingController(text: '4');
  final _dictionaryController = TextEditingController(
    text: 'assets/dictionary.txt',
  );

  @override
  void dispose() {
    _lettersController.dispose();
    _sizeController.dispose();
    _dictionaryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final notifier = ref.read(solverProvider.notifier);
      final currentRepeats = ref.read(solverProvider).input.repeats;
      notifier.updateInput(
        letters: _lettersController.text.toLowerCase(),
        size: int.parse(_sizeController.text),
        repeats: currentRepeats,
        dictionaryPath: _dictionaryController.text,
      );
      notifier.solve();
      // On mobile layouts, scroll down or close keyboard
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Puzzle Input', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lettersController,
            decoration: const InputDecoration(
              labelText: 'Letters (e.g. abcdefg)',
              helperText: '7+ letters. The first letter is mandatory.',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter letters';
              }
              if (value.length < 7) {
                return 'Must provide at least 7 letters';
              }
              if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                return 'Only alphabet characters allowed';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _sizeController,
            decoration: const InputDecoration(
              labelText: 'Minimum Word Size',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              if (int.parse(value) < 1) {
                return 'Size must be at least 1';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dictionaryController,
            decoration: const InputDecoration(
              labelText: 'Dictionary Path (Optional)',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Allow repeating letters?'),
            value: ref.watch(solverProvider).input.repeats,
            onChanged: (bool value) {
              ref.read(solverProvider.notifier).updateInput(repeats: value);
            },
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('Solve Puzzle'),
          ),
        ],
      ),
    );
  }
}
