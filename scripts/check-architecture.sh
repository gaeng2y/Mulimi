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

DOMAIN_IMPORTS="$(rg -n '^\s*import\s+(SwiftUI|UIKit|WidgetKit|Localization)\b' Project/Domain --glob '!**/Tests/**' --glob '!**/Derived/**' || true)"
report_violation "Domain must not import UI or localization frameworks." "$DOMAIN_IMPORTS"

VIEWMODEL_SYSTEM_APIS="$(rg -n '\b(UIApplication|WidgetCenter|NotificationCenter|UserDefaults|Bundle)\b' Project/Presentation/Sources/ViewModel --glob '!**/Tests/**' || true)"
report_violation "ViewModels must not directly access system side-effect APIs." "$VIEWMODEL_SYSTEM_APIS"

CROSS_VIEWMODEL_REFERENCES=""
for FILE in Project/Presentation/Sources/ViewModel/*ViewModel.swift; do
  [ -f "$FILE" ] || continue
  OWN_NAME="$(basename "$FILE" .swift)"

  for OTHER_FILE in Project/Presentation/Sources/ViewModel/*ViewModel.swift; do
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

HARD_CODED_GLASS_COUNT="$(rg -n '\b250(\.0)?\b' Project/Domain/Sources Project/Data/Sources Project/Presentation Project/Widget --glob '!**/Tests/**' --glob '!**/Derived/**' || true)"
report_violation "Use HydrationServing instead of hard-coded 250ml literals." "$HARD_CODED_GLASS_COUNT"

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "Architecture checks passed."
