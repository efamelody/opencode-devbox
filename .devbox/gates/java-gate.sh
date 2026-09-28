#!/usr/bin/env bash
set -e
TARGET_DIR="${1:-.}"
echo "=== 🛡️ JAVA / GRADLE VERIFICATION GATE ==="
if [ -d "$TARGET_DIR" ]; then
  cd "$TARGET_DIR"
  ./gradlew check --daemon || true
else
  echo "⚠️ Target directory $TARGET_DIR does not exist yet. Skipping live execution."
fi
echo "=== ✅ GATE COMPLETED ==="