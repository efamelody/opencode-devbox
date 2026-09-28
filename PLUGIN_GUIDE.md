# Plugin Guide

How to extend the Devbox Operator with custom hooks, skills, templates, and integrations.

## Overview

Plugins are self-contained extensions in `.devbox/plugins/<plugin-name>/` that add functionality without modifying core operator code.

## Plugin Structure

```
.devbox/plugins/
├── company-internal/
│   ├── plugin.yaml           # Plugin manifest (required)
│   ├── gate-hooks/           # Pre/post gate execution hooks
│   │   ├── pre-gate.sh
│   │   ├── post-gate.sh
│   │   ├── pre-task.sh
│   │   └── post-task.sh
│   ├── skill-extensions/     # Additional skill files
│   │   └── company-security-audit.md
│   └── templates/            # Project templates
│       ├── node/
│       │   └── internal-api/
│       └── python/
│           └── internal-service/
└── another-plugin/
    └── plugin.yaml
```

## Plugin Manifest (`plugin.yaml`)

```yaml
name: "company-internal"
version: "1.0.0"
description: "Internal company extensions for Devbox Operator"
author: "Platform Team"
hooks:
  pre_gate: "gate-hooks/pre-gate.sh"
  post_gate: "gate-hooks/post-gate.sh"
  pre_task: "gate-hooks/pre-task.sh"
  post_task: "gate-hooks/post-task.sh"
skills:
  - "skill-extensions/company-security-audit.md"
templates:
  - "templates/node/internal-api"
  - "templates/python/internal-service"
config:
  # Plugin-specific configuration
  vault_url: "https://vault.company.com"
  slack_webhook: "https://hooks.slack.com/..."
```

## Enabling Plugins

Add to `devbox-config.yaml`:

```yaml
plugins:
  - "company-internal"
  - "another-plugin"
```

Plugins load in order; later plugins can override earlier ones.

## Hook System

### Hook Types

| Hook | When It Runs | Use Cases |
|------|-------------|-----------|
| `pre_gate` | Before gate command | Dependency install, env validation, security scan |
| `post_gate` | After gate command | Notifications, badge updates, deployment triggers |
| `pre_task` | Before task execution | Branch creation, dependency install, context setup |
| `post_task` | After task execution | Auto-commit, PR creation, issue tracking |

### Hook Environment Variables

All hooks receive:

```bash
DEVBOX_ALIAS="my-project"
DEVBOX_PATH="/absolute/path/to/project"
DEVBOX_TYPE="node"
DEVBOX_GATE_CMD="./.devbox/gates/node-gate.sh /path"
DEVBOX_TASK_ID="task_20240115_143022"
DEVBOX_TASK_PROMPT="Add JWT authentication"
PLUGIN_CONFIG_VAULT_URL="https://vault.company.com"
```

### Hook Exit Codes

- `0` = Success, continue
- Non-zero = Failure, abort with error message

### Example: Pre-Gate Hook

```bash
#!/usr/bin/env bash
# .devbox/plugins/company-internal/gate-hooks/pre-gate.sh

set -e

echo "🔧 [company-internal/pre-gate] Validating ${DEVBOX_ALIAS}"

# Check required secrets
required_secrets=("DATABASE_URL" "JWT_SECRET" "API_KEY")
for secret in "${required_secrets[@]}"; do
    if [[ -z "${!secret}" ]]; then
        echo "❌ Missing required secret: ${secret}"
        exit 1
    fi
done

# Run company security scan
if command -v company-security-scan &> /dev/null; then
    company-security-scan "${DEVBOX_PATH}" || exit 1
fi

echo "✅ [company-internal/pre-gate] Validation passed"
exit 0
```

### Example: Post-Gate Hook

```bash
#!/usr/bin/env bash
# .devbox/plugins/company-internal/gate-hooks/post-gate.sh

set -e

GATE_EXIT_CODE=$1

echo "🔧 [company-internal/post-gate] Gate exited with ${GATE_EXIT_CODE}"

if [[ ${GATE_EXIT_CODE} -eq 0 ]]; then
    # Update deployment readiness
    curl -X POST "${PLUGIN_CONFIG_DEPLOY_API}/ready" \
        -d "project=${DEVBOX_ALIAS}&status=ready" \
        -H "Authorization: Bearer ${PLUGIN_CONFIG_DEPLOY_TOKEN}"
    
    # Notify team
    curl -X POST "${PLUGIN_CONFIG_SLACK_WEBHOOK}" \
        -d "{\"text\":\"✅ ${DEVBOX_ALIAS} gate passed\"}"
else
    # Create incident
    curl -X POST "${PLUGIN_CONFIG_INCIDENT_API}/create" \
        -d "project=${DEVBOX_ALIAS}&reason=gate_failed"
    
    # Notify team
    curl -X POST "${PLUGIN_CONFIG_SLACK_WEBHOOK}" \
        -d "{\"text\":\"❌ ${DEVBOX_ALIAS} gate failed\"}"
fi

exit 0
```

## Skill Extensions

### Adding Skills via Plugin

1. Create skill file: `.devbox/plugins/company-internal/skill-extensions/my-skill.md`
2. Reference in `plugin.yaml`:

