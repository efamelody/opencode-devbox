#!/usr/bin/env bash
# Pre-gate hook: runs before the verification gate
# Environment: DEVBOX_ALIAS, DEVBOX_PATH, DEVBOX_TYPE, DEVBOX_GATE_CMD

set -e

echo "🔧 [pre-gate] Running pre-gate checks for ${DEVBOX_ALIAS} (${DEVBOX_TYPE})"

# Example: Ensure required environment variables are set
required_vars=("DATABASE_URL" "REDIS_URL")
for var in "${required_vars[@]}"; do
    if [[ -z "${!var}" ]]; then
        echo "⚠️  [pre-gate] Warning: ${var} is not set"
    fi
done

# Example: Run security audit before gate
if command -v npm &> /dev/null && [[ -f "${DEVBOX_PATH}/package.json" ]]; then
    echo "🔧 [pre-gate] Running npm audit..."
    (cd "${DEVBOX_PATH}" && npm audit --audit-level=high || true)
fi

# Example: Check for uncommitted changes
if git -C "${DEVBOX_PATH}" status --porcelain | grep -q .; then
    echo "⚠️  [pre-gate] Warning: Uncommitted changes detected in ${DEVBOX_PATH}"
fi

echo "✅ [pre-gate] Pre-gate checks completed"
exit 0