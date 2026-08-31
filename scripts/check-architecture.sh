#!/bin/sh
set -eu

ROOT_DIR="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v rg >/dev/null 2>&1; then
  echo "error: ripgrep is required. Install it with 'brew install ripgrep'." >&2
  exit 1
fi

FAILED=0

report_violation() {
  TITLE="$1"
  OUTPUT="$2"

  if [ -n "$OUTPUT" ]; then
    echo "error: $TITLE" >&2
    printf '%s\n' "$OUTPUT" >&2
    FAILED=1
  fi
}

DOMAIN_IMPORTS="$(
  rg -n '^\s*import\s+(SwiftUI|UIKit|WidgetKit|Localization)\b' \
    Project/Features \
    Project/Core \
    --glob '**/Domain/**' \
    --glob '!**/Tests/**' \
    --glob '!**/Derived/**' \
    || true
)"
report_violation "Domain must not import UI or localization frameworks." "$DOMAIN_IMPORTS"

VIEWMODEL_FILES="$(
  rg --files Project/Features Project/Core \
    | rg '/Presentation/.+ViewModel\.swift$' \
    || true
)"

VIEWMODEL_SYSTEM_APIS=""
if [ -n "$VIEWMODEL_FILES" ]; then
  VIEWMODEL_SYSTEM_APIS="$(printf '%s\n' "$VIEWMODEL_FILES" \
    | xargs rg -n '\b(UIApplication|WidgetCenter|NotificationCenter|UserDefaults|Bundle)\b' \
    || true)"
fi
report_violation "ViewModels must not directly access system side-effect APIs." "$VIEWMODEL_SYSTEM_APIS"

CROSS_VIEWMODEL_REFERENCES=""
for FILE in $VIEWMODEL_FILES; do
  [ -f "$FILE" ] || continue
  OWN_NAME="$(basename "$FILE" .swift)"

  for OTHER_FILE in $VIEWMODEL_FILES; do
    [ -f "$OTHER_FILE" ] || continue
    OTHER_NAME="$(basename "$OTHER_FILE" .swift)"

    if [ "$OWN_NAME" = "$OTHER_NAME" ]; then
      continue
    fi

    MATCHES="$(rg -n "\b${OTHER_NAME}\b" "$FILE" || true)"
    if [ -n "$MATCHES" ]; then
      CROSS_VIEWMODEL_REFERENCES="${CROSS_VIEWMODEL_REFERENCES}${MATCHES}
"
    fi
  done
done
report_violation "ViewModels must not directly reference other ViewModel types." "$CROSS_VIEWMODEL_REFERENCES"

FEATURE_REVERSE_IMPORTS="$(
  rg -n '^\s*import\s+\w+(Data|Presentation)\b' \
    Project/Features \
    Project/Core \
    --glob '**/Domain/**' \
    --glob '!**/Tests/**' \
    || true
  rg -n '^\s*import\s+\w+Data\b' \
    Project/Features \
    Project/Core \
    --glob '**/Presentation/**' \
    --glob '!**/Tests/**' \
    || true
)"
report_violation "Feature modules must keep Domain and Presentation dependency direction." "$FEATURE_REVERSE_IMPORTS"

HARD_CODED_GLASS_COUNT="$(rg -n '\b250(\.0)?\b' \
  Project/Features \
  Project/Core \
  Project/Widget \
  --glob '!**/Tests/**' \
  --glob '!**/Derived/**' \
  --glob '!**/HydrationServing.swift' \
  || true)"
report_violation "Use HydrationServing instead of hard-coded 250ml literals." "$HARD_CODED_GLASS_COUNT"

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "Architecture checks passed."
