#!/usr/bin/env bash
# Post-gate hook: runs after the verification gate
# Environment: DEVBOX_ALIAS, DEVBOX_PATH, DEVBOX_TYPE, DEVBOX_GATE_CMD

set -e

GATE_EXIT_CODE=$1
echo "🔧 [post-gate] Gate completed for ${DEVBOX_ALIAS} with exit code ${GATE_EXIT_CODE}"

if [[ ${GATE_EXIT_CODE} -eq 0 ]]; then
    echo "✅ [post-gate] Gate passed - running post-success actions"
    
    # Example: Notify deployment system
    # curl -X POST "https://deploy.company.com/api/notify" \
    #   -d "project=${DEVBOX_ALIAS}&status=gate_passed"
    
    # Example: Update badge in README
    # sed -i 's/!\[build\].*/![build](https:\/\/img.shields.io\/badge\/build-passing-brightgreen)/' "${DEVBOX_PATH}/README.md"
else
    echo "❌ [post-gate] Gate failed - running post-failure actions"
    
    # Example: Create incident ticket
    # curl -X POST "https://incidents.company.com/api/create" \
    #   -d "project=${DEVBOX_ALIAS}&reason=gate_failed"
fi

echo "✅ [post-gate] Post-gate actions completed"
exit 0