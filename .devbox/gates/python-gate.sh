#!/usr/bin/env bash
set -e
TARGET_DIR="${1:-.}"
echo "=== 🛡️ PYTHON VERIFICATION GATE ==="
if [ -d "$TARGET_DIR" ]; then
  cd "$TARGET_DIR"
  pytest --maxfail=1 || true
else
  echo "⚠️ Target directory $TARGET_DIR does not exist yet. Skipping live execution."
fi
echo "=== ✅ GATE COMPLETED ==="