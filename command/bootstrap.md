---
description: Scaffold Claude config (CLAUDE.md, agents, hooks) into a repo, or set up a multi-repo project workspace
argument-hint: "[platform] [framework] [backend] [database] [auth] (all optional; omit to auto-detect or ask)"
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

You are bootstrapping Claude configuration for the current working directory. It may be a
single code repo, or a parent folder that groups several code repos (for example `crm/`
holding `crm-web/` and `crm-api/`). Work carefully and idempotently. Never overwrite the
user's existing files without asking.

## 0. Locate the template library

The overlays live at `$HOME/.claude/bootstrap-templates`. Confirm it exists and list the
valid choices per category:

!`ls "$HOME/.claude/bootstrap-templates" 2>/dev/null && echo "---" && ls "$HOME/.claude/bootstrap-templates"/{platforms,frameworks,backends,databases,auth} 2>/dev/null`

The subfolder names under each category ARE the valid choices (source of truth; new folders
added later are valid too). Do not invent values outside these.

## 1. Inspect the target

!`pwd && echo "--- git ---" && (git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo "current dir IS a git repo" || echo "current dir is NOT a git repo") && echo "--- files ---" && ls -a && echo "--- package.json deps (if any) ---" && cat package.json 2>/dev/null | sed -n '/"dependencies"/,/}/p;/"devDependencies"/,/}/p' && echo "--- native signals ---" && find . -maxdepth 1 \( -name '*.xcodeproj' -o -name '*.xcworkspace' -o -name 'Package.swift' -o -name 'build.gradle*' -o -name 'settings.gradle*' \) 2>/dev/null || true`

Immediate sub-folders, and whether each looks like its own project:

!`find . -maxdepth 1 -mindepth 1 -type d -not -name '.*' 2>/dev/null | sort | while read -r d; do m=$(find "$d" -maxdepth 1 \( -name 'package.json' -o -name '*.xcodeproj' -o -name 'Package.swift' -o -name 'build.gradle*' \) 2>/dev/null | tr '\n' ' '); echo "$d -> ${m:-no project markers}"; done`

## 2. Choose the mode

- **Single repo** — the current dir is itself a project (has `package.json` or native
  project files), or it has no meaningful sub-projects. Configure just this directory.
- **Project workspace** — the current dir is a parent that groups multiple code repos: its
  sub-folders have their own `package.json`/project files and the parent has no app code of
  its own. Example: `crm/` with `crm-web/` and `crm-api/`.

Decide from the signals above; if it is ambiguous, ASK me. In workspace mode, also ask
whether there are additional sub-repos to create now that don't exist yet (I give a name and
stack for each) — create those folders and configure them alongside the ones already there.

Print the chosen mode and the full plan (every folder and file you will create, and where
you will run `git init`) and let me confirm before doing anything.

## 3. Resolve the stack (for each repo you will configure)

Arguments (any may be empty), used as defaults in single-repo mode: platform=`$1`
framework=`$2` backend=`$3` database=`$4` auth=`$5`.

For each repo, resolve the five dimensions with this priority:
1. **Explicit arg** (single-repo mode only), validated against the folder names.
2. **Detect** from that repo's files:
   - platform: `next`/`vite`/`react`/`react-dom` → `web`; `react-native`/`expo` → `react-native`; `.xcodeproj`/`Package.swift`/`.swift` → `ios`; `build.gradle*`/`.kt` → `android`.
   - framework: `next` → `nextjs`; `vite` (+react, no next) → `vite-react`; `expo` → `expo`. (Native platforms have no framework overlay; skip.)
   - backend: `hono` → `hono`; `@nestjs/core`/`@nestjs/common` → `nestjs`.
   - database: `drizzle-orm` → `drizzle`; `prisma`/`@prisma/client` → `prisma`; `@supabase/supabase-js` → `supabase`; `firebase`/`firebase-admin` → `firebase`.
   - auth: `better-auth` → `better-auth`; `@clerk/*` → `clerk`; supabase auth → `supabase-auth`; firebase auth → `firebase-auth`.
