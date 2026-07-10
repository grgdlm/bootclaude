---
description: Scaffold a tailored .claude/ layer (CLAUDE.md, agents, hooks) into the current repo based on its stack
argument-hint: "[platform] [framework] [database] [auth] — all optional; omit to auto-detect/ask"
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

You are bootstrapping the Claude configuration for the repo in the current working
directory. Work carefully and idempotently. Do NOT overwrite the user's existing work
without asking.

## 0. Locate the template library

The overlays live at `$HOME/.claude/bootstrap-templates`. Confirm it exists:

!`ls "$HOME/.claude/bootstrap-templates" 2>/dev/null && echo "---" && ls "$HOME/.claude/bootstrap-templates"/{platforms,frameworks,databases,auth} 2>/dev/null`

The subfolder names under each category ARE the valid choices (source of truth — if new
folders were added later, they're valid too). Do not invent values outside these.

## 1. Inspect the target repo

Current directory and key signals:

!`pwd && echo "--- files ---" && ls -a && echo "--- package.json deps (if any) ---" && cat package.json 2>/dev/null | sed -n '/"dependencies"/,/}/p;/"devDependencies"/,/}/p' && echo "--- native signals ---" && ls *.xcodeproj *.xcworkspace Package.swift build.gradle build.gradle.kts settings.gradle* 2>/dev/null`

## 2. Determine the stack

Arguments (any may be empty): platform=`$1` framework=`$2` database=`$3` auth=`$4`.

For each of the four dimensions, resolve a value using this priority:
1. **Explicit arg** if the user passed one (validate it against the folder names).
2. **Detect** from the repo:
   - platform: `next`/`vite`/`react`/`react-dom` → `web`; `react-native` or `expo` → `react-native`; `.xcodeproj`/`Package.swift`/`.swift` → `ios`; `build.gradle*`/`.kt` → `android`.
   - framework: `next` → `nextjs`; `vite` (+react, no next) → `vite-react`; `expo` → `expo`. (Native platforms have no framework overlay — skip.)
   - database: `drizzle-orm` → `drizzle`; `prisma`/`@prisma/client` → `prisma`; `@supabase/supabase-js` → `supabase`; `firebase`/`firebase-admin` → `firebase`.
   - auth: `better-auth` → `better-auth`; `@clerk/*` → `clerk`; supabase auth (supabase present, used for auth) → `supabase-auth`; firebase auth → `firebase-auth`.
3. **Ask me** (one concise multiple-choice question listing the valid folder names for that
   dimension, plus "none") for anything still ambiguous or absent. Batch the questions.
   It's fine for database/auth to be "none" (e.g. a pure UI repo or native app without them).

Before doing anything destructive, print the resolved stack as a one-line summary and the
list of files you will create, then proceed.

## 3. Assemble the layer

Let `T="$HOME/.claude/bootstrap-templates"`. Then:

1. **Base tree** → copy `T/base/.claude/` into `./.claude/`, but NEVER clobber files that
   already exist. If `./.claude/settings.json` already exists, leave it and tell me you
   skipped it (I can diff manually). Copy the hook and `chmod +x ./.claude/hooks/format.sh`.
2. **CLAUDE.md** (the template is `T/base/CLAUDE.md`, kept OUTSIDE the `.claude/` tree so
   step 1 doesn't copy an unfilled duplicate into `./.claude/`):
   - If `./CLAUDE.md` does NOT exist: start from `T/base/CLAUDE.md`, then replace
     the `{{PLACEHOLDERS}}`:
     - `{{PROJECT_NAME}}` → repo/package name (from package.json `name` or the directory name).
     - `{{DATE}}` → output of `date +%Y-%m-%d`.
     - `{{STACK_SUMMARY}}` → e.g. "web · nextjs · drizzle · better-auth".
     - `{{PKG_MANAGER}}` → detect from lockfile: `pnpm-lock.yaml`→pnpm, `yarn.lock`→yarn,
       `bun.lockb`→bun, `package-lock.json`→npm; native → n/a.
     - `{{INSTALL_CMD}}`/`{{DEV_CMD}}`/`{{BUILD_CMD}}`/`{{TEST_CMD}}`/`{{LINT_CMD}}` → fill
       from package.json `scripts` when present; otherwise leave a clear TODO placeholder.
   - If `./CLAUDE.md` DOES exist: do not replace it. Append the overlay sections (below) to
     the end under a divider `\n\n---\n<!-- appended by /bootstrap -->\n`, and tell me.
   - Append the selected overlays' `claude.md` files IN THIS ORDER, each separated by a
     blank line: platform → framework → database → auth. Skip any dimension that is "none".
3. **Agents**: for each selected overlay directory that contains an `agents/` subfolder
   (e.g. `T/platforms/ios/agents/`), copy those `.md` files into `./.claude/agents/`
   (base's `code-reviewer.md` is already there; don't duplicate).
4. **.gitignore**: ensure `.claude/settings.local.json` and `.env*` are ignored. Append if
   missing; create `.gitignore` if absent. Do not remove existing entries.

## 4. Report

Print a concise summary:
- Resolved stack.
- Files created / skipped (and why skipped).
- A short "next steps" list: fill the `<!-- fill this in -->` spots in CLAUDE.md, confirm
  the command placeholders, and run a quick `/review` to sanity-check.

Do not run installs, migrations, or git commits. This command only scaffolds config.
