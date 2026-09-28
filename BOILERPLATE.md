# Devbox Operator Boilerplate

A reusable, tech-stack-agnostic control plane for managing multiple software projects with AI-assisted development workflows.

## Quick Start

### 1. Fork/Clone This Repository

```bash
git clone <this-repo> devbox-operator
cd devbox-operator
```

### 2. Customize for Your Organization

Edit `devbox-config.yaml`:
- Update `operator_name`
- Add/remove `tech_stacks` for your tech stack
- Register your projects under `projects`

### 3. Verify Setup

```bash
./devbox validate
./devbox list
./devbox tech-stacks
./devbox skills
```

### 4. Use with OpenCode / Claude Code

```bash
# Create a task for an agent
./devbox task my-project "Add user authentication endpoint"

# In OpenCode: "Work on the my-project task"
# Agent will read .agent-inbox/my-project/task_*/request.md
# Make changes, then run:
./devbox gate my-project
```

## Architecture

```
devbox-operator/
├── devbox                    # Main CLI (Python)
├── devbox-config.yaml        # Central configuration
├── .devbox/
│   ├── gates/                # Verification gate scripts (templates)
│   ├── skills/               # Skill instruction sets
│   ├── templates/            # Project scaffolding templates
│   ├── plugins/              # Extension system
│   └── system-prompt.md      # AI agent instructions
├── .opencode/commands/       # OpenCode slash commands
├── .specs/                   # Change Request specifications
└── .agent-inbox/             # Task packages for AI agents
```

## Core Concepts

### Tech Stack Registry
Define once, use everywhere. Each stack specifies:
- Detection files (auto-detect project type)
- Gate template (verification command)
- Default skills (security, db-migration, etc.)
- Environment variables

### Projects
Sibling directories registered with:
- Path (relative to operator)
- Optional explicit type (auto-detected if omitted)
- Custom skills & environment overrides

### Gates
Verification commands that must pass before a task is complete:
- Lint, test, build
- Custom per tech stack
- Extensible via plugins

### Skills
Instruction sets for AI agents:
- Security audit
- Database migration
- Framework-specific patterns
- Company-specific extensions

### Tasks
Structured work packages for AI agents:
- Created via `./devbox task <alias> "prompt"`
- Stored in `.agent-inbox/<alias>/task_<timestamp>/`
- Contains `request.md` (prompt) + `task.json` (metadata)

## Customizing for Your Company

### 1. Add Your Tech Stacks
Edit `devbox-config.yaml` → `tech_stacks` section. See [TECH_STACK_GUIDE.md](TECH_STACK_GUIDE.md).

### 2. Create Project Templates
Add templates in `.devbox/templates/<stack>/<name>/`. See [TEMPLATE_GUIDE.md](TEMPLATE_GUIDE.md).

### 3. Define Company Skills
Add skills in `.devbox/skills/<name>/SKILL.md`. See [SKILL_GUIDE.md](SKILL_GUIDE.md).

### 4. Build Plugins
Extend with hooks, custom skills, templates. See [PLUGIN_GUIDE.md](PLUGIN_GUIDE.md).

### 5. Configure OpenCode Commands
Customize `.opencode/commands/` for your workflows.

## CLI Reference

| Command | Description |
|---------|-------------|
| `./devbox list` | List all registered projects |
| `./devbox gate <alias>` | Run verification gate |
| `./devbox task <alias> "prompt"` | Create task package |
| `./devbox detect <path>` | Detect tech stack for path |
| `./devbox validate` | Validate config & projects |
| `./devbox tech-stacks` | List registered tech stacks |
| `./devbox skills` | List available skills |
| `./devbox init <template> <alias> [path]` | Scaffold new project |

## AI Agent Workflow

1. **Task Created**: `./devbox task whatsapp-saas "Add rate limiting"`
2. **Agent Reads**: `.agent-inbox/whatsapp-saas/task_*/request.md`
3. **Agent Works**: Edits files in `../whatsapp-saas/`
4. **Agent Verifies**: Runs `./devbox gate whatsapp-saas`
5. **Gate Passes**: Task marked complete

## Requirements

- Python 3.8+
- PyYAML (`pip install pyyaml`)
- Git
- Runtime for your tech stacks (Node, Python, Java, Go, Rust, .NET)

## License

MIT - Fork freely for your organization.