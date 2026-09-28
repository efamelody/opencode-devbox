#!/usr/bin/env bash
set -e
TARGET_DIR="${1:-.}"
echo "=== 🛡️ NODE.JS VERIFICATION GATE ==="
if [ -d "$TARGET_DIR" ]; then
  cd "$TARGET_DIR"
  npm run lint --if-present
  npm test --if-present
  npm run build --if-present
else
  echo "⚠️ Target directory $TARGET_DIR does not exist yet. Skipping live execution."
fi
echo "=== ✅ GATE COMPLETED ==="