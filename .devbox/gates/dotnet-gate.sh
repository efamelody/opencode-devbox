#!/usr/bin/env bash
set -e
TARGET_DIR="${1:-.}"
echo "=== 🛡️ .NET VERIFICATION GATE ==="
if [ -d "$TARGET_DIR" ]; then
  cd "$TARGET_DIR"
  dotnet restore
  dotnet build --no-restore
  dotnet test --no-build
else
  echo "⚠️ Target directory $TARGET_DIR does not exist yet. Skipping live execution."
fi
echo "=== ✅ GATE COMPLETED ==="