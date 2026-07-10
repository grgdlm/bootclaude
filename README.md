# bootclaude

Set up Claude Code config for any repo with one command. Install once, then run
`/bootstrap` in a project and it detects the stack and writes a matching `.claude/`
layer and `CLAUDE.md`. It also handles multi-repo projects (a parent folder grouping
several repos).

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

Run `/bootstrap` in any folder, empty or existing:

```
/bootstrap
```

It inspects the folder and picks one of two modes:

- **Single repo**: the folder is one project. It resolves platform, framework, backend,
  database, and auth (detecting from your files, asking when it can't tell), runs
  `git init` if the folder isn't a repo yet, and writes the config.
- **Project workspace**: the folder groups multiple code repos (e.g. `crm/` holding
  `crm-web/` and `crm-api/`). It writes an index `CLAUDE.md` at the parent describing each
  sub-repo, then configures each child repo with its own stack, its own `CLAUDE.md`, and
  `git init`. It configures the sub-folders it finds and can create named ones you don't
  have yet.

Pass choices explicitly to skip detection in single-repo mode (order: platform, framework,
backend, database, auth; any can be `none`):

```
/bootstrap web nextjs none drizzle better-auth
/bootstrap none none nestjs prisma none
```

It generates, per repo:

- `CLAUDE.md` with stack-specific guidance, a project description it asks you for, and a header
- `.claude/settings.json` with permissions and a format-on-save hook
- `.claude/agents/` with a base code-reviewer plus platform-specific reviewers
- `.claude/commands/` with `/pr` and `/review`
- `.claude/hooks/format.sh` that runs prettier, eslint, swiftformat, or ktlint on edited files

It runs `git init` where needed but never commits or pushes; the first commit is yours.
Existing `CLAUDE.md` and `settings.json` are never overwritten. It appends or skips and
tells you which.

## Supported stacks

| Dimension  | Options |
|-----------|---------|
| platform  | `web`, `react-native`, `ios`, `android` |
| framework | `nextjs`, `vite-react`, `expo` |
| backend   | `hono`, `nestjs` |
| database  | `drizzle`, `prisma`, `supabase`, `firebase` |
| auth      | `better-auth`, `clerk`, `supabase-auth`, `firebase-auth` |

Any dimension can be `none`. In a single repo, `framework` and `backend` are mutually
exclusive: a repo is a frontend, a fullstack framework, or a backend API. Front and back
together belong in separate repos under a project workspace.

## Adding a stack

Create a folder. No code to edit:

```
~/.claude/bootstrap-templates/frameworks/remix/claude.md
~/.claude/bootstrap-templates/backends/express/claude.md
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
    ├── base/CLAUDE.md            # single-repo CLAUDE.md template
    ├── base/PROJECT.md           # workspace-parent index template
    ├── platforms/<name>/claude.md (+ optional agents/)
    ├── frameworks/<name>/claude.md
    ├── backends/<name>/claude.md
    ├── databases/<name>/claude.md
    └── auth/<name>/claude.md
```
