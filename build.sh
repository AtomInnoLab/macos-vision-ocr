#!/bin/bash

# Default architecture
DEFAULT_ARCH=$(uname -m)
TARGET_ARCH=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --arch)
            TARGET_ARCH="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [--arch <architecture>]"
            echo ""
            echo "Options:"
            echo "  --arch <architecture>  Target architecture (aarch64, x86_64, or auto)"
            echo "  --help, -h             Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                     Build for current architecture ($DEFAULT_ARCH)"
            echo "  $0 --arch aarch64      Build for Apple Silicon"
            echo "  $0 --arch x86_64       Build for Intel"
            echo "  $0 --arch auto         Build for current architecture (same as default)"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Determine target architecture
if [ -z "$TARGET_ARCH" ] || [ "$TARGET_ARCH" = "auto" ]; then
    # Use current system architecture
    if [ "$DEFAULT_ARCH" = "arm64" ]; then
        TARGET_ARCH="aarch64"
    elif [ "$DEFAULT_ARCH" = "x86_64" ]; then
        TARGET_ARCH="x86_64"
    else
        TARGET_ARCH="$DEFAULT_ARCH"
    fi
fi

# Validate architecture argument
if [ "$TARGET_ARCH" != "aarch64" ] && [ "$TARGET_ARCH" != "x86_64" ]; then
    echo "Error: Unsupported architecture '$TARGET_ARCH'"
    echo "Supported architectures: aarch64, x86_64"
    exit 1
fi

echo "Building for architecture: $TARGET_ARCH"

# Set Swift architecture argument
if [ "$TARGET_ARCH" = "aarch64" ]; then
    SWIFT_ARCH="arm64"
elif [ "$TARGET_ARCH" = "x86_64" ]; then
    SWIFT_ARCH="x86_64"
fi

# Build project
echo "Building debug version..."
swift build --arch $SWIFT_ARCH
echo "Building release version..."
swift build -c release --arch $SWIFT_ARCH

# Create unified output directories
mkdir -p .build/debug .build/release

# Find and copy the generated executables
ARCH_DIR="${SWIFT_ARCH}-apple-macosx"

# Copy debug version
if [ -f ".build/${ARCH_DIR}/debug/ocr" ]; then
    cp ".build/${ARCH_DIR}/debug/ocr" ".build/debug/ocr-${TARGET_ARCH}-apple-darwin"
    echo "Generated: .build/debug/ocr-${TARGET_ARCH}-apple-darwin"
fi

# Copy release version
if [ -f ".build/${ARCH_DIR}/release/ocr" ]; then
    cp ".build/${ARCH_DIR}/release/ocr" ".build/release/ocr-${TARGET_ARCH}-apple-darwin"
    echo "Generated: .build/release/ocr-${TARGET_ARCH}-apple-darwin"
fi

echo "Build complete!" 