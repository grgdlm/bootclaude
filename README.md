# bootclaude

Set up Claude Code config for any repo with one command. Install once, then run
`/bootstrap` in a project and it detects the stack and writes a matching `.claude/`
layer and `CLAUDE.md`.

## Install

```bash
git clone https://github.com/grgdlm/bootclaude
cd bootclaude
bash install.sh
```

This copies two things into `~/.claude`:

- `commands/bootstrap.md`: the global `/bootstrap` command.
- `bootstrap-templates/`: the template library it builds from.

`/bootstrap` is then available in every repo. Re-run `install.sh` any time to update.

## Usage

Run `/bootstrap` in any repo, empty or existing:

```
/bootstrap
```

It detects platform, framework, database, and auth from your files (package.json,
lockfiles, `.xcodeproj`, `build.gradle`, and so on) and asks when it can't tell. Pass
choices explicitly to skip detection:

```
/bootstrap web nextjs drizzle better-auth
/bootstrap ios none none firebase-auth
```

It generates:

- `CLAUDE.md` with stack-specific guidance and a project header
- `.claude/settings.json` with permissions and a format-on-save hook
- `.claude/agents/` with a base code-reviewer plus platform-specific reviewers
- `.claude/commands/` with `/pr` and `/review`
- `.claude/hooks/format.sh` that runs prettier, eslint, swiftformat, or ktlint on edited files

Existing `CLAUDE.md` and `settings.json` are never overwritten. It appends or skips and
tells you which.

## Supported stacks

| Dimension  | Options |
|-----------|---------|
| platform  | `web`, `react-native`, `ios`, `android` |
| framework | `nextjs`, `vite-react`, `expo` |
| database  | `drizzle`, `prisma`, `supabase`, `firebase` |
| auth      | `better-auth`, `clerk`, `supabase-auth`, `firebase-auth` |

Database and auth can be `none`.

## Adding a stack

Create a folder. No code to edit:

```
~/.claude/bootstrap-templates/frameworks/remix/claude.md
~/.claude/bootstrap-templates/databases/mongodb/claude.md
```

Add an optional `agents/` subfolder inside an overlay to ship a review agent with it.
`/bootstrap` reads directory names as the source of truth, so a new option is selectable
on the next run.

## Layout

```
bootclaude/
├── install.sh
├── command/bootstrap.md          # copied to ~/.claude/commands/bootstrap.md
└── templates/                    # copied to ~/.claude/bootstrap-templates/
    ├── base/.claude/             # always applied
    ├── platforms/<name>/claude.md (+ optional agents/)
    ├── frameworks/<name>/claude.md
    ├── databases/<name>/claude.md
    └── auth/<name>/claude.md
```
