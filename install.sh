#!/usr/bin/env bash
# One-command bootstrap for a new machine: clone (or update) this repo and
# run setup-claude with whatever arguments were passed.
#
#   curl -fsSL https://raw.githubusercontent.com/rolshoven/claude-setup/main/install.sh | bash -s -- --all
#   curl -fsSL .../install.sh | bash -s -- --bundle protect-env
#
# Override the source or checkout location with CLAUDE_SETUP_REPO / CLAUDE_SETUP_DIR.
set -euo pipefail

REPO="${CLAUDE_SETUP_REPO:-https://github.com/rolshoven/claude-setup.git}"
DIR="${CLAUDE_SETUP_DIR:-$HOME/.claude-setup}"

for cmd in git python3; do
  command -v "$cmd" >/dev/null || { echo "error: $cmd is required" >&2; exit 1; }
done

if [ -d "$DIR/.git" ]; then
  git -C "$DIR" pull --ff-only --quiet
else
  git clone --quiet "$REPO" "$DIR"
fi

[ $# -gt 0 ] || set -- --all
exec "$DIR/setup-claude" "$@"
