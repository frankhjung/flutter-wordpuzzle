# Flutter Word Puzzle Solver

This project is the Flutter frontend application for the Word Puzzle Solver.
It provides a responsive, Material Design interface to interact with the backend API.

## Core Stack

- **Framework:** Flutter (stable)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Networking:** `http` package

## Quick Start

For full project context, architecture, and Docker instructions, please refer to the **[root README.md](../README.md)**.

To run this Flutter app locally:

1. Ensure the backend API is running (see root README).
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application (defaults to Chrome with WebAssembly):
   ```bash
   flutter run -d chrome --wasm
   ```

## Testing and Linting

To analyze the code for stylistic errors:
```bash
flutter analyze
```

To run the widget and unit tests:
```bash
flutter test --platform chrome --wasm
```
