#!/usr/bin/env bash
# PostToolUse formatter dispatcher.
# Receives Claude Code's tool JSON on stdin; formats the file that was edited
# using whatever formatter the repo actually has. No-ops silently if none.
set -euo pipefail

# Extract the edited file path from the hook payload (tool_input.file_path).
payload="$(cat)"
file="$(printf '%s' "$payload" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)"
[ -z "${file:-}" ] && exit 0
[ -f "$file" ] || exit 0

ext="${file##*.}"

run() { command -v "$1" >/dev/null 2>&1; }

case "$ext" in
  ts|tsx|js|jsx|json|css|scss|md|mjs|cjs)
    if [ -f "./node_modules/.bin/prettier" ]; then
      ./node_modules/.bin/prettier --write --log-level warn "$file" 2>/dev/null || true
    elif run prettier; then
      prettier --write --log-level warn "$file" 2>/dev/null || true
    fi
    if [ -f "./node_modules/.bin/eslint" ]; then
      ./node_modules/.bin/eslint --fix "$file" 2>/dev/null || true
    fi
    ;;
  swift)
    if run swiftformat; then swiftformat "$file" 2>/dev/null || true; fi
    if run swiftlint; then swiftlint --fix --quiet "$file" 2>/dev/null || true; fi
    ;;
  kt|kts)
    if run ktlint; then ktlint -F "$file" 2>/dev/null || true; fi
    ;;
  *) : ;;
esac

exit 0
