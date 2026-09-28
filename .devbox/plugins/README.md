# Devbox Operator Plugin System

## Overview

Plugins extend the Devbox Operator with company-specific tooling, custom gates, skills, and templates without modifying the core operator code.

## Plugin Structure

```
.devbox/plugins/
├── company-internal/           # Your company's plugins
│   ├── plugin.yaml            # Plugin manifest
│   ├── gate-hooks/            # Pre/post gate execution hooks
│   ├── skill-extensions/      # Additional skill files
│   └── templates/             # Project templates
└── README.md
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
```

## Hook Scripts

Hook scripts receive environment variables:
- `DEVBOX_ALIAS` - Project alias
- `DEVBOX_PATH` - Absolute path to project
- `DEVBOX_TYPE` - Tech stack type
- `DEVBOX_GATE_CMD` - Gate command being executed
- `DEVBOX_TASK_ID` - Task ID (for task hooks)
- `DEVBOX_TASK_PROMPT` - Task prompt (for task hooks)

Exit code 0 = continue, non-zero = abort with error.

## Installing Plugins

1. Place plugin directory in `.devbox/plugins/`
2. Add to `devbox-config.yaml`:

```yaml
plugins:
  - "company-internal"
```

## Creating Custom Templates

1. Create template in `.devbox/plugins/company-internal/templates/<name>/`
2. Include `template.yaml` manifest:

```yaml
name: "internal-api"
description: "Internal REST API with company standards"
tech_stack: "node"
base_template: "node/express"
variables:
  - name: "service_name"
    description: "Service name (kebab-case)"
    required: true
  - name: "team"
    description: "Owning team"
    required: true
```

3. Use with: `./devbox init company-internal/internal-api my-service ../my-service`

## Best Practices

- Keep plugins version-controlled with your operator fork
- Test hooks in isolation before enabling
- Document all custom skills and templates
- Use semantic versioning for plugins