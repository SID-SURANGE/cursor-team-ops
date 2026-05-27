#!/usr/bin/env bash
# git-guard.sh — blocks or warns on destructive git/shell commands
# Event: beforeShellExecution
# Installed to: ~/.cursor/hooks/git-guard.sh
# hooks.json path: ./hooks/git-guard.sh (relative to ~/.cursor/)

set -euo pipefail

input=$(cat)

# Extract "command" value from the JSON payload.
# Temporarily disables set -e inside the function so fallbacks can chain without
# triggering an early exit if one method fails.
extract_command() {
  local raw="$1"
  local result=""
  # Disable exit-on-error for this function body only
  set +e
  if command -v python3 &>/dev/null; then
    if result=$(python3 -c "import json,sys; print(json.loads(sys.stdin.read()).get('command',''))" <<< "$raw" 2>/dev/null) && [ -n "$result" ]; then
      echo "$result"; set -e; return
    fi
  fi
  if command -v python &>/dev/null; then
    if result=$(python -c "import json,sys; print(json.loads(sys.stdin.read()).get('command',''))" <<< "$raw" 2>/dev/null) && [ -n "$result" ]; then
      echo "$result"; set -e; return
    fi
  fi
  # Portable sed fallback: extract the value of "command" key
  result=$(echo "$raw" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
  set -e
  echo "$result"
}

raw_cmd=$(extract_command "$input")

# Guard: empty command string — nothing to check, allow
if [ -z "$raw_cmd" ]; then
  printf '%s\n' '{"permission":"allow"}'
  exit 0
fi

# ── Block: force push to main or master ──────────────────────────────────────
if echo "$raw_cmd" | grep -qE 'git\s+push.*(--force|-f).*\s(main|master)(\s|$)'; then
  printf '%s\n' '{"permission":"deny","user_message":"Force push to main/master is blocked by the team git-guard hook. Use a feature branch, or explicitly request an override.","agent_message":"Force push to main/master blocked by team hook (git-safety rule)."}'
  exit 0
fi

# ── Ask: force push to any other branch ──────────────────────────────────────
if echo "$raw_cmd" | grep -qE 'git\s+push.*(--force|-f)'; then
  printf '%s\n' '{"permission":"ask","user_message":"This is a force push. Please confirm the target branch is not main/master and you understand uncommitted remote history may be lost.","agent_message":"Force push detected — requires explicit user confirmation per team policy."}'
  exit 0
fi

# ── Ask: hard reset ───────────────────────────────────────────────────────────
if echo "$raw_cmd" | grep -qE 'git\s+reset\s+--hard'; then
  printf '%s\n' '{"permission":"ask","user_message":"git reset --hard will permanently discard uncommitted changes. Confirm you want to proceed.","agent_message":"Hard reset requires explicit user confirmation per team policy (git-safety rule)."}'
  exit 0
fi

# ── Ask: skip git hooks ───────────────────────────────────────────────────────
if echo "$raw_cmd" | grep -qE 'git.*(--no-verify|--no-gpg-sign)'; then
  printf '%s\n' '{"permission":"ask","user_message":"This command skips git hooks (--no-verify / --no-gpg-sign). Confirm this is intentional.","agent_message":"Skipping git hooks requires explicit user confirmation per team policy (git-safety rule)."}'
  exit 0
fi

# ── Block: rm -rf on root or home ────────────────────────────────────────────
if echo "$raw_cmd" | grep -qE 'rm\s+-[rRfF]*r[fF]?\s+(/|~|/home|/root)'; then
  printf '%s\n' '{"permission":"deny","user_message":"Removing root or home filesystem paths is blocked.","agent_message":"Destructive filesystem command blocked by team hook (security-basics rule)."}'
  exit 0
fi

printf '%s\n' '{"permission":"allow"}'
exit 0
