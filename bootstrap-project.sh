#!/usr/bin/env bash
# bootstrap-project.sh — scaffolds .cursor/ + AGENTS.md in any repo
# Usage: bash /path/to/cursor-team-ops/bootstrap-project.sh [repo-path]
# Defaults to current directory if no path given.

set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${1:-$(pwd)}"

echo "Bootstrapping Cursor project overlay in: $REPO_DIR"
echo ""

# ── AGENTS.md ─────────────────────────────────────────────────────────────────
if [ -f "$REPO_DIR/AGENTS.md" ]; then
  echo "  [skip]  AGENTS.md already exists"
else
  cp "$KIT_DIR/templates/AGENTS.md" "$REPO_DIR/AGENTS.md"
  echo "  [added] AGENTS.md — fill in project name, paths, and commands"
fi

# ── .cursor/rules/project-context.mdc ────────────────────────────────────────
mkdir -p "$REPO_DIR/.cursor/rules"
if [ -f "$REPO_DIR/.cursor/rules/project-context.mdc" ]; then
  echo "  [skip]  .cursor/rules/project-context.mdc already exists"
else
  cp "$KIT_DIR/templates/project-context.mdc" "$REPO_DIR/.cursor/rules/project-context.mdc"
  echo "  [added] .cursor/rules/project-context.mdc — fill in source-of-truth path and overrides"
fi

# ── .cursor/commands/ ────────────────────────────────────────────────────────
shopt -s nullglob
mkdir -p "$REPO_DIR/.cursor/commands"
for cmd in "$KIT_DIR/templates/commands/"*.md; do
  name="$(basename "$cmd")"
  if [ -f "$REPO_DIR/.cursor/commands/$name" ]; then
    echo "  [skip]  .cursor/commands/$name already exists"
  else
    cp "$cmd" "$REPO_DIR/.cursor/commands/$name"
    echo "  [added] .cursor/commands/$name"
  fi
done

echo ""
echo "Done. Edit these files, then commit them:"
echo "  $REPO_DIR/AGENTS.md"
echo "  $REPO_DIR/.cursor/rules/project-context.mdc"
echo "  $REPO_DIR/.cursor/commands/*.md  (customize or remove slash commands as needed)"
