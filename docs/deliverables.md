# Key Deliverables

## Node.js Mock Backend & React Web Application

- **Location:** Project root directory.
- **Backend:** Express server implemented in `server.ts` with TypeScript.
- **Frontend:** React 19 application using Vite, TypeScript, and Tailwind CSS.
- **Functionality:** Provides both the solver API and the main web UI for
  immediate local development and testing.

## Flutter Web Application

- **Location:** `/flutter_app` directory.
- **Framework:** Built using Flutter with Riverpod for state management.
- **Features:** Responsive UI following Material Design principles, integrated
  with the `POST /api/solve` endpoint.

## Docker Orchestration

- **File:** `docker-compose.yml` in the root directory.
- **Services:** Configured to orchestrate the Clojure backend and Flutter
  frontend.
- **Note:** Requires a local clone of the `clojure-wordpuzzle` repository to run
  correctly.

## How to use the Web Stack (React/Express)

To run the default React web application and Node.js backend:

1. Ensure you have Node.js 20+ installed.
2. From the project root, run `npm install`.
3. Start the server and UI with `npm run dev`.
4. Access the application at `http://localhost:3000`.

## How to use the Flutter app

To run the Flutter application locally:

1. Ensure you have the Flutter SDK installed.
2. Navigate to the `flutter_app` directory.
3. Run `flutter pub get`.
4. Run `flutter run -d chrome` to start the web application.
5. The app will communicate with the API at `http://localhost:3000`.

## Docker Setup

To run the Clojure-based stack:

1. Clone the Clojure repository:
   `git clone https://github.com/frankhjung/clojure-wordpuzzle`
2. Run `docker-compose up`.
3. The Clojure backend will be available on port `3000` and the Flutter frontend
   on port `8080`.
