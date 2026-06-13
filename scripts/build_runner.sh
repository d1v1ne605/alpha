#!/bin/bash

# Script to run build_runner only
echo "🔨 Running build_runner to generate code..."

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Please run this script from the project root directory."
    exit 1
fi

# Run build_runner
echo "📦 Generating code from annotations..."
flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -eq 0 ]; then
    echo "✅ Build runner completed successfully!"
    echo "📁 Generated files are ready for build"
else
    echo "❌ Build runner failed!"
    echo "💡 Try running: flutter clean && flutter pub get"
    exit 1
fi
