# Recommendations

1. Structural Redundancy (Major) The project is currently split between a
   root-level Flutter skeleton and the actual application in the root directory.
   - Observation: Both the root and the former flutter_app/ had pubspec.yaml
     files. The original root lib/main.dart was just a default counter app.
   - Recommendation: Consolidate the project. Move everything from flutter_app/
     to the root to avoid confusion for developers and tools.
2. State Management Inconsistency (Moderate) The codebase contains a mix of
   Provider and Riverpod.
   - Observation: lib/main.dart used MultiProvider (from package:provider),
     while providers.dart defined Notifier classes for Riverpod.
   - Issue: The app was using SolverController (via Provider) in the UI, leaving
     the more robust Riverpod logic in providers.dart unused.
   - Recommendation: Standardise on one framework. Given the complexity of the
     solver logic, Riverpod is generally preferred for new Flutter web/mobile
     projects.
3. Standards Compliance (Minor)
   - Formatting: I identified two files (lib/providers.dart and
     lib/views/puzzle_results.dart) that were not formatted according to
     standard Dart conventions.
   - Analysis: Static analysis (flutter analyze) passed without issues, which is
     excellent.
   - Documentation: The project correctly uses Australian English for
     documentation and US English for code, adhering to the project's mandates.
4. Code Organisation
   - Models: The logic for grouping words by length in providers.dart should
     ideally be moved to a dedicated SolverResult model or extension to keep the
     state notifier clean.
   - Naming: SolverController follows an MVC pattern, which is valid, but in
     Flutter, these are more commonly named ChangeNotifier (for Provider) or
     Notifier (for Riverpod).

## Changes

1. Consolidate project to root level, removing flutter_app/ subdirectory.
2. Use only Riverpod for state management, removing Provider usage.
3. Code Organisation
   - Models: The logic for grouping words by length in providers.dart was moved
     to a dedicated SolverResult model or extension to keep the state notifier
     clean.
   - Naming: SolverController followed an MVC pattern, which is valid, but in
     Flutter, these are more commonly named ChangeNotifier (for Provider) or
     Notifier (for Riverpod). The project now uses Notifiers.
4. Fix lint issues.
5. Cleanup documentation to align with code. If the repeats flag is not set then
   the solver will not only use the letters in the input. Repeats allows the
   solve to use the same letter multiple times, which is necessary for some
   puzzles. This was not clearly explained in the original documentation.
6. Ensure code is Flutter web compatible. The original code had some patterns
   that are more common in mobile Flutter apps, such as using Provider and
   certain UI patterns. The refactored code should be tested to ensure it works
   well in a web context, especially with regards to state management and
   performance.
7. Review documentation for accuracy and clarity. The original documentation had
   some inconsistencies and could be improved to better explain the features and
   usage of the application. The refactored documentation should be clear,
   concise, and accurately reflect the functionality of the app.
8. Remove legacy code. The original TypeScript and React Node frontend codes
   have been completely removed. The current implementation relies entirely on a
   client-side Dart MVC architecture, which is more suitable for a Flutter web
   application. This cleanup helps to reduce confusion and streamline the
   codebase for future development.
9. Update `test/solver_integration_test.dart` to include two distinct tests: one
   where repeating letters are disabled (finding `manic` but not `maniac` with
   "mitncao") and another where they are enabled (finding both).
10. Add caching for `.dart_tool/build`.
11. Check pipeline actions are up to date.
