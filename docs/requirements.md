# Requirements

## Personas

You are an expert Flutter developer and DevOps engineer. Implement the following
specification. Provide complete, runnable code blocks for all deliverables.

## Overview

I want to create a web UI to solve word puzzles. I have an existing Clojure
repository, <https://github.com/frankhjung/clojure-wordpuzzle> with two
pipelines:

- to build and test the core logic of the word puzzle solver,
  <https://raw.githubusercontent.com/frankhjung/clojure-wordpuzzle/refs/heads/master/.github/workflows/ci.yml>
- to run the wordpuzzle solver as a web server,
  <https://raw.githubusercontent.com/frankhjung/clojure-wordpuzzle/refs/heads/master/.github/workflows/run-wordpuzzle.yml>

## Command line Interface (CLI) Contract

### Inputs

The inputs to the word puzzle solver are:

- `-d`, `--dictionary STRING` resources/dictionary Alternate word dictionary
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

The web UI interacts with the Clojure backend via a RESTful HTTP API.

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

Create a web UI for the word puzzle solver that allows users to input their
puzzle configurations.

- **Layout:** A clean, central input form utilizing standard text fields and
  toggles, styled with Material Design principles.
- **Inputs:** Form fields must map directly to the CLI backend inputs (`size`,
  `letters`, `repeats`, and optional `dictionary`).
- **Validation:** Prevent layout/submission errors if the required 7+ lowercase
  letters are not provided. (The mandatory letters must be in the first position
  of `letters`.)
- **Results Display:** Display the returned words in an organized manner (e.g.,
  a scrollable list grouped by word length).
- **Filtering:** Allow users to filter the generated results based on criteria,
  such as word length or specific included letters.

## Error Handling

The UI must handle and display specific, clear error messages to the user for
the following scenarios:

- Network or connection failure to the backend.
- Invalid input parameters (e.g., non-alphabetical characters or insufficient
  letters).
- "No words found" or empty results from the solver.

## Technical Requirements

- **Framework:** Ensure that the web UI is built using Flutter.
- **State Management:** Use Riverpod for state management to handle form state
  and API data fetching.
- **Design:** The UI should be designed to be responsive and accessible,
  ensuring that it works well on a variety of devices and screen sizes.

## Deliverables

1. Complete Flutter source code (e.g., `main.dart`, UI widgets, API service
   classes).
2. A `docker-compose.yml` file to orchestrate and run both the Flutter web app
   and the Clojure backend together for easy local development.
