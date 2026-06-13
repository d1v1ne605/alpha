#!/bin/bash

# Build script for Development environment
echo "🚀 Building alpha App for Development environment..."

# Function to show usage
show_usage() {
    echo "Usage: $0 [platform]"
    echo ""
    echo "Platforms:"
    echo "  android    - Build Android APK only"
    echo "  ios        - Build iOS only (macOS only)"
    echo "  web        - Build Web only"
    echo "  all        - Build all platforms (default)"
    echo ""
    echo "Examples:"
    echo "  $0           # Build all platforms"
    echo "  $0 android   # Build Android only"
    echo "  $0 ios       # Build iOS only"
    echo "  $0 web       # Build Web only"
}

# Default platform
PLATFORM="all"

# Parse arguments
if [ $# -gt 0 ]; then
    case $1 in
        android|ios|web|all)
            PLATFORM=$1
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "❌ Invalid platform: $1"
            show_usage
            exit 1
            ;;
    esac
fi

echo "📱 Platform: $PLATFORM"

# Generate timestamp for file naming
generate_timestamp() {
    date +"%d%m%Y_%H:%M:%S"
}

TIMESTAMP=$(generate_timestamp)
echo "🕒 Build timestamp: $TIMESTAMP"

# Copy development environment file
if [ -f "lib/env/.env.development" ]; then
    cp lib/env/.env.development .env
    echo "✅ Development environment file copied"
else
    echo "⚠️  Development environment file not found, using default config"
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Generate localization files
echo "🌍 Generating localization files..."
flutter gen-l10n

# Run build runner to generate code
echo "🔨 Running build runner to generate code..."
flutter pub run build_runner build --delete-conflicting-outputs

# Build functions
build_android() {
    echo "📱 Building Android Debug APK..."
    flutter build apk --debug --target-platform android-arm64
    
    # Rename APK file with timestamp
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
    NEW_APK_PATH="build/app/outputs/flutter-apk/app_dev_${TIMESTAMP}.apk"
    
    if [ -f "$APK_PATH" ]; then
        mv "$APK_PATH" "$NEW_APK_PATH"
        echo "✅ Development APK: $NEW_APK_PATH"
    else
        echo "❌ APK file not found at $APK_PATH"
    fi
}

build_ios() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "🍎 Building iOS Debug..."
        
        # Clean iOS specific files
        echo "🧹 Cleaning iOS build artifacts..."
        if [ -d "build/ios" ]; then
            rm -rf build/ios
            echo "✅ Removed build/ios directory"
        fi
        
        # Navigate to iOS directory and install pods
        echo "🍎 Installing CocoaPods dependencies..."
        cd ios
        
        # Install pods
        pod install
        
        # Check if pod install was successful
        if [ $? -eq 0 ]; then
            echo "✅ CocoaPods installation completed"
        else
            echo "❌ CocoaPods installation failed"
            cd ..
            return 1
        fi
        
        # Go back to project root
        cd ..
        
        # Build iOS
        flutter build ios --debug --no-codesign
        echo "✅ iOS Debug build completed: build/ios/"
    else
        echo "❌ iOS build failed: Not on macOS"
        return 1
    fi
}

build_web() {
    echo "🌐 Building Web Debug..."
    flutter build web --debug
    echo "✅ Web Debug build completed: build/web/"
}

# Execute builds based on platform
case $PLATFORM in
    android)
        build_android
        ;;
    ios)
        build_ios
        ;;
    web)
        build_web
        ;;
    all)
        build_android
        build_ios
        build_web
        ;;
esac

echo ""
echo "🎉 Development build completed for $PLATFORM platform(s)!"
