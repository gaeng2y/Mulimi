
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

