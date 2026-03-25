SHELL := /usr/bin/env bash

FLUTTER_DEVICE ?= chrome

.DEFAULT_GOAL := default

.PHONY: help format lint build test ci \
	run run-flutter \
	format-web format-flutter \
	lint-web lint-flutter \
	build-web build-flutter \
	test-web test-flutter

help: ## Show available targets
	@awk 'match($$0, /^([a-zA-Z_-]+):.*##[[:space:]]*(.*)$$/, m) {printf "\033[1;36m%-16s\033[0m %s\n", m[1], m[2]}' $(MAKEFILE_LIST) | sort

default: format lint build test  ## Default target: format, lint, build, and test all code

format: format-web format-flutter ## Format all code

format-web: ## Format web files (if Prettier is available)
	@if npx --no-install prettier --version >/dev/null 2>&1; then \
		echo "Formatting web files with Prettier..."; \
		npx --no-install prettier --write "src/**/*.{ts,tsx,css}" "server.ts" "vite.config.ts" "index.html"; \
	else \
		echo "Skipping web formatting: Prettier is not configured."; \
	fi

format-flutter: ## Format Flutter files
	@echo "Formatting Flutter files..."
	@cd flutter_app && dart format lib test

lint: lint-web lint-flutter ## Lint and static-check all code

lint-web: ## Type-check web code
	@echo "Linting web code..."
	@npm run lint

lint-flutter: ## Analyze Flutter code
	@echo "Analyzing Flutter code..."
	@cd flutter_app && flutter analyze

build: build-web build-flutter ## Build all project artifacts

build-web: ## Build web app bundle
	@echo "Building web app..."
	@npm run build

build-flutter: ## Build Flutter web app
	@echo "Building Flutter web app..."
	@cd flutter_app && flutter build web

run: ## Start the local web server
	@echo "Starting web server at http://localhost:3000..."
	@npm run dev

run-flutter: ## Launch the Flutter app locally (default device: chrome)
	@echo "Launching Flutter app on $(FLUTTER_DEVICE)..."
	@cd flutter_app && flutter run -d $(FLUTTER_DEVICE)

test: test-web test-flutter ## Run unit tests

test-web: ## Run web unit tests when configured
	@node -e 'const p=require("./package.json"); process.exit(p.scripts && p.scripts.test ? 0 : 1)' \
		&& (echo "Running web tests..." && npm test) \
		|| echo "Skipping web tests: no npm test script configured."

test-flutter: ## Run Flutter unit/widget tests
	@echo "Running Flutter tests..."
	@cd flutter_app && flutter test

ci: lint build test ## Run CI-style validation