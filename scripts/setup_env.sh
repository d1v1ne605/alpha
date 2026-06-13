#!/bin/bash

# Script to setup environment configuration
echo "🔧 Setting up alpha App environment configuration..."

# Function to create .env file
create_env_file() {
    local env_type=$1
    local source_file="lib/env/.env.$env_type"
    local target_file=".env"
    
    if [ -f "$source_file" ]; then
        cp "$source_file" "$target_file"
        echo "✅ Created .env file for $env_type environment"
        echo "📄 Source: $source_file"
        echo "📄 Target: $target_file"
    else
        echo "❌ Source file not found: $source_file"
        return 1
    fi
}

# Check if environment type is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [development|production]"
    echo ""
    echo "Examples:"
    echo "  $0 development   # Setup development environment"
    echo "  $0 production    # Setup production environment"
    exit 1
fi

ENV_TYPE=$1

case $ENV_TYPE in
    "development"|"dev")
        create_env_file "development"
        ;;
    "production"|"prod")
        create_env_file "production"
        ;;
    *)
        echo "❌ Invalid environment type: $ENV_TYPE"
        echo "Valid options: development, production"
        exit 1
        ;;
esac

echo ""
echo "🎉 Environment setup completed!"
echo "📋 Current configuration:"
echo "   BASE_URL: $(grep BASE_URL .env | cut -d'=' -f2)"
echo "   SOCKET_URL_PRIVATE: $(grep SOCKET_URL_PRIVATE .env | cut -d'=' -f2)"
echo "   SOCKET_URL_PUBLIC: $(grep SOCKET_URL_PUBLIC .env | cut -d'=' -f2)"
echo ""
echo "🚀 You can now build the app with:"
echo "   flutter build apk --release"
