
# Makefile for Mulimi Project

# --- Variables ---
# Default target to run when no target is specified
.DEFAULT_GOAL := help

# --- Main Targets ---

## setup: Sets up the project for the first time. Requires TEAM_ID.
.PHONY: setup
setup:
	@if [ -z "$(TEAM_ID)" ]; then \
		echo "❌ Error: TEAM_ID is not set."; \
		echo "➡️  Usage: make setup TEAM_ID=A1B2C3D4E5"; \
		exit 1; \
	fi
	@echo "🔐 Creating Secrets.xcconfig with your Team ID..."
	@echo "DEVELOPMENT_TEAM = $(TEAM_ID)" > XCConfig/Secrets.xcconfig
	@echo "✅ Secrets.xcconfig created successfully."
	@make fetch
	@make generate
	@make hooks
	@echo "\n🚀 Project setup complete! Open Mulimi.xcworkspace to get started."

## fetch: Fetches Tuist dependencies.
.PHONY: install
fetch:
	@echo "📦 Fetching dependencies with Tuist..."
	@tuist install

## generate: Generates the Xcode project.
.PHONY: generate
generate:
	@echo "✨ Generating Xcode project..."
	@tuist generate

## hooks: Configures the repository git hooks path.
.PHONY: hooks
hooks:
	@echo "🪝 Configuring git hooks..."
	@git config core.hooksPath .githooks
	@chmod +x .githooks/pre-commit scripts/lint.sh scripts/lint-fix.sh scripts/check-architecture.sh
	@echo "✅ Git hooks are configured."

## lint: Runs SwiftLint with the shared project config.
.PHONY: lint
lint:
	@./scripts/lint.sh

## lint-fix: Auto-corrects fixable SwiftLint violations and re-runs lint.
.PHONY: lint-fix
lint-fix:
	@./scripts/lint-fix.sh

## arch-check: Runs architecture guardrail checks.
.PHONY: arch-check
arch-check:
	@./scripts/check-architecture.sh

## verify: Runs lint and architecture checks.
.PHONY: verify
verify:
	@make lint
	@make arch-check

## clean: Cleans all generated files by Tuist.
.PHONY: clean
clean:
	@echo "🧹 Cleaning up generated files..."
	@tuist clean
	@rm -rf .tuist-version
	@echo "✅ Clean complete."

## help: Shows this help message.
.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "}; /^##/ {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
