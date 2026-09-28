# Tech Stack Guide

How to add, customize, and manage tech stacks in the Devbox Operator.

## Overview

Tech stacks are defined in `devbox-config.yaml` under the `tech_stacks` key. Each stack defines:

```yaml
tech_stacks:
  my-stack:
    detection:
      files: ["file1", "file2"]          # Files that indicate this stack
    gate_template: ".devbox/gates/my-gate.sh {path}"
    default_skills: ["skill1", "skill2"]  # Skills applied by default
    env_vars: ["VAR1", "VAR2"]            # Expected environment variables
    description: "Human-readable description"
```

## Adding a New Tech Stack

### 1. Define Detection Files

Choose files that uniquely identify your stack:

| Stack | Detection Files |
|-------|----------------|
| Node.js | `package.json`, `pnpm-lock.yaml`, `yarn.lock` |
| Python | `pyproject.toml`, `requirements.txt`, `setup.py` |
| Java (Gradle) | `build.gradle`, `build.gradle.kts`, `settings.gradle` |
| Go | `go.mod`, `go.sum` |
| Rust | `Cargo.toml`, `Cargo.lock` |
| .NET | `*.csproj`, `*.sln`, `global.json` |

**Tip**: Use multiple patterns for robustness. The first match wins (order matters).

### 2. Create a Gate Script

Create `.devbox/gates/my-stack-gate.sh`:

```bash
#!/usr/bin/env bash
set -e
TARGET_DIR="${1:-.}"
echo "=== 🛡️ MY STACK VERIFICATION GATE ==="
if [ -d "$TARGET_DIR" ]; then
  cd "$TARGET_DIR"
  # Your verification commands here
  # lint
  # test
  # build
else
  echo "⚠️ Target directory $TARGET_DIR does not exist yet. Skipping live execution."
fi
echo "=== ✅ GATE COMPLETED ==="
```

Make it executable: `chmod +x .devbox/gates/my-stack-gate.sh`

### 3. Register in Config

Add to `devbox-config.yaml`:

```yaml
tech_stacks:
  my-stack:
    detection:
      files: ["my-config.yaml", "my-lock.file"]
    gate_template: ".devbox/gates/my-stack-gate.sh {path}"
    default_skills: ["security-audit"]
    env_vars: ["MY_STACK_ENV"]
    description: "My awesome stack"
```

### 4. Test Detection

```bash
./devbox detect /path/to/project
# Should output: ✅ Detected: my-stack
```

## Customizing Existing Stacks

### Override Gate Template

In `devbox-config.yaml`, modify the gate_template:

```yaml
tech_stacks:
  node:
    gate_template: ".devbox/gates/node-gate.sh {path} && custom-check {path}"
```

### Add Default Skills

```yaml
tech_stacks:
  python:
    default_skills: ["security-audit", "db-migration", "api-design"]
```

### Add Environment Variables

```yaml
tech_stacks:
  java-gradle:
    env_vars: ["JAVA_HOME", "GRADLE_OPTS", "MAVEN_OPTS"]
```

## Per-Project Overrides

Projects can override stack defaults in `devbox-config.yaml`:

```yaml
projects:
  my-service:
    path: "../my-service"
    type: "node"           # Explicit type (optional, auto-detected)
    skills: ["security-audit", "custom-skill"]  # Extends/replaces defaults
    env:
      CUSTOM_VAR: "value"
    gate: "custom-gate-command"  # Full override (optional)
```

## Detection Priority

Detection runs in the order tech stacks are defined in `tech_stacks`. First match wins.

To prioritize a specific stack, move it earlier in the config, or use more specific detection files.

## Advanced: Multiple Configurations per Stack

For stacks with variants (e.g., `node/nextjs`, `node/express`), use templates rather than separate tech stacks. The base `node` stack handles detection and gates; templates handle scaffolding.

## Best Practices

1. **Keep detection files minimal** - 2-3 unique files max
2. **Gate scripts should be fast** - Fail fast, cache when possible
3. **Default skills should be universal** - Security audit applies to all
4. **Document env vars** - List required vs optional
5. **Test detection** - Run `./devbox detect` on real projects

## Example: Adding a PHP Stack

```yaml
tech_stacks:
  php:
    detection:
      files: ["composer.json", "composer.lock"]
    gate_template: ".devbox/gates/php-gate.sh {path}"
    default_skills: ["security-audit"]
    env_vars: ["COMPOSER_HOME", "PHP_ENV"]
    description: "PHP projects (Laravel, Symfony, CLI)"
```

Create `.devbox/gates/php-gate.sh`:

```bash
#!/usr/bin/env bash
set -e
TARGET_DIR="${1:-.}"
echo "=== 🛡️ PHP VERIFICATION GATE ==="
if [ -d "$TARGET_DIR" ]; then
  cd "$TARGET_DIR"
  composer validate --strict
  composer install --no-interaction --prefer-dist
  ./vendor/bin/phpstan analyse --level=5
  ./vendor/bin/phpunit
else
  echo "⚠️ Target directory $TARGET_DIR does not exist yet. Skipping live execution."
fi
echo "=== ✅ GATE COMPLETED ==="
```

## Troubleshooting

### "Could not auto-detect tech stack"
- Check detection files exist in project root
- Verify file patterns match exactly (case-sensitive on Linux)
- Run `./devbox detect ../your-project` to debug

### "Unknown type 'xxx' (not in tech_stacks)"
- Add the type to `tech_stacks` in config
- Or remove explicit `type` from project to allow auto-detection

### Gate template not found
- Ensure gate script exists at the path in `gate_template`
- Check `{path}` placeholder is present
- Verify script is executable (`chmod +x`)