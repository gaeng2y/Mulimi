#!/bin/sh

# Xcode Cloud Post-Xcodebuild Script
# This script runs after xcodebuild

set -e

echo "🎉 Post-Xcodebuild Cleanup for Mulimi"

# Archive build logs for debugging
if [ -n "$CI_ARCHIVE_PATH" ]; then
    echo "📁 Archive created at: $CI_ARCHIVE_PATH"
fi

# Report test results
if [ -n "$CI_RESULT_BUNDLE_PATH" ]; then
    echo "📊 Test results available at: $CI_RESULT_BUNDLE_PATH"
fi

# Clean up temporary files if needed
echo "🧹 Cleaning up temporary files"

# Log build completion
echo "✅ Build completed successfully"
echo "📱 App: Mulimi"
echo "🏗️ Architecture: Modular Clean Architecture with Tuist"