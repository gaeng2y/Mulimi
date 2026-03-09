#!/bin/sh
set -e

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

SECRETS_XCCONFIG_PATH="XCConfig/Secrets.xcconfig"
if [ ! -f "$SECRETS_XCCONFIG_PATH" ]; then
  TEAM_ID_VALUE="${TEAM_ID:-8UV3Y69NB7}"
  if [ -f "XCConfig/Secrets.xcconfig.template" ]; then
    sed "s/YOUR_TEAM_ID/$TEAM_ID_VALUE/g" "XCConfig/Secrets.xcconfig.template" > "$SECRETS_XCCONFIG_PATH"
  else
    echo "DEVELOPMENT_TEAM = $TEAM_ID_VALUE" > "$SECRETS_XCCONFIG_PATH"
  fi
  echo "✅ Generated $SECRETS_XCCONFIG_PATH with DEVELOPMENT_TEAM=$TEAM_ID_VALUE"
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

echo "❗️mise doctor"
mise doctor # verify the output of mise is correct on CI
echo "❗️tuist install"
tuist install
echo "❗️tuist generate"
tuist generate # Generate the Xcode Project using Tuist
