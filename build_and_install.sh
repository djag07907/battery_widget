#!/bin/bash

echo "🔋 Battery Widget for Grandma - Build Script"
echo "=============================================="

# Check if FVM is installed
if ! command -v fvm &> /dev/null; then
    echo "❌ FVM is not installed. Please install FVM first."
    exit 1
fi

# Check if Flutter 3.29.3 is available
if ! fvm list | grep -q "3.29.3"; then
    echo "❌ Flutter 3.29.3 is not installed. Please install it with: fvm install 3.29.3"
    exit 1
fi

# Set Flutter version
echo "🔧 Setting Flutter version to 3.29.3..."
fvm use 3.29.3

# Get dependencies
echo "📦 Getting dependencies..."
fvm flutter pub get

# Run analysis
echo "🔍 Running code analysis..."
fvm flutter analyze

if [ $? -ne 0 ]; then
    echo "❌ Code analysis failed. Please fix the issues before building."
    exit 1
fi

# Build release APK
echo "🏗️  Building release APK..."
fvm flutter build apk --release

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "📋 Next steps for your grandma's phone:"
    echo "1. Transfer app-release.apk to her phone"
    echo "2. Enable 'Install from Unknown Sources' in Settings"
    echo "3. Install the APK"
    echo "4. Long press on home screen → Widgets → Battery Widget"
    echo "5. For Redmi phones: Check Settings → Apps → Battery Widget permissions"
    echo ""
    echo "🎉 Happy battery monitoring!"
else
    echo "❌ Build failed. Please check the errors above."
    exit 1
fi