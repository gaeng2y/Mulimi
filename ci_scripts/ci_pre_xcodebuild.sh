#!/bin/sh

# Xcode Cloud Pre-Xcodebuild Script
# This script runs before xcodebuild

set -e

echo "🔧 Pre-Xcodebuild Setup for Mulimi"

# Ensure we're in the correct directory
if [ ! -f "Mulimi.xcworkspace/contents.xcworkspacedata" ]; then
    echo "❌ Workspace file not found. CI setup may have failed."
    exit 1
fi

echo "✅ Workspace file found"

# Set environment variables for build
export TUIST_CONFIG_PATH="$(pwd)/Tuist"

# Verify required files exist
if [ ! -f "XCConfig/Secrets.xcconfig" ]; then
    echo "⚠️ Secrets.xcconfig not found, creating from template"
    if [ -f "XCConfig/Secrets.xcconfig.template" ]; then
        cp "XCConfig/Secrets.xcconfig.template" "XCConfig/Secrets.xcconfig"
        # Set a placeholder team ID for CI builds
        sed -i '' 's/YOUR_TEAM_ID/CI_BUILD_TEAM_ID/' "XCConfig/Secrets.xcconfig"
    fi
fi

echo "✅ Pre-Xcodebuild setup completed"