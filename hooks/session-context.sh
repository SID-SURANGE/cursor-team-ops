#!/usr/bin/env bash
# session-context.sh — injects kit version and last-session handoff as context at session start
# Event: sessionStart
# Installed to: ~/.cursor/hooks/session-context.sh
# hooks.json path: ./hooks/session-context.sh (relative to ~/.cursor/)

VERSION_FILE="$HOME/.cursor/.team-ops-version"
HANDOFF_FILE=".cursor/session-handoff.md"

SKILLS="pre-commit-check, commit-message, pr-summary, pr-review-canvas, minimal-diff-review, \
deslop, document-this, sync-docs-after-edit, write-changelog, handoff, onboarding, \
architecture-decision-records, requirements-qa, workflow-from-chats, \
commit-history-audit, env-drift-check, release-readiness, \
spec-driven-development, security-hardening, ci-cd-pipeline, requirements-synthesis"

RULES="Always-on: core-development, git-safety, agent-behavior, security-basics, documentation. \
Conditional: transaction-atomicity (multi-step DB writes), architectural-drift (import boundaries), \
telemetry-standards (structured logging)."

if [ -f "$VERSION_FILE" ]; then
  VERSION=$(tr -d '[:space:]' < "$VERSION_FILE")
  BASE_CONTEXT="Cursor team kit v${VERSION} is active. ${RULES} Skills available: ${SKILLS}. \
Hooks: git-guard (direct/force-push to main, hard-reset), session-context (this hook). \
Run install.sh (or install.ps1 on Windows) to update the kit."
else
  BASE_CONTEXT="Cursor team kit is active (version file not found — run install.sh to register the version). \
${RULES} Skills available: ${SKILLS}."
fi

# Inject last-session handoff if it exists in the current working directory
if [ -f "$HANDOFF_FILE" ]; then
  HANDOFF=$(cat "$HANDOFF_FILE")
  CONTEXT="${BASE_CONTEXT}

--- LAST SESSION HANDOFF ---
${HANDOFF}
--- END HANDOFF ---

Resume from the handoff above. Do not re-derive what is already documented there."
else
  CONTEXT="$BASE_CONTEXT"
fi

# Escape for JSON: replace backslashes, then double-quotes, then newlines
ESCAPED=$(printf '%s' "$CONTEXT" | sed 's/\\/\\\\/g; s/"/\\"/g' | awk '{printf "%s\\n", $0}')

printf '{"additional_context": "%s"}\n' "$ESCAPED"
exit 0
