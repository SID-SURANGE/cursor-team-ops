#!/usr/bin/env bash
# session-context.sh — injects team kit version as context at session start
# Event: sessionStart
# Installed to: ~/.cursor/hooks/session-context.sh
# hooks.json path: ./hooks/session-context.sh (relative to ~/.cursor/)

VERSION_FILE="$HOME/.cursor/.team-ops-version"

if [ -f "$VERSION_FILE" ]; then
  VERSION=$(tr -d '[:space:]' < "$VERSION_FILE")
  printf '%s\n' "{\"additional_context\": \"Cursor team kit v${VERSION} is active. Always-on rules: core-development, git-safety, agent-behavior (token-economy), security-basics, documentation (md/mdc). Conditional rules: transaction-atomicity (multi-step DB writes), architectural-drift (import boundaries), telemetry-standards (structured logging). Skills available: pre-commit-check, pr-summary, minimal-diff-review, requirements-qa, pr-review-canvas, deslop, sync-docs-after-edit, architecture-decision-records, commit-message, document-this, write-changelog, handoff, workflow-from-chats, spec-driven-development, security-hardening, ci-cd-pipeline. Hooks: git-guard (force-push/hard-reset), db-migration-guard (destructive migrations), license-gatekeeper (copyleft packages). Run install.sh (or install.ps1 on Windows) to update the kit.\"}"
else
  printf '%s\n' '{"additional_context": "Cursor team kit is active (version file not found — run install.sh to register the version). Always-on rules and all skills are loaded."}'
fi

exit 0
