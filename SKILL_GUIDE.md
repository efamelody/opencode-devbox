# Skill Guide

How to create, manage, and apply skills for AI agents in the Devbox Operator.

## Overview

Skills are instruction sets that guide AI agents when working on specific types of tasks. They're stored as Markdown files in `.devbox/skills/<skill-name>/SKILL.md`.

## Skill Structure

```
.devbox/skills/
├── security-audit/
│   └── SKILL.md
├── db-migration/
│   └── SKILL.md
├── spring-boot-refactor/
│   └── SKILL.md
└── your-custom-skill/
    └── SKILL.md
```

## Writing a Skill

### Basic Template

```markdown
# Skill: <Skill Name>

## When to Apply
Describe the scenarios where this skill should be used.

## Rules
1. **Rule 1**: Clear, actionable instruction
2. **Rule 2**: Another instruction
3. **Rule 3**: More instructions

## Examples (Optional)
Show before/after code snippets demonstrating the skill.

## Verification
How to verify the skill was applied correctly.
```

### Example: Security Audit Skill

```markdown
# Skill: Security & Authentication

## When to Apply
When handling auth, user input, secrets, or any security-sensitive logic.

## Rules
1. **Input Sanitization**: Always validate and sanitize user inputs. Use allow-lists over block-lists.
2. **Secrets Management**: Never hardcode credentials. Use environment variables or secret managers.
3. **Authentication**: Unauthenticated requests must return 401/403 with clean JSON errors.
4. **Authorization**: Check permissions on every protected endpoint.
5. **Rate Limiting**: Apply rate limits to all public endpoints.
6. **Security Headers**: Set CSP, HSTS, X-Frame-Options, etc.

## Verification
- Run security linter (Semgrep, CodeQL)
- Check for hardcoded secrets (git-secrets, truffleHog)
- Verify auth middleware on protected routes
- Confirm rate limiting headers in responses
```

## Applying Skills

### 1. Tech Stack Defaults

Skills are automatically applied based on tech stack in `devbox-config.yaml`:

```yaml
tech_stacks:
  node:
    default_skills: ["security-audit", "db-migration"]
  java-gradle:
    default_skills: ["spring-boot-refactor", "security-audit"]
```

### 2. Project Overrides

Projects can extend or replace default skills:

```yaml
projects:
  my-api:
    path: "../my-api"
    skills: ["security-audit", "api-design", "custom-skill"]
```

### 3. Task-Level Skills

When creating a task, skills are embedded in `task.json`:

```json
{
  "skills": ["security-audit", "db-migration"],
  "target_alias": "my-api"
}
```

The AI agent reads this and applies relevant skills.

## Skill Discovery

### List Available Skills

```bash
./devbox skills
```

Output:
```
Available Skills:
------------------------------------------------------------
• security-audit
  Security & Authentication

• db-migration
  Database Migration Guidance
```

### Skill Metadata

The first heading in `SKILL.md` becomes the description. Keep it concise.

## Best Practices

### 1. Keep Skills Focused

One skill = one concern. Split large skills:
- `security-audit` (general)
- `api-security` (API-specific)
- `data-protection` (PII, encryption)

### 2. Make Rules Actionable

❌ "Write secure code"
✅ "Validate all user inputs with Zod schemas before processing"

### 3. Include Verification Steps

Skills should be testable:
- Lint rules
- Test patterns
- Manual checks

### 4. Version Skills

For breaking changes, version the skill directory:
```
.devbox/skills/
├── security-audit/
│   └── SKILL.md
└── security-audit-v2/
    └── SKILL.md
```

Reference specific versions in config:
```yaml
tech_stacks:
  node:
    default_skills: ["security-audit-v2"]
```

## Skill Categories

### Security Skills
- `security-audit` - General security practices
- `api-security` - API authentication/authorization
- `data-protection` - PII, encryption, compliance

### Architecture Skills
- `db-migration` - Schema changes, migrations
- `api-design` - REST/GraphQL design patterns
- `event-driven` - Event sourcing, CQRS

### Framework Skills
- `spring-boot-refactor` - Spring Boot patterns
- `nextjs-patterns` - Next.js App Router patterns
- `fastapi-patterns` - FastAPI best practices

### Company Skills (via plugins)
- `company-security-audit` - Extended security
- `company-api-standards` - Internal API conventions
- `company-deployment` - Deploy to company infrastructure

## Extending Skills via Plugins

See [PLUGIN_GUIDE.md](PLUGIN_GUIDE.md) for adding company-specific skills without modifying core.

## Testing Skills

1. Create a test task: `./devbox task test-project "Apply security-audit skill"`
2. Check `.agent-inbox/test-project/task_*/task.json` includes the skill
3. Have AI agent work on it
4. Verify `./devbox gate test-project` passes

## Troubleshooting

### Skill not applied
- Check skill name matches exactly (case-sensitive)
- Verify skill directory exists in `.devbox/skills/`
- Check `default_skills` in tech stack config
- Check project-level `skills` override

### Conflicting skills
- Order matters: later skills can override earlier
- Use specific skills over general ones
- Document known conflicts

### Skill not found
- Run `./devbox skills` to list discovered skills
- Check `.devbox/skills/` directory structure
- Verify `SKILL.md` exists (not `skill.md` or `Skill.md`)