# Key Deliverables

## Flutter Web Application

- Located in the `/flutter_app` directory.
- **State Management:** Built using **Riverpod** for robust and scalable state
  handling.
- **UI/UX:** Implemented with Material Design principles, featuring a clean
  input form and a responsive results display grouped by word length.
- **API Integration:** Includes an ApiService class to communicate with the
  Clojure backend via POST /api/solve.

## Docker Orchestration

- A docker-compose.yml file is provided in the root directory.
- It orchestrates the **Clojure backend** (running the solver as a server) and
  the **Flutter frontend** for seamless local development.

## Live Preview (React/Express)

- Since this environment is optimized for TypeScript/React, I have also built a
  fully functional **React version** of the UI for the live preview.
- **Mock Backend:** An Express server (`server.ts`) mocks the Clojure solver's
  API logic, allowing you to test the interface immediately.
- **Features:** Includes input validation (7+ letters), real-time filtering by
  length or text, and grouped results display.

## How to use the Flutter app

To run the Flutter application locally:

1. Ensure you have Flutter installed.
1. Navigate to the `flutter_app` directory.
1. Run `flutter pub get` to install dependencies.
1. Run `flutter run -d chrome` to start the web application.

## Docker Setup

To run the entire stack (Clojure + Flutter):

- Clone your Clojure repository into a folder named `clojure-wordpuzzle` in the
  root directory.
- Run `docker-compose up`.
- The backend will be available on port `3000` and the Flutter frontend on port
  `8080`.
