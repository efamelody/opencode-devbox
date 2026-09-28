#!/usr/bin/env bash
# Pre-task hook: runs before a task is dispatched
# Environment: DEVBOX_ALIAS, DEVBOX_PATH, DEVBOX_TYPE, DEVBOX_TASK_ID, DEVBOX_TASK_PROMPT

set -e

echo "🔧 [pre-task] Preparing task ${DEVBOX_TASK_ID} for ${DEVBOX_ALIAS}"
echo "   Prompt: ${DEVBOX_TASK_PROMPT}"

# Example: Ensure dependencies are installed
case "${DEVBOX_TYPE}" in
    node)
        if [[ -f "${DEVBOX_PATH}/package.json" && ! -d "${DEVBOX_PATH}/node_modules" ]]; then
            echo "🔧 [pre-task] Installing npm dependencies..."
            (cd "${DEVBOX_PATH}" && npm ci)
        fi
        ;;
    python)
        if [[ -f "${DEVBOX_PATH}/pyproject.toml" && ! -d "${DEVBOX_PATH}/.venv" ]]; then
            echo "🔧 [pre-task] Creating Python virtual environment..."
            (cd "${DEVBOX_PATH}" && python -m venv .venv && .venv/bin/pip install -e ".[dev]")
        fi
        ;;
esac

# Example: Checkout a task branch
# git -C "${DEVBOX_PATH}" checkout -b "task/${DEVBOX_TASK_ID}" || true

echo "✅ [pre-task] Task preparation completed"
exit 0