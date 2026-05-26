#!/usr/bin/env bash
# sync-project.sh — copy team rules and skills into a repo's .cursor/ for Settings UI visibility
# Usage: bash /path/to/cursor-team-kit/sync-project.sh [repo-path]
# Defaults to current directory. Safe to re-run (overwrites kit files only).

set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${1:-$(pwd)}"
if [ ! -d "$REPO_DIR" ]; then
  echo "Error: repo path does not exist: $REPO_DIR" >&2
  exit 1
fi
REPO_DIR="$(cd "$REPO_DIR" && pwd)"

echo "Syncing team kit rules and skills into: $REPO_DIR"
echo ""

mkdir -p "$REPO_DIR/.cursor/rules" "$REPO_DIR/.cursor/skills"

shopt -s nullglob

for rule in "$KIT_DIR/rules/"*.mdc; do
  name="$(basename "$rule")"
  cp "$rule" "$REPO_DIR/.cursor/rules/$name"
  echo "  [rule]  $name"
done

for tier in core community; do
  for skill_dir in "$KIT_DIR/skills/$tier/"*/; do
    name="$(basename "$skill_dir")"
    rm -rf "$REPO_DIR/.cursor/skills/$name"
    cp -r "$skill_dir" "$REPO_DIR/.cursor/skills/$name"
    echo "  [skill] $name"
  done
done

echo ""
echo "Done. Reload Cursor (Developer: Reload Window) and check Settings → Rules, Commands"
echo "with the project tab selected (your repo name)."
