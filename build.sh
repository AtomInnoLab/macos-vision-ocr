#!/bin/bash

# 构建项目
swift build

# 获取当前架构
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    TARGET_ARCH="aarch64"
elif [ "$ARCH" = "x86_64" ]; then
    TARGET_ARCH="x86_64"
else
    TARGET_ARCH="$ARCH"
fi

# 重命名可执行文件
if [ -f ".build/debug/ocr" ]; then
    mv .build/debug/ocr ".build/debug/ocr-${TARGET_ARCH}-apple-darwin"
    echo "Generated: .build/debug/ocr-${TARGET_ARCH}-apple-darwin"
fi

# 同时为 release 版本构建
swift build -c release
if [ -f ".build/release/ocr" ]; then
    mv .build/release/ocr ".build/release/ocr-${TARGET_ARCH}-apple-darwin"
    echo "Generated: .build/release/ocr-${TARGET_ARCH}-apple-darwin"
fi 