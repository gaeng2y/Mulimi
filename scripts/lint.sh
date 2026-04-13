#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v swiftlint >/dev/null 2>&1; then
  echo "error: SwiftLint is required. Install it with 'brew install swiftlint'." >&2
  exit 1
fi

if [ "${SCRIPT_INPUT_FILE_COUNT:-0}" -gt 0 ]; then
  swiftlint lint --no-cache --config .swiftlint.yml --use-script-input-files
else
  swiftlint lint --no-cache --config .swiftlint.yml
fi
