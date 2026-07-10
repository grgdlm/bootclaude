#!/usr/bin/env bash
# Installs the /bootstrap command and its template library into ~/.claude.
# Safe to re-run: it refreshes the templates and command in place.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

echo "Installing into: $CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/commands" "$CLAUDE_DIR/bootstrap-templates"

# 1. The slash command (available globally, in every repo).
cp "$HERE/command/bootstrap.md" "$CLAUDE_DIR/commands/bootstrap.md"
echo "  ✓ command → commands/bootstrap.md   (use it as /bootstrap)"

# 2. The overlay template library.
rm -rf "$CLAUDE_DIR/bootstrap-templates"
cp -R "$HERE/templates" "$CLAUDE_DIR/bootstrap-templates"
# Strip macOS cruft that cp -R may have carried over, then make sure the format
# hook is executable when copied into projects later.
find "$CLAUDE_DIR/bootstrap-templates" -name '.DS_Store' -delete
find "$CLAUDE_DIR/bootstrap-templates" -name '*.sh' -exec chmod +x {} \;
echo "  ✓ templates → bootstrap-templates/"

echo ""
echo "Done. Open Claude Code in any repo and run:  /bootstrap"
echo "It will detect the stack (or ask), then scaffold .claude/ + CLAUDE.md."
echo ""
echo "To add a new stack later, drop a folder under:"
echo "  $CLAUDE_DIR/bootstrap-templates/{platforms,frameworks,databases,auth}/<name>/claude.md"
echo "No code changes needed — the command reads folder names as the source of truth."
