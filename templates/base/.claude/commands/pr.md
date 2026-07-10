---
description: Open a pull request for the current branch with a generated title and body
argument-hint: "[optional extra context]"
allowed-tools: Bash(git:*), Bash(gh:*), Read, Grep
---

Create a pull request for the current branch.

Current state:
- Branch: !`git branch --show-current`
- Status: !`git status --short`
- Commits vs main: !`git log --oneline origin/main..HEAD 2>/dev/null || git log --oneline -10`
- Diff stat: !`git diff --stat origin/main...HEAD 2>/dev/null || git diff --stat HEAD~5`

Do the following:
1. If there are uncommitted changes, stop and tell me — don't commit without asking.
2. Push the branch with `git push -u origin <branch>`.
3. Open a PR with `gh pr create`. Write a concise title and a body that summarizes
   WHAT changed and WHY, grouped logically. Include a short testing section.
4. If a PR template exists under `.github/`, mirror its headings.

Extra context from me: $ARGUMENTS
