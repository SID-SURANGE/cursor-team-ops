#!/usr/bin/env bash
# install.sh — symlinks cursor-team-kit into ~/.cursor/
# Usage: bash install.sh
# Re-run after git pull to update.

set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSOR_DIR="$HOME/.cursor"

if [ ! -f "$KIT_DIR/VERSION" ]; then
  echo "Error: VERSION file not found in $KIT_DIR. Is this a complete clone?" >&2
  exit 1
fi

echo "Installing Cursor team kit v$(cat "$KIT_DIR/VERSION") from $KIT_DIR"
echo ""

# ── Directories ──────────────────────────────────────────────────────────────
mkdir -p "$CURSOR_DIR/rules" "$CURSOR_DIR/skills" "$CURSOR_DIR/hooks"

# Prevent unmatched globs from being passed as literal strings
shopt -s nullglob

# ── Rules ─────────────────────────────────────────────────────────────────────
for rule in "$KIT_DIR/rules/"*.mdc; do
  name="$(basename "$rule")"
  target="$CURSOR_DIR/rules/$name"
  { [ -L "$target" ] || [ -f "$target" ]; } && rm "$target"
  ln -s "$rule" "$target"
  echo "  [rule]  $name"
done

# ── Skills (core + community, both installed flat into ~/.cursor/skills/) ─────
for tier in core community; do
  for skill_dir in "$KIT_DIR/skills/$tier/"/*/; do
    name="$(basename "$skill_dir")"
    target="$CURSOR_DIR/skills/$name"
    { [ -L "$target" ] || [ -d "$target" ]; } && rm -rf "$target"
    ln -s "$skill_dir" "$target"
    echo "  [skill/$tier] $name"
  done
done

# ── hooks.json ────────────────────────────────────────────────────────────────
target="$CURSOR_DIR/hooks.json"
if [ -L "$target" ] || [ -f "$target" ]; then
  # Back up only if it's a real file (not our symlink)
  if [ ! -L "$target" ]; then
    mv "$target" "${target}.bak"
    echo "  [hooks] Backed up existing hooks.json → hooks.json.bak"
  else
    rm "$target"
  fi
fi
ln -s "$KIT_DIR/hooks.json" "$target"
echo "  [hooks] hooks.json"

# ── Hook scripts ──────────────────────────────────────────────────────────────
for script in "$KIT_DIR/hooks/"*.sh; do
  name="$(basename "$script")"
  target="$CURSOR_DIR/hooks/$name"
  { [ -L "$target" ] || [ -f "$target" ]; } && rm "$target"
  ln -s "$script" "$target"
  chmod +x "$script"
  echo "  [hook]  $name"
done

# ── Record version ────────────────────────────────────────────────────────────
cp "$KIT_DIR/VERSION" "$CURSOR_DIR/.team-kit-version"

echo ""
echo "Done. Team kit v$(cat "$KIT_DIR/VERSION") installed to ~/.cursor/"
echo "Next: in each repo, run bootstrap-project.sh and sync-project.sh so rules/skills"
echo "      appear in Cursor Settings. Then reload Cursor."
