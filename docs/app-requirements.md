# Requirements

> Historical note: this document captures the initial pre-refactor
> requirements. The current implementation is documented in
> `docs/refactor-requirements.md` and `docs/refactor-implementation-plan.md`.

## Personas

You are an expert Flutter and React developer and DevOps engineer. Implement the
following specification. Provide complete, runnable code blocks for all

- `-d`, `--dictionary STRING` assets/dictionary.txt Alternate word
  dictionary The goal is to create a multi-frontend web application to solve
  word puzzles. The system consists of:

- A Node.js/Express mock backend providing the puzzle-solving logic via a REST
  API.
- A React-based web UI served from the root.

```bash
java -jar target/uberjar/wordpuzzle-*-standalone.jar --size=7 --letters=cadevrsoi --dictionary=assets/dictionary.txt
```

- a Flutter-based mobile/web UI.

The system can also integrate with an existing Clojure repository,
<https://github.com/frankhjung/clojure-wordpuzzle>.

## Command-line Interface (CLI) Contract

### Inputs

The inputs to the word puzzle solver are:

- `-d`, `--dictionary STRING` resources/dictionary Alternate word dictionary

  ```bash
  java -jar target/uberjar/wordpuzzle-*-standalone.jar --size=7 --letters=cadevrsoi --dictionary=assets/dictionary.txt
  discover
  divorce
  divorces
  sidecar
  varicose
  viscera
  ```

- `-s`, `--size INT 4` Minimum word size
- `-l`, `--letters STRING` [REQUIRED] 7+ lowercase letters to make words
- `-r`, `--repeats` Letters can be repeated (e.g., Spelling Bee)

### Example CLI Usage

```bash
java -jar target/uberjar/wordpuzzle-*-standalone.jar --size=7 --letters=cadevrsoi --dictionary=resources/dictionary
```

### Example CLI Output

```bash
java -jar target/uberjar/wordpuzzle-*-standalone.jar --size=7 --letters=cadevrsoi --dictionary=resources/dictionary
discover
divorce
divorces
sidecar
varicose
viscera
```

## API & Integration Contract

The web UIs interact with the backend via a RESTful HTTP API.

- **Endpoint:** `POST /api/solve`
- **Request Payload:** A JSON object matching the solver's expected parameters:

  ```json
  {
    "dictionary": "resources/dictionary",
    "size": 4,
    "letters": "abcdefg",
    "repeats": false
  }
  ```

- **Response Format:** A JSON array containing a sorted list of words.

## UI/UX & Layout

Create web UIs for the word puzzle solver that allows users to input their
puzzle configurations.

- **Layout:** A clean, central input form utilising standard text fields and
  toggles, styled with modern design principles (Material for Flutter, Tailwind/
  Framer Motion for React).
- **Inputs:** Form fields must map directly to the CLI backend inputs (`size`,
  `letters`, `repeats`, and optional `dictionary`).
- **Validation:** Prevent layout/submission errors if the required 7+ lowercase
  letters are not provided. (The mandatory letters must be in the first position
  of `letters`.)
- **Results Display:** Display the returned words in an organised manner, such
  as a scrollable list grouped by word length.

## Error Handling

The UIs must handle and display specific, clear error messages to the user for
the following scenarios:

- Network or connection failure to the backend.
- Invalid input parameters (e.g., non-alphabetical characters or insufficient
  letters).
- "No words found" or empty results from the solver.

## Technical Requirements

### React Frontend (Root)

- **Framework:** React 19 with Vite.
- **Styling:** Tailwind CSS and Framer Motion for animations.
- **Icons:** Lucide React.

### Flutter Frontend

- **Framework:** Flutter.
- **State Management:** Riverpod for handling form state and API data fetching.
- **Design:** Responsive and accessible Material Design.

### Node.js Backend (`server.ts`)

- **Framework:** Express with TypeScript.
- **Development:** tsx for running the server.

## Deliverables

1. Complete React source code in `src/` and Node.js backend in `server.ts`.
2. Complete Flutter source code.
3. A `docker-compose.yml` file to orchestrate the components for local
   development.

