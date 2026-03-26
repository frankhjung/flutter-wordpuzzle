# Refactoring to Pure Flutter Web App

This plan describes migrating the Word Puzzle solver from a React/Vite/TypeScript frontend and Node.js backend into a pure Flutter Web application, as per the specifications in [docs/refactor.md](file:///home/frank/dev/flutter/wordpuzzle/docs/refactor.md).

## Proposed Changes

### 1. Initialise and Structure Flutter App

- Clean up or initialise Flutter app structure properly if it doesn't already exist.
- Ensure the project builds targeting web successfully.

---

### 2. Implement the Solver Logic within an MVC Architecture

- Adopt a Model / View / Controller (MVC) pattern to separate presentation from the word solver service.
- Port the game solving logic to a Dart "Service" or "Controller".
- Models will define the data structures (e.g. puzzle input parameters, dictionary, result lists).
- Ensure performance and memory usage are optimal since it will run fully client-side.

#### [NEW] lib/models/puzzle_model.dart

#### [NEW] lib/controllers/solver_controller.dart

#### [NEW] lib/services/solver_service.dart

---

### 3. Build the Frontend Interface

- Rewrite [src/App.tsx](file:///home/frank/dev/flutter/wordpuzzle/src/App.tsx) and related components as Flutter widgets (Views).
- Implement the requested Material design layout: form to collect inputs, validating 7+ minimum characters, alphabet only.
- Show scrollable results list with grouping and highlighting.
- Build error handling states and network (or solver logic) error surfaces.
- Use **Provider** for state management to connect Views with Models and Controllers.

#### [MODIFY] lib/main.dart

#### [NEW] lib/views/puzzle_form.dart

#### [NEW] lib/views/puzzle_results.dart

---

### 4. Delete Obsolete Dependencies and React Stack

- Drop the Vite build process.
- Remove all Node toolchain dependencies along with [server.ts](file:///home/frank/dev/flutter/wordpuzzle/server.ts).

#### [DELETE] src/

#### [DELETE] index.html

#### [DELETE] vite.config.ts

#### [DELETE] tsconfig.json

#### [DELETE] package.json

#### [DELETE] package-lock.json

#### [DELETE] server.ts

#### [MODIFY] README.md (Remove React references, add Flutter deployment instructions)

---

### 5. Update Docker and Build Scripts

- Update [Makefile](file:///home/frank/dev/flutter/wordpuzzle/Makefile) to use `make build` and `make test`.
- Update [Dockerfile](file:///home/frank/dev/flutter/wordpuzzle/Dockerfile) and [docker-compose.yml](file:///home/frank/dev/flutter/wordpuzzle/docker-compose.yml) so that the app can be run locally using Docker Compose.

#### [MODIFY] Makefile

#### [MODIFY] Dockerfile

#### [MODIFY] docker-compose.yml

## Verification Plan

### Automated Tests

- Write unit tests targeting the Dart solver service to verify dictionary lookups, filtering, and edge cases.
- Write widget test ([test/widget_test.dart](file:///home/frank/dev/flutter/wordpuzzle/test/widget_test.dart)) to verify structural separation and form validations.
- Run tests via `make test`.

### Manual Verification

- Build using `make build`.
- Start the application using Docker Compose (`docker-compose up`).
- Use the web interface to manually submit standard anagrams/letter combinations and visual-check the styling mapping to Material recommendations.
