# Skill: Artifact Documentation Generator

Creates structured HTML documentation artifacts for each change/ticket, capturing what was changed, why, and how.

## When to Apply
- After completing any task that modifies code
- When closing a Change Request (CR)
- When implementing a feature, fix, or refactor
- For audit trails and knowledge transfer

## Rules

1. **Artifact per Ticket**: Each task/CR gets its own artifact folder
2. **Capture Intent**: Document the problem statement and requirements
3. **Document Changes**: List all modified files with diff summaries
4. **Explain Implementation**: Describe approach, patterns, and decisions
5. **Include Verification**: Show gate results and test evidence
6. **Link Context**: Reference related specs, tasks, and PRs

## Artifact Structure

```
.artifacts/
├── CR-101-rate-limiting/
│   ├── index.html              # Main artifact page
│   ├── metadata.json           # Structured metadata
│   ├── changes/
│   │   ├── file-diffs.md       # Unified diff of all changes
│   │   └── file-list.json      # List of modified files
│   ├── implementation/
│   │   ├── approach.md         # Technical approach
│   │   ├── patterns.md         # Patterns used
│   │   └── decisions.md        # Key decisions & tradeoffs
│   ├── verification/
│   │   ├── gate-output.txt     # Gate execution output
│   │   └── test-results.json   # Test results summary
│   └── assets/
│       └── styles.css          # Shared styling
```

## HTML Artifact Template

The generated `index.html` should include:
- **Header**: Ticket ID, title, status, date, author
- **Problem Statement**: What was requested and why
- **Solution Overview**: High-level approach
- **Files Changed**: Table with file, type, lines added/removed
- **Implementation Details**: Collapsible sections per component
- **Verification**: Gate status, test results, screenshots
- **Related**: Links to spec, task, PR, commits

## Automation

1. **On Task Creation**: Scaffold artifact folder with metadata
2. **During Implementation**: Agent appends to `changes/` and `implementation/`
3. **On Gate Pass**: Auto-generate `verification/` and final `index.html`
4. **On Complete**: Mark artifact as `status: completed`

## Verification

- Artifact folder exists in `.artifacts/<ticket-id>/`
- `index.html` renders without errors
- `metadata.json` validates against schema
- All changed files documented in `changes/file-list.json`
- Gate output captured in `verification/gate-output.txt`