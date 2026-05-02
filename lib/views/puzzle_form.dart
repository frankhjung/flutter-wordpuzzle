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
  final _mandatoryController = TextEditingController();
  final _lettersController = TextEditingController();
  final _sizeController = TextEditingController(text: '4');

  @override
  void dispose() {
    _mandatoryController.dispose();
    _lettersController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final notifier = ref.read(solverProvider.notifier);
      final currentRepeats = ref.read(solverProvider).input.repeats;
      notifier.updateInput(
        letters: _mandatoryController.text.toLowerCase() +
            _lettersController.text.toLowerCase(),
        size: int.parse(_sizeController.text),
        repeats: currentRepeats,
      );
      notifier.solve();
      // Close the active input after submitting in browser contexts.
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
            controller: _mandatoryController,
            decoration: const InputDecoration(
              labelText: 'Mandatory letter',
              border: OutlineInputBorder(),
            ),
            maxLength: 1,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a letter';
              }
              if (!RegExp(r'^[a-z]$').hasMatch(value)) {
                return 'Only lowercase alphabet characters allowed';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lettersController,
            decoration: const InputDecoration(
              labelText: 'Other Letters (e.g. bcdefg)',
              helperText: '6+ letters.',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter letters';
              }
              if (value.length < 6) {
                return 'Must provide at least 6 letters';
              }
              if (!RegExp(r'^[a-z]+$').hasMatch(value)) {
                return 'Only lowercase alphabet characters allowed';
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
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            validator: (value) {
              if (value == null || int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              if (int.parse(value) < 4) {
                return 'Size must be at least 4';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            key: const Key('repeats-toggle'),
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
