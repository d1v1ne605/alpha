#!/bin/bash

# Build script for all environments
echo "🚀 Building alpha App for all environments..."

# Function to generate timestamp
generate_timestamp() {
    date +"%d%m%Y_%H:%M:%S"
}

# Function to build for specific environment
build_environment() {
    local env=$1
    local env_file="lib/env/.env.$env"
    
    echo "📦 Building for $env environment..."
    
    # Generate timestamp for this build
    local timestamp=$(generate_timestamp)
    echo "🕒 Build timestamp: $timestamp"
    
    # Copy environment file
    if [ -f "$env_file" ]; then
        cp "$env_file" .env
        echo "✅ $env environment file copied"
    else
        echo "⚠️  $env environment file not found, using default config"
    fi
    
    # Clean and build
    flutter clean
    flutter pub get
    
    # Run build runner to generate code
    echo "🔨 Running build runner to generate code..."
    flutter pub run build_runner build --delete-conflicting-outputs
    
    # Build APK
    if [ "$env" = "development" ]; then
        echo "📱 Building Android Debug APK..."
        flutter build apk --debug --target-platform android-arm64
        
        # Rename development APK with timestamp
        APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
        NEW_APK_PATH="build/app/outputs/flutter-apk/app_dev_${timestamp}.apk"
        if [ -f "$APK_PATH" ]; then
            mv "$APK_PATH" "$NEW_APK_PATH"
            echo "✅ Development APK: $NEW_APK_PATH"
        else
            echo "❌ APK file not found at $APK_PATH"
        fi
        
        # Build iOS Debug (if on macOS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "🍎 Building iOS Debug..."
            flutter build ios --debug --no-codesign
            echo "✅ iOS Debug build completed"
        else
            echo "⚠️  iOS build skipped (not on macOS)"
        fi
        
        # Build Web Debug
        echo "🌐 Building Web Debug..."
        flutter build web --debug
        echo "✅ Web Debug build completed: build/web/"
        
    else
        echo "📱 Building Android Release APK..."
        flutter build apk --release --target-platform android-arm64
        
        # Rename production APK with timestamp
        APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
        NEW_APK_PATH="build/app/outputs/flutter-apk/app_production_${timestamp}.apk"
        if [ -f "$APK_PATH" ]; then
            mv "$APK_PATH" "$NEW_APK_PATH"
            echo "✅ Production APK: $NEW_APK_PATH"
        else
            echo "❌ APK file not found at $APK_PATH"
        fi
        
        # Build iOS Release (if on macOS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "🍎 Building iOS Release..."
            flutter build ios --release --no-codesign
            echo "✅ iOS Release build completed"
        else
            echo "⚠️  iOS build skipped (not on macOS)"
        fi
        
        # Build Web Release
        echo "🌐 Building Web Release..."
        flutter build web --release
        echo "✅ Web Release build completed: build/web/"
    fi
    
    echo "✅ $env build completed!"
    echo ""
}

# Build for development
build_environment "development"

# Build for production
build_environment "production"

echo "🎉 All builds completed!"
