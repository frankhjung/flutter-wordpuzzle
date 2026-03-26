SHELL := /usr/bin/env bash

FLUTTER_DEVICE ?= chrome

.DEFAULT_GOAL := default

.PHONY: help format lint build test ci clean run

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

build: ## Build Flutter web app
	@echo "Building Flutter web app..."
	@flutter build web

run: ## Launch the Flutter app locally (default device: chrome)
	@echo "Launching Flutter app on $(FLUTTER_DEVICE)..."
	@flutter run -d $(FLUTTER_DEVICE)

test: ## Run Flutter unit/widget tests
	@echo "Running Flutter tests..."
	@flutter test

ci: lint build test ## Run CI-style validation

clean: ## Clean Flutter build artifacts
	@echo "Cleaning Flutter build artifacts..."
	@flutter clean
