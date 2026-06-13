#!/bin/bash

# Advanced build script with environment-specific naming
echo "🚀 alpha App Advanced Build Script"

# Function to show usage
show_usage() {
    echo "Usage: $0 [environment] [options]"
    echo ""
    echo "Environments:"
    echo "  dev, development    - Build for development"
    echo "  prod, production    - Build for production"
    echo ""
    echo "Options:"
    echo "  --apk              - Build APK only (default)"
    echo "  --ios              - Build iOS only (macOS only)"
    echo "  --web              - Build Web only"
    echo "  --all              - Build all platforms"
    echo "  --clean            - Clean before build"
    echo ""
    echo "Examples:"
    echo "  $0 dev --apk        # Build development APK"
    echo "  $0 prod --all       # Build production for all platforms"
    echo "  $0 dev --clean      # Clean and build development"
}

# Default values
ENVIRONMENT=""
PLATFORM="apk"
CLEAN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        dev|development)
            ENVIRONMENT="development"
            shift
            ;;
        prod|production)
            ENVIRONMENT="production"
            shift
            ;;
        --apk)
            PLATFORM="apk"
            shift
            ;;
        --ios)
            PLATFORM="ios"
            shift
            ;;
        --web)
            PLATFORM="web"
            shift
            ;;
        --all)
            PLATFORM="all"
            shift
            ;;
        --clean)
            CLEAN=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "❌ Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Check if environment is specified
if [ -z "$ENVIRONMENT" ]; then
    echo "❌ Environment is required!"
    show_usage
    exit 1
fi

echo "🔧 Environment: $ENVIRONMENT"
echo "📱 Platform: $PLATFORM"
echo "🧹 Clean: $CLEAN"
echo ""

# Setup environment
ENV_FILE="lib/env/.env.$ENVIRONMENT"
if [ -f "$ENV_FILE" ]; then
    cp "$ENV_FILE" .env
    echo "✅ Environment file copied: $ENV_FILE"
else
    echo "❌ Environment file not found: $ENV_FILE"
    exit 1
fi

# Clean if requested
if [ "$CLEAN" = true ]; then
    echo "🧹 Cleaning previous builds..."
    flutter clean
fi

flutter pub get

# Generate localization files
echo "🌍 Generating localization files..."
flutter gen-l10n

# Run build runner to generate code
echo "🔨 Running build runner to generate code..."
flutter pub run build_runner build --delete-conflicting-outputs

# Generate timestamp for file naming
generate_timestamp() {
    date +"%d%m%Y_%H:%M:%S"
}

TIMESTAMP=$(generate_timestamp)
echo "🕒 Build timestamp: $TIMESTAMP"

# Build functions
build_apk() {
    local env=$1
    echo "📱 Building Android APK for $env..."
    
    if [ "$env" = "development" ]; then
        flutter build apk --debug --target-platform android-arm64
        APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
        NEW_APK_PATH="build/app/outputs/flutter-apk/app_dev_${TIMESTAMP}.apk"
    else
        flutter build apk --release --target-platform android-arm64
        APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
        NEW_APK_PATH="build/app/outputs/flutter-apk/app_production_${TIMESTAMP}.apk"
    fi
    
    if [ -f "$APK_PATH" ]; then
        mv "$APK_PATH" "$NEW_APK_PATH"
        echo "✅ APK built: $NEW_APK_PATH"
    else
        echo "❌ APK build failed"
        return 1
    fi
}

build_ios() {
    local env=$1
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo "⚠️  iOS build only available on macOS"
        return 0
    fi
    
    echo "🍎 Building iOS for $env..."
    
    if [ "$env" = "development" ]; then
        flutter build ios --debug --no-codesign
        echo "✅ iOS Debug build completed"
    else
        flutter build ios --release --no-codesign
        echo "✅ iOS Release build completed"
    fi
}

build_web() {
    local env=$1
    echo "🌐 Building Web for $env..."
    
    if [ "$env" = "development" ]; then
        flutter build web --debug
    else
        flutter build web --release
    fi
    
    echo "✅ Web build completed: build/web/"
}

# Execute builds based on platform
case $PLATFORM in
    apk)
        build_apk "$ENVIRONMENT"
        ;;
    ios)
        build_ios "$ENVIRONMENT"
        ;;
    web)
        build_web "$ENVIRONMENT"
        ;;
    all)
        build_apk "$ENVIRONMENT"
        build_ios "$ENVIRONMENT"
        build_web "$ENVIRONMENT"
        ;;
esac

echo ""
echo "🎉 Build completed for $ENVIRONMENT environment!"