```yaml
skills:
  - "skill-extensions/my-skill.md"
```

### Skill File Format

Same as core skills (see [SKILL_GUIDE.md](SKILL_GUIDE.md)):

```markdown
# Skill: Company API Standards

## When to Apply
When creating or modifying REST APIs in company projects.

## Rules
1. **Versioning**: All APIs must use URL versioning (`/api/v1/...`)
2. **Response Format**: Use standard envelope `{ data, meta, errors }`
3. **Error Codes**: Use company error code registry
4. **Pagination**: Cursor-based for lists > 50 items
5. **Rate Limits**: Document in OpenAPI spec

## Verification
- Run `company-api-linter` on OpenAPI spec
- Check response format in integration tests
```

## Templates via Plugin

### Adding Templates via Plugin

1. Create template in `.devbox/plugins/company-internal/templates/<stack>/<name>/`
2. Include `template.yaml` (see [TEMPLATE_GUIDE.md](TEMPLATE_GUIDE.md))
3. Reference in `plugin.yaml`:

```yaml
templates:
  - "templates/node/internal-api"
  - "templates/python/internal-service"
```

### Using Plugin Templates

```bash
./devbox init company-internal/node/internal-api my-service ../my-service
```

## Plugin Configuration

### In plugin.yaml

```yaml
config:
  vault_url: "https://vault.company.com"
  deploy_api: "https://deploy.company.com"
  slack_webhook: "https://hooks.slack.com/..."
```

### In devbox-config.yaml (per-project override)

```yaml
projects:
  my-service:
    path: "../my-service"
    plugin_config:
      company-internal:
        custom_setting: "value"
```

### Accessing Config in Hooks

Environment variables: `PLUGIN_CONFIG_<KEY>` (uppercase, underscores)

```bash
echo "Vault URL: ${PLUGIN_CONFIG_VAULT_URL}"
```

## Developing Plugins

### 1. Create Plugin Directory

```bash
mkdir -p .devbox/plugins/my-plugin/{gate-hooks,skill-extensions,templates}
```

### 2. Write plugin.yaml

```yaml
name: "my-plugin"
version: "0.1.0"
description: "My custom plugin"
hooks:
  pre_gate: "gate-hooks/pre-gate.sh"
skills:
  - "skill-extensions/my-skill.md"
```

### 3. Write Hooks

Make executable: `chmod +x gate-hooks/*.sh`

### 4. Test Locally

```bash
# Add to config
echo 'plugins: ["my-plugin"]' >> devbox-config.yaml

# Test hook manually
DEVBOX_ALIAS=test DEVBOX_PATH=../test DEVBOX_TYPE=node \
  .devbox/plugins/my-plugin/gate-hooks/pre-gate.sh
```

### 5. Version & Document

- Tag releases: `git tag plugin-my-plugin-v1.0.0`
- Update `CHANGELOG.md` in plugin dir
- Document in plugin's `README.md`

## Advanced: Plugin API (Python)

For complex logic, write Python hooks:

```
.devbox/plugins/my-plugin/
├── plugin.yaml
└── hooks.py
```

**plugin.yaml**
```yaml
name: "my-plugin"
python_hooks: "hooks.py"
```

**hooks.py**
```python
import os
import subprocess
from typing import Dict

def pre_gate(context: Dict[str, str]) -> int:
    """Return 0 for success, non-zero for failure."""
    alias = context["DEVBOX_ALIAS"]
    path = context["DEVBOX_PATH"]
    
    # Complex logic here
    result = subprocess.run(
        ["custom-tool", "check", path],
        capture_output=True
    )
    return result.returncode

def post_gate(context: Dict[str, str], exit_code: int) -> int:
    if exit_code == 0:
        # Success actions
        pass
    return 0
```

## Best Practices

### 1. Keep Plugins Focused

One plugin = one domain:
- `company-security` - Security hooks & skills
- `company-deploy` - Deployment hooks
- `company-api` - API standards & templates

### 2. Make Hooks Idempotent

Hooks may run multiple times. Safe to re-run.

### 3. Fail Fast, Log Clearly

```bash
echo "❌ [plugin/hook] Clear error message" >&2
exit 1
```

### 4. Use Configuration, Not Hardcoding

All paths, URLs, tokens in `config` section.

### 5. Test in Isolation

```bash
# Test hook without full operator
DEVBOX_ALIAS=test DEVBOX_PATH=/tmp/test \
  .devbox/plugins/my-plugin/gate-hooks/pre-gate.sh
```

## Troubleshooting

### Plugin not loading
- Check `plugins:` list in `devbox-config.yaml`
- Verify `plugin.yaml` exists and valid YAML
- Check plugin directory name matches `name` in manifest

### Hook not executing
- Verify hook path in `plugin.yaml` matches file
- Check file is executable (`chmod +x`)
- Check hook name matches (`pre_gate`, `post_gate`, etc.)

### Environment variables not set
- Only documented variables are passed
- Check spelling (uppercase, underscores)
- Plugin config vars prefixed with `PLUGIN_CONFIG_`

### Template not found
- Check `templates:` paths in `plugin.yaml`
- Verify template has `template.yaml`
- Use namespace: `company-internal/node/internal-api`