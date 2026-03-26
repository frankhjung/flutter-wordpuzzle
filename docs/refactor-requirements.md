# Refactor

## Personas

You are an expert Flutter developer and DevOps engineer. Implement the following
specification. Provide complete, runnable code blocks for all deliverables.

## Goal

This refactor will transform the codebase into a **pure Flutter web app**. The
Flutter app should produce the web UI from Dart/Flutter code and not rely on
React, Vite, or TypeScript front-end code for production.

## Scope

- Remove React/Vite and TypeScript UI dependencies from the deployed stack.
- Keep Flutter code as the only frontend source.
- Port core solver logic into Dart (or layer with Dart API if necessary).
- Enable `flutter build web` output to serve the app directly.

## Tasks

- port TypeScript/Node backend solver into Dart (`lib/solver.dart`).
- build Flutter web UI in `lib/main.dart` with Material widgets.
- preserve feature parity for puzzle settings and output behavior.
- remove React-specific code and any unused TypeScript modules.
- document any remaining TypeScript usage as legacy/transition code.

## UI/UX & Layout (Flutter web)

Create web UIs for the word puzzle solver to collect puzzle inputs and show
results.

- **Layout:** central responsive form with Material styling.
- **Inputs:** fields for `size`, `letters`, `repeats`, optional `dictionary`.
- **Validation:** `letters` must be 7+ lowercase letters; first position letter
  is required; no non-alpha characters.
- **Results Display:** scrollable results grouped by word length, with counts
  and highlights.

## Error Handling

Display clear error messages for:

- solver input validation failure (invalid letters, missing required fields).
- solver runtime errors (internal algorithm failures).
- "No words found" results when solver returns no matches.

If a backend mode is used for remote compute:

- network/connection failures.
- HTTP errors and timeouts.

## Technical Requirements

### Flutter Frontend

- **Framework:** Flutter, web target.
- **State Management:** Riverpod (or Provider) for form + results state.
- **Design:** responsive Material, accessible controls, keyboard navigation.
- **Deployment:** `flutter build web` generates `build/web/` static assets.

### Backend (optional)

- Prefer client-side Dart solver in Flutter.
- If a server is required, use Dart-based `shelf` service or a simple API that
  Flutter web calls with JSON.

## Migration & Clean-up

- Delete `src/`, `package.json`, `server.ts`, and Node-only artifacts after
  verifying Flutter parity.
- Keep documentation noting that React stack is deprecated.

## Testing

- unit test solver logic (`test/solver_test.dart`).
- widget test for form validation and output
  (`test/widget_test.dart`).
- web integration test verifying end-to-end form submit and results.

## Success Criteria

- App runs as a Pure Flutter Web app with no React/Vite dependency in
  production.
- Inputs, validation, error handling, and results match previous behavior.
- Build pipeline: `flutter build web && serve -s build/web`.
