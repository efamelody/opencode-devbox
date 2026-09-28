---
description: Execute a Change Request spec on a target project with gate verification
---

You are assigned to execute Change Request: **$1**

### Instructions:
1. Read the specification file at `.specs/$1/spec.md`.
2. Locate the target project directory defined in `devbox-config.yaml`.
3. Check if any specialized skills in `.devbox/skills/` apply to this task and apply their rules.
4. Modify the code in the target project sibling directory.
5. Execute `./devbox gate <target-alias>` in the operator terminal.
6. Write a summary of modified files and verification results to `.specs/$1/plan.md`.