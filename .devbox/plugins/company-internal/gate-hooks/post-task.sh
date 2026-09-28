#!/usr/bin/env bash
# Post-task hook: runs after a task completes
# Environment: DEVBOX_ALIAS, DEVBOX_PATH, DEVBOX_TYPE, DEVBOX_TASK_ID, DEVBOX_TASK_PROMPT

set -e

TASK_EXIT_CODE=$1
echo "🔧 [post-task] Task ${DEVBOX_TASK_ID} completed for ${DEVBOX_ALIAS} with exit code ${TASK_EXIT_CODE}"

if [[ ${TASK_EXIT_CODE} -eq 0 ]]; then
    echo "✅ [post-task] Task succeeded"
    
    # Example: Auto-commit changes
    # git -C "${DEVBOX_PATH}" add -A
    # git -C "${DEVBOX_PATH}" commit -m "task(${DEVBOX_TASK_ID}): ${DEVBOX_TASK_PROMPT}"
    
    # Example: Push to remote
    # git -C "${DEVBOX_PATH}" push origin "task/${DEVBOX_TASK_ID}"
    
    # Example: Create PR
    # gh pr create --title "task(${DEVBOX_TASK_ID}): ${DEVBOX_TASK_PROMPT}" --body "Automated PR from Devbox Operator"
else
    echo "❌ [post-task] Task failed"
    
    # Example: Create issue for failed task
    # gh issue create --title "Task ${DEVBOX_TASK_ID} failed" --body "Task prompt: ${DEVBOX_TASK_PROMPT}"
fi

echo "✅ [post-task] Post-task actions completed"
exit 0