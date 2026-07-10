---
description: Review uncommitted or branch changes for bugs, security, and style
argument-hint: "[optional: path or 'staged']"
allowed-tools: Bash(git:*), Read, Grep, Glob
---

Review the current changes and report findings ranked by severity.

Changes to review:
- Unstaged: !`git diff --stat`
- Staged: !`git diff --cached --stat`
- Branch vs main: !`git diff --stat origin/main...HEAD 2>/dev/null || echo "(no main ref)"`

Delegate the actual review to the `code-reviewer` subagent so it runs in its own
context. Focus on: correctness bugs, security issues (injection, secrets, authz),
missing error handling, N+1 queries, and violations of the conventions in CLAUDE.md.
For each finding give file:line, severity, and a concrete fix. Be terse.

Scope hint from me: $ARGUMENTS
