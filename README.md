# Word Puzzle Solver

This repository contains a local word-puzzle solver with:

- A React + Vite web UI and Node/Express API in the workspace root.
- A Flutter app in [flutter_app/](flutter_app/) that calls the same API.
- A local dictionary file at [resources/dictionary](resources/dictionary).

See project notes in [docs/requirements.md](docs/requirements.md) and
[docs/deliverables.md](docs/deliverables.md).

## Quick Start

### Prerequisites

- Node.js 20+ and npm
- Flutter SDK (stable channel)
- GNU Make
- (Optional) Docker and Docker Compose

### Install dependencies

From the repository root:

```bash
npm install
cd flutter_app && flutter pub get
```

### 1. Start the web app + API

From the repository root:

```bash
make run
```

This starts the Express server (with Vite middleware) at:

- `http://localhost:8080`

The UI and API are served from the same process. The solver endpoint is:

- `POST /api/solve`

### 2. Run the Flutter app

From the repository root:

```bash
make run-flutter
```

This defaults to running the Flutter app in Chrome.

To use another supported device, override `FLUTTER_DEVICE`, for example:

```bash
make run-flutter FLUTTER_DEVICE=linux
```

By default, Flutter uses `http://localhost:8080` as the API base URL.

#### Spelling Bee Example

- **Letters:** `mitncao`
- **Repeats:** `true`

![Spelling Bee Example](docs/example-spelling-bee.png)

## Build Locally

### Web build

From the repository root:

```bash
make build-web
```

Build output is written to `dist/`.

### Flutter build (example: web)

From the repository root:

```bash
make build-flutter
```

To build both web and Flutter artifacts in one command:

```bash
make build
```

## Test Locally

### Type-check the web code

From the repository root:

```bash
make lint-web
```

### Run Flutter widget tests

From the repository root:

```bash
make test-flutter
```

To run all configured tests in one command:

```bash
make test
```

## Common Make Targets

From the repository root:

```bash
make help
make format
make lint
make build
make test
make ci
```

## Docker (optional)

`docker-compose.yml` defines:

- `app`: React + Vite UI and local Node/Express solver on port `8080`

To start the project using Docker Compose, run:

```bash
docker compose up --build
```

To run it in the background (detached mode), use:

```bash
docker compose up -d --build
```

To stop the services, run:

```bash
docker compose down
```

The container serves the web UI and `POST /api/solve` from the same process at:

- `http://localhost:8080`

Docker Compose no longer depends on the external `clojure/wordpuzzle` project.

On Linux, the compose file uses host networking to avoid Docker bridge
forwarding, which can be blocked by strict local firewall policies.

## Dependencies

### Managing Outdated Packages

To check for outdated dependencies and update them, you will need to run
commands for both the web (Node.js) and Flutter environments.

**For the Web App (Node.js):**

To view outdated packages:

```bash
npm outdated
```

To safely update packages to the latest versions within the ranges specified in
`package.json`:

```bash
npm update
```

_(Optional)_ To upgrade packages to their absolute latest versions (modifying
`package.json`), you can use `npm-check-updates`. (Installing it locally first avoids caching bugs with older global `npx` versions):

```bash
npm install -D npm-check-updates
npx ncu -u
npm install
```

**For the Flutter App:**

To view outdated packages:

```bash
cd flutter_app
flutter pub outdated
```

To upgrade packages to their latest compatible versions:

```bash
cd flutter_app
flutter pub upgrade
```

To upgrade packages to their absolute latest major versions (modifying
`pubspec.yaml`):

```bash
cd flutter_app
flutter pub upgrade --major-versions
```

## CI Configuration

GitHub Actions workflows read Flutter SDK version from the repository variable
`FLUTTER_VERSION`.

Set it in: Settings -> Secrets and variables -> Actions -> Variables.

Update that single variable when upgrading Flutter for CI.

### Project Dependencies

The current dependencies and their versions are managed in the following configuration files:

- **Root (web/API):** See [`package.json`](package.json).
- **Flutter App:** See [`flutter_app/pubspec.yaml`](flutter_app/pubspec.yaml).

## Flutter: Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
