#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

app="${1:-$PWD/build/屏幕圆角.app}"
mkdir -p "$app/Contents/MacOS"
cp Info.plist "$app/Contents/Info.plist"
xcrun --sdk macosx swiftc \
  -O -target arm64-apple-macos13.0 \
  -sdk "$(xcrun --sdk macosx --show-sdk-path)" \
  RoundedCorners.swift -o "$app/Contents/MacOS/RoundedCorners"
codesign --force --sign - "$app"