3. **Ask me** (concise multiple-choice, valid folder names plus "none") for anything still
   ambiguous or absent. Batch the questions across all repos.

Ask about EVERY dimension you could not confidently detect, INCLUDING backend — each as its
own choice with a `none` option. Never silently skip a dimension; do not assume `none` for
backend just because a frontend framework is present. A single repo is usually a frontend, a
fullstack framework, OR a backend API, so it is normal for `framework` or `backend` to end up
`none` — but that is my choice to make from the offered options, not yours to pre-empt. (If I
want both a frontend framework and a separate backend in one place, that is the cue to use a
project workspace instead.)

Also collect a one-or-two-sentence description of what each repo is and who it is for (and,
in workspace mode, one for the overall project). Draft from a README if one exists and
confirm it; otherwise ask. Always get a description; do not leave it blank.

## 4. Assemble

Let `T="$HOME/.claude/bootstrap-templates"`.

### 4a. Base tree (every code repo, and a workspace parent)
Copy `T/base/.claude/` into the target's `./.claude/`, but NEVER clobber files that already
exist. If `./.claude/settings.json` exists, leave it and tell me you skipped it. Copy the
hook and `chmod +x ./.claude/hooks/format.sh`.

### 4b. git init
If a target code repo is NOT already a git repo, run `git init` in it (default yes for a real
code repo). Do NOT stage, commit, or push — the first commit is mine. A workspace parent
stays non-git; do not init it.

### 4c. CLAUDE.md
- **A single repo, or a child repo in a workspace** — from `T/base/CLAUDE.md`:
  - If `./CLAUDE.md` does NOT exist, fill the placeholders:
    - `{{PROJECT_NAME}}` → repo/package name (package.json `name`, else the directory name).
    - `{{PROJECT_DESCRIPTION}}` → the description you collected above.
    - `{{DATE}}` → `date +%Y-%m-%d`.
    - `{{STACK_SUMMARY}}` → e.g. "web · nextjs · drizzle · better-auth" (omit `none`s).
    - `{{PKG_MANAGER}}` → lockfile: `pnpm-lock.yaml`→pnpm, `yarn.lock`→yarn, `bun.lockb`→bun, `package-lock.json`→npm; native → n/a.
    - `{{INSTALL_CMD}}`/`{{DEV_CMD}}`/`{{BUILD_CMD}}`/`{{TEST_CMD}}`/`{{LINT_CMD}}` → from package.json `scripts` when present; otherwise a clear TODO.
  - Then append the selected overlays' `claude.md` files, blank-line separated, IN THIS
    ORDER: platform → framework → backend → database → auth. Skip any dimension that is `none`.
  - If `./CLAUDE.md` DOES exist, do not replace it. Append the overlays under a divider
    `\n\n---\n<!-- appended by /bootstrap -->\n` and tell me.
- **A workspace parent** — write `./CLAUDE.md` from `T/base/PROJECT.md` (an index, not a repo
  file). Fill `{{PROJECT_NAME}}`, `{{PROJECT_DESCRIPTION}}`, `{{DATE}}`, and `{{SUBPROJECTS}}`
  with one block per child repo: its name, a one-line purpose, the resolved stack summary,
  and its path. Do not put per-repo command/convention detail here; that lives in each child.

### 4d. Agents
For each selected overlay dir that has an `agents/` subfolder (e.g. `T/platforms/ios/agents/`),
copy its `.md` files into that repo's `./.claude/agents/` (base `code-reviewer.md` is already
there; don't duplicate).

### 4e. .gitignore
In each git repo, ensure `.claude/settings.local.json` and `.env*` are ignored. Append if
missing; create `.gitignore` if absent. Do not remove existing entries.

## 5. Report

- The mode, and the resolved stack for each repo.
- Files created / skipped (and why), and where `git init` ran.
- Next steps: fill the `<!-- fill this in -->` / TODO spots, make the first commit in each
  repo when ready, and run `/review` to sanity-check.

Do not run installs or migrations, and do not commit or push. `git init` is the only git
action allowed. This command scaffolds config and repo structure only.
