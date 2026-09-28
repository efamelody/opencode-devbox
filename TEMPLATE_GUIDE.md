# Template Guide

How to create and use project scaffolding templates in the Devbox Operator.

## Overview

Templates live in `.devbox/templates/<tech-stack>/<template-name>/` and are used with:

```bash
./devbox init <tech-stack>/<template-name> <project-alias> [path]
```

## Template Structure

```
.devbox/templates/
├── node/
│   ├── nextjs/
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── next.config.js
│   │   ├── src/
│   │   │   └── app/
│   │   │       └── page.tsx
│   │   └── template.yaml
│   ├── express/
│   └── cli/
├── python/
│   ├── fastapi/
│   ├── cli/
│   └── ml/
└── java-gradle/
    └── spring-boot/
```

## Template Manifest (`template.yaml`)

Each template should include a `template.yaml`:

```yaml
name: "nextjs"
description: "Next.js 14 App Router with TypeScript & Tailwind"
tech_stack: "node"
base_template: null  # or "node/base" for inheritance
variables:
  - name: "project_name"
    description: "Project name (kebab-case, used for package name)"
    required: true
    default: "{{alias}}"
  - name: "description"
    description: "Project description"
    required: false
    default: "A Next.js application"
  - name: "author"
    description: "Author name"
    required: false
    default: ""
hooks:
  post_create: "scripts/post-create.sh"  # Optional script to run after creation
```

## Variable Substitution

Templates support `{{variable}}` substitution in:
- File contents
- File names
- Directory names

### Built-in Variables

| Variable | Description |
|----------|-------------|
| `{{alias}}` | Project alias from CLI |
| `{{path}}` | Target path |
| `{{date}}` | Current date (YYYY-MM-DD) |
| `{{year}}` | Current year |

### Custom Variables

Defined in `template.yaml` → `variables`. Prompted during `init` if not provided.

## Creating a Template

### 1. Create Directory Structure

```bash
mkdir -p .devbox/templates/node/my-template/src
```

### 2. Add Template Files

Use `{{variable}}` placeholders:

**package.json**
```json
{
  "name": "{{project_name}}",
  "version": "0.1.0",
  "description": "{{description}}",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "lint": "next lint",
    "test": "jest"
  }
}
```

**src/app/page.tsx**
```tsx
export default function Home() {
  return (
    <main>
      <h1>Welcome to {{project_name}}</h1>
      <p>{{description}}</p>
    </main>
  )
}
```

### 3. Create template.yaml

```yaml
name: "my-template"
description: "My custom Node.js template"
tech_stack: "node"
variables:
  - name: "project_name"
    description: "Package name (npm-compatible)"
    required: true
    default: "{{alias}}"
  - name: "description"
    description: "Project description"
    required: false
    default: "A Node.js project"
```

### 4. Test the Template

```bash
./devbox init node/my-template test-project ../test-project
```

## Template Inheritance

Use `base_template` to extend another template:

```yaml
# .devbox/templates/node/nextjs-auth/template.yaml
name: "nextjs-auth"
description: "Next.js with NextAuth.js pre-configured"
tech_stack: "node"
base_template: "node/nextjs"
variables:
  - name: "auth_provider"
    description: "Auth provider (github, google, credentials)"
    required: true
    default: "github"
```

The child template merges:
- Files from base (child overrides)
- Variables from base + child
- Hooks from base + child

## Post-Create Hooks

Run custom logic after template creation:

```yaml
# template.yaml
hooks:
  post_create: "scripts/post-create.sh"
```

**scripts/post-create.sh**
```bash
#!/usr/bin/env bash
# Receives: PROJECT_PATH, PROJECT_ALIAS, PROJECT_NAME, etc.

echo "🔧 Running post-create for $PROJECT_ALIAS"
cd "$PROJECT_PATH"

# Initialize git
git init
git add .
git commit -m "chore: initial commit from template"

# Install dependencies
npm ci

echo "✅ Post-create complete"
```

Make executable: `chmod +x scripts/post-create.sh`

## Template Variables Reference

### In template.yaml

```yaml
variables:
  - name: "variable_name"
    description: "Human-readable description"
    required: true|false
    default: "default value or {{other_var}}"
    pattern: "^[a-z-]+$"  # Optional regex validation
    choices: ["opt1", "opt2"]  # Optional enum
```

### In Template Files

```handlebars
{{variable_name}}
{{#if variable_name}}conditional{{/if}}
{{#each array_var}}{{this}}{{/each}}
```

## Publishing Templates

### Internal (Company) Templates

Add to `.devbox/plugins/company-internal/templates/`:

```
.devbox/plugins/company-internal/templates/
├── node/
│   └── internal-api/
└── python/
    └── internal-service/
```

Reference in plugin manifest:

```yaml
# plugin.yaml
templates:
  - "templates/node/internal-api"
  - "templates/python/internal-service"
```

Use with namespace:

```bash
./devbox init company-internal/node/internal-api my-service ../my-service
```

### Sharing Templates

1. Package as npm/PyPI package
2. Or use git submodules
3. Or vendor in `.devbox/templates/`

## Best Practices

### 1. Minimal Viable Template

Start with just the essentials:
- Package/dependency manifest
- Basic project structure
- One working example (hello world)
- README with next steps

### 2. Include Tooling Config

- Linter config (eslint, ruff, checkstyle)
- Type checker (tsconfig, mypy)
- Test config (jest, pytest, junit)
- CI/CD starter (GitHub Actions, GitLab CI)

### 3. Document Next Steps

Add a `NEXT_STEPS.md` or section in README:
```markdown
## Next Steps
1. `cd {{project_name}}`
2. `npm install` / `pip install -e .[dev]`
3. `npm run dev` / `python -m {{project_name}}`
4. Start coding!
```

### 4. Version Templates

```
.devbox/templates/
├── node/
│   ├── nextjs/
│   └── nextjs-v13/  # Legacy version
```

Update `template.yaml` version field.

## Troubleshooting

### "Template not found"
- Check path: `.devbox/templates/<stack>/<name>/`
- Verify `template.yaml` exists
- Check spelling (case-sensitive)

### Variable not substituted
- Ensure `{{var}}` syntax (double braces)
- Check variable defined in `template.yaml`
- Check `template.yaml` YAML syntax

### Post-create hook not running
- Verify `hooks.post_create` path in `template.yaml`
- Ensure script is executable (`chmod +x`)
- Check script shebang (`#!/usr/bin/env bash`)

### Base template not merging
- Verify `base_template` path correct
- Base must have `template.yaml`
- Child files override base files