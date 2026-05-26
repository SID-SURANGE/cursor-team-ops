#!/usr/bin/env bash
# session-context.sh — injects team kit version as context at session start
# Event: sessionStart
# Installed to: ~/.cursor/hooks/session-context.sh
# hooks.json path: ./hooks/session-context.sh (relative to ~/.cursor/)

VERSION_FILE="$HOME/.cursor/.team-kit-version"

if [ -f "$VERSION_FILE" ]; then
  VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')
  printf '%s\n' "{\"additional_context\": \"Cursor team kit v${VERSION} is active. Always-on rules: core-development, git-safety, agent-behavior (token-economy), security-basics, documentation (md/mdc). Skills available: discover-repo, pre-commit-check, pr-summary, minimal-diff-review, requirements-qa, workflow-from-chats, verify-this, pr-review-canvas, deslop, fix-merge-conflicts, sync-docs-after-edit, systematic-debugging, writing-tests, architecture-decision-records. Run install.sh (or install.ps1 on Windows) to update the kit.\"}"
else
  printf '%s\n' '{"additional_context": "Cursor team kit is active (version file not found — run install.sh to register the version). Always-on rules and all skills are loaded."}'
fi

exit 0
