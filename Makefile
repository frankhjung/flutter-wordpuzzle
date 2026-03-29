SHELL := /usr/bin/env bash

FLUTTER_DEVICE ?= chrome
WEB_BASE_HREF ?= /flutter-wordpuzzle/

.DEFAULT_GOAL := default

.PHONY: help format lint build test ci clean run deps-upgrade-safe build-web

help: ## Show available targets
	@echo "Prerequisites:"
	@echo "  - Flutter SDK (stable channel)"
	@echo "  - GNU Make"
	@echo "  - (Optional) Docker and Docker Compose"
	@echo ""
	@echo "Install dependencies:"
	@echo "  flutter pub get"
	@echo ""
	@echo "Available targets:"
	@awk 'match($$0, /^([a-zA-Z_-]+):.*##[[:space:]]*(.*)$$/, m) {printf "  \033[1;36m%-16s\033[0m %s\n", m[1], m[2]}' $(MAKEFILE_LIST) | sort

default: format lint build test  ## Default target: format, lint, build, and test all code

format: ## Format Flutter files
	@echo "Formatting Flutter files..."
	@dart format .

lint: ## Analyze Flutter code
	@echo "Analyzing Flutter code..."
	@flutter analyze

build: ## Build Flutter web app (JavaScript)
	@echo "Building Flutter web app (JavaScript)..."
	@flutter build web --base-href $(WEB_BASE_HREF) --no-wasm-dry-run

run: ## Launch the Flutter app locally (default device: chrome)
	@echo "Launching Flutter app on $(FLUTTER_DEVICE)..."
	@flutter run -d $(FLUTTER_DEVICE)

test: ## Run Flutter unit/widget tests
	@echo "Running Flutter tests..."
	@flutter test

deps-upgrade-safe: ## Check outdated deps and apply SDK-compatible upgrades
	@echo "Checking outdated dependencies (before upgrade)..."
	@flutter pub outdated
	@echo "Applying dependency upgrades compatible with current SDK/constraints..."
	@flutter pub upgrade
	@echo "Checking outdated dependencies (after upgrade)..."
	@flutter pub outdated

ci: lint build test ## Run CI-style validation

clean: ## Clean Flutter build artifacts
	@echo "Cleaning Flutter build artifacts..."
	@flutter clean
