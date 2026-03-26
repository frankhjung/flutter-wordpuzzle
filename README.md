# Word Puzzle Solver

This repository contains a local word-puzzle solver deployed as a Pure Flutter
Web app.

## Sample Puzzle

The puzzle consists of a set of letters and a list of word lengths. The goal is
to find all valid words that can be formed using the given letters and match the
specified lengths.

- **Letters**: `mitncao` - here `m` is mandatory and must be included in every
  word)
- **Word Lengths**: `4, 5, 6, 7,...` - 4 more letters in each word
- **Allow Repeating Letters**: Yes - each letter can be used multiple times in a
  word
- **Dictionary**: A standard English dictionary is used to validate the words.

![Spelling Bee sample puzzle](docs/example-spelling-bee.png)

## Requirements and Change Notes

See project notes in [docs/](docs/)

- [Initial Application Requirements](docs/app-requirements.md)
- [Application Deliverables](docs/app-deliverables.md)
- [Refactoring Requirements](docs/refactoring-requirements.md)
- [Refactoring Implementation](docs/refactoring-implementation.md)
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

### Format

From the repository root:

```bash
make format
# or
dart format .
```

### 1. Run via Docker Compose

To start the project locally with the bundled Nginx server:

```bash
# Docker Compose v2 (recommended)
docker compose up --build

# Or legacy Docker Compose (older installations)
docker-compose up --build
```

The web UI will be served at `http://localhost:8080`.mitncao

#### Docker build tips

- To use prebuilt web assets (faster): first build assets locally, then build
  the image's `prebuilt` target:

```bash
flutter build web
docker build --target prebuilt -t wordpuzzle .
docker run -p 8080:80 wordpuzzle
```

- Default image build runs the Flutter build inside the image (slower):

```bash
docker build -t wordpuzzle .
docker run -p 8080:80 wordpuzzle
```

### 2. Run the Flutter app locally

From the repository root:

```bash
make run
```

This defaults to running the Flutter app in Chrome.

## Build

From the repository root:

```bash
make build
```

This compiles the Flutter app into web assets in `build/web`.

## Tests

To run the Flutter tests:

```bash
make test
```

## Legacy Code

The original TypeScript and React Node frontend codes have been completely
removed. The current implementation relies entirely on a client-side Dart MVC
architecture for both UI and the anagram solving logic.
