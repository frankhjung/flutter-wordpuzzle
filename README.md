# Word Puzzle Solver

This repository contains a local word-puzzle solver deployed as a pure Flutter
Web app.

## Architecture Overview

### Component Diagram

```mermaid
flowchart LR
  U[User Browser]

  subgraph WebApp[Flutter Web App]
    M[lib/main.dart]
    P[lib/providers.dart]
    F[views/puzzle_form.dart]
    R[views/puzzle_results.dart]
    PM[models/puzzle_model.dart]
    S[services/solver_service.dart]
    D[assets/dictionary.txt]
  end

  U --> M
  M --> P
  P --> F
  P --> R
  F --> PM
  R --> PM
  PM --> S
  S --> D
```

### Web Rendering Flow

```mermaid
sequenceDiagram
  participant B as Browser
  participant V as Puzzle views
  participant SV as Solver service (Main)
  participant SI as Solver Isolate
  participant DI as dictionary.txt

  B-->>V: User submits puzzle input
  V->>SV: Request candidate words
  SV->>DI: Read dictionary data
  DI-->>SV: Return dictionary
  SV->>SI: Offload filtering (compute)
  SI-->>SV: Return sorted/grouped results
  SV-->>V: Update state (Riverpod)
  V-->>B: Re-render results UI
```

## Performance & Optimization

- **Background Solving**: Heavy dictionary filtering and sorting are offloaded
  to a background isolate using Flutter's `compute` function, ensuring the UI
  thread remains responsive.
- **Optimised Algorithm**: Pre-calculates letter counts for puzzles without
  repeats to speed up dictionary filtering.
- **Structured Data**: Results are pre-grouped by word length in the service
  layer to reduce UI-thread computation.
- **Input Control**: Uses `TextInputFormatter`s for real-time validation and
  keyboard-level input restriction.

## Sample Puzzle

The puzzle consists of one mandatory letter, additional allowed letters, a
minimum word size, and an optional repeat-letters rule. The goal is to find all
valid words that satisfy these constraints.

- **Mandatory Letter**: `m` (must appear in every word)
- **Other Letters**: `itncao`
- **Minimum Word Size**: `4`
- **Allow Repeating Letters**: Yes
- **Dictionary**: A standard English dictionary is used to validate the words.

![Spelling Bee sample puzzle](docs/example-spelling-bee.png)

## Requirements and Change Notes

See project notes in [docs/](docs/)

- [Initial Application Requirements (historical, pre-refactor)](docs/app-requirements.md)
- [Application Deliverables](docs/app-deliverables.md)
- [Refactoring Requirements](docs/refactor-requirements.md)
- [Refactoring Implementation](docs/refactor-implementation-plan.md)
- [Changes](docs/changes.md)

## Quick Start

### Prerequisites

- Flutter SDK (stable channel)
- GNU Make
- (Optional) Docker and Docker Compose

  Note: some environments use the legacy `docker-compose` (hyphen) command.

### Install dependencies

From the repository root:

```bash
flutter pub get
```

To safely upgrade dependencies that are compatible with the current SDK and
constraints:

```bash
make deps-upgrade-safe
```

### Format

From the repository root:

```bash
make format
# or
dart format .
```

### Run via Docker Compose

To start the project locally with the bundled Nginx server:

```bash
# Docker Compose v2 (recommended)
docker compose up --build
```

The web UI will be served at `http://localhost:8080`.

#### Docker build tips

- To use prebuilt web assets (faster): first build assets locally, then build
  the image's `prebuilt` target:

```bash
make build
docker build --target prebuilt -t wordpuzzle .
docker run -p 8080:80 wordpuzzle
```

- Default image build runs the Flutter build inside the image (slower):

```bash
docker build -t wordpuzzle .
docker run -p 8080:80 wordpuzzle
```

### Run the Flutter app locally

From the repository root:

```bash
make run
```

Note: Type `q` to quit the session.

This defaults to running the Flutter app in Chrome.

This project targets the web only.

## Build

From the repository root:

```bash
make build
```

This compiles a JavaScript web build into `build/web`.

The build target uses `--base-href /flutter-wordpuzzle/` by default. Override
with:

```bash
make build WEB_BASE_HREF=/
```

## Tests

To run the Flutter tests:

```bash
make test
```

## Updates

To check for outdated packages:

```bash
flutter pub outdated
```

To update packages to the latest versions allowed by the current constraints:

```bash
make deps-upgrade-safe
# or
flutter pub upgrade
```

To update all packages to their newest major versions (this updates
`pubspec.yaml`):

```bash
flutter pub upgrade --major-versions
```

### Transitive Dependencies

Transitive dependencies are packages that your direct dependencies rely on.
When you run `flutter pub upgrade` (or `make deps-upgrade-safe`), Flutter
automatically updates all packages, including transitive ones, to the newest
versions that satisfy the constraints set by your direct dependencies.

To see if any transitive dependencies have newer versions available:

```bash
flutter pub outdated --transitive
```

**Note on forcing updates:** It is generally not advisable to force transitive
dependencies to upgrade past their allowed constraints (e.g., using a
`dependency_overrides` block in `pubspec.yaml`). Doing so means your direct
dependencies will run against package versions they weren't tested with, which
frequently leads to build errors or breaking changes.

## CI and Deployment

- CI runs format checks, analysis, standard JS tests, JS web build.
- GitHub Pages deployment (on `main`) publishes a **JS release** build.

## Legacy Code

The original TypeScript and React Node frontend codes have been completely
removed from the active app stack. The current implementation is a pure Flutter
Web client with a client-side Dart solver and Riverpod-managed state.
