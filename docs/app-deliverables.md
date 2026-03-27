# Key Deliverables

## Pure Flutter Web Application

- **Location:** Project root directory.
- **Framework:** Flutter Web with Riverpod state management.
- **Architecture:** `lib/main.dart` + `lib/views/` + `lib/models/` +
  `lib/services/`.
- **Functionality:** Entire solver flow runs client-side in Dart using
  `assets/dictionary.txt`.

## Solver and State Management

- **Solver Service:** `lib/services/solver_service.dart`.
- **State Layer:** `lib/providers.dart` (`SolverNotifier` and providers).
- **Data Models:** `lib/models/puzzle_model.dart`.

## Build and Run Tooling

- **Make Targets:** `make format`, `make lint`, `make build`, `make run`,
  `make test`.
- **Build Output:** `flutter build web` assets under `build/web/`.
- **Configured Build Path:** `make build` runs
  `flutter build web --base-href /flutter-wordpuzzle/`.

## Docker Deployment

- **Compose File:** `docker-compose.yml`.
- **Container Runtime:** Nginx serves static Flutter web assets.
- **Access URL:** `http://localhost:8080`.

## How to Run Locally (Web)

1. Ensure Flutter SDK (stable) is installed.
2. From the project root, run `flutter pub get`.
3. Run `make run` (defaults to Chrome).

## How to Run with Docker

1. From the project root, run `docker compose up --build`.
2. Open `http://localhost:8080` in a browser.
