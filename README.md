# Word Puzzle Solver

This repository contains a local word-puzzle solver with:

- A React + Vite web UI and Node/Express API in the workspace root.
- A Flutter app in `flutter_app/` that calls the same API.
- A local dictionary file at `resources/dictionary`.

See project notes in `docs/requirements.md` and `docs/deliverables.md`.

## Quick Start

### Prerequisites

- Node.js 20+ and npm
- Flutter SDK (stable channel)
- (Optional) Docker and Docker Compose

### 1. Start the web app + API

From the repository root:

```bash
npm install
npm run dev
```

This starts the Express server (with Vite middleware) at:

- `http://localhost:3000`

The UI and API are served from the same process. The solver endpoint is:

- `POST /api/solve`

### 2. Run the Flutter app

From `flutter_app/`:

```bash
flutter pub get
flutter run
```

By default, Flutter uses `http://localhost:3000` as the API base URL.

## Build Locally

### Web build

From the repository root:

```bash
npm run build
```

Build output is written to `dist/`.

### Flutter build (example: web)

From `flutter_app/`:

```bash
flutter build web
```

## Test Locally

### Type-check the web code

From the repository root:

```bash
npm run lint
```

### Run Flutter widget tests

From `flutter_app/`:

```bash
flutter test
```

## Docker (optional)

`docker-compose.yml` defines:

- `frontend`: Flutter web app on port `8080`
- `backend`: Clojure service on port `3000`

Note: the compose file mounts `./clojure-wordpuzzle`, which is not included in
this workspace by default.

## Dependencies

### Root (web/API) dependencies

- `@google/genai` `^1.29.0`
- `@tailwindcss/vite` `^4.1.14`
- `@vitejs/plugin-react` `^5.0.4`
- `dotenv` `^17.2.3`
- `express` `^4.21.2`
- `lucide-react` `^0.546.0`
- `motion` `^12.23.24`
- `react` `^19.0.0`
- `react-dom` `^19.0.0`
- `vite` `^6.2.0`

### Root dev dependencies

- `@types/express` `^4.17.21`
- `@types/node` `^22.14.0`
- `autoprefixer` `^10.4.21`
- `tailwindcss` `^4.1.14`
- `tsx` `^4.21.0`
- `typescript` `~5.8.2`
- `vite` `^6.2.0`

### Flutter dependencies (`flutter_app/pubspec.yaml`)

- `cupertino_icons` `^1.0.2`
- `flutter_riverpod` `^2.3.6`
- `http` `^1.1.0`
- `json_annotation` `^4.8.1`

### Flutter dev dependencies

- `flutter_lints` `^2.0.0`
- `flutter_test` (SDK)
