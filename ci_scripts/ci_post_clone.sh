#!/bin/sh
set -e

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

SECRETS_XCCONFIG_PATH="XCConfig/Secrets.xcconfig"
if [ ! -f "$SECRETS_XCCONFIG_PATH" ]; then
  TEAM_ID_VALUE="${TEAM_ID:-8UV3Y69NB7}"
  POSTHOG_PROJECT_TOKEN_VALUE="${POSTHOG_PROJECT_TOKEN:?Set POSTHOG_PROJECT_TOKEN in Xcode Cloud}"
  : "${POSTHOG_CLI_API_KEY:?Set POSTHOG_CLI_API_KEY in Xcode Cloud}"
  : "${POSTHOG_CLI_PROJECT_ID:?Set POSTHOG_CLI_PROJECT_ID in Xcode Cloud}"
  if [ -f "XCConfig/Secrets.xcconfig.template" ]; then
    sed \
      -e "s/YOUR_TEAM_ID/$TEAM_ID_VALUE/g" \
      -e "s/YOUR_POSTHOG_PROJECT_TOKEN/$POSTHOG_PROJECT_TOKEN_VALUE/g" \
      "XCConfig/Secrets.xcconfig.template" > "$SECRETS_XCCONFIG_PATH"
  else
    printf 'DEVELOPMENT_TEAM = %s\nPOSTHOG_PROJECT_TOKEN = %s\n' \
      "$TEAM_ID_VALUE" \
      "$POSTHOG_PROJECT_TOKEN_VALUE" > "$SECRETS_XCCONFIG_PATH"
  fi
  echo "✅ Generated $SECRETS_XCCONFIG_PATH for Release archive"
fi

if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi
export PATH="$HOME/.local/bin:$PATH"

# Output the current PATH for debugging
echo "❗️Current PATH: $PATH"

echo "❗️mise version"
mise --version
echo "❗️mise install"
mise install # Installs the version from .mise.toml
eval "$(mise activate bash --shims)"

if [ ! -x "$HOME/.posthog/posthog-cli" ]; then
  curl --proto '=https' --tlsv1.2 -LsSf https://download.posthog.com/cli | sh
fi

echo "❗️mise doctor"
mise doctor # verify the output of mise is correct on CI
echo "❗️tuist install"
tuist install
echo "❗️tuist generate"
tuist generate # Generate the Xcode Project using Tuist
