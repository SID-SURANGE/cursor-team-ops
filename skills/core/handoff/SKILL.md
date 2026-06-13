---
name: handoff
description: Generate a structured session handoff document capturing progress, root causes, failed attempts, open issues, and next steps. Triggered by "generate handoff", "close session", "write handoff doc", "end of day", "EOD", "I'm done for today", "wrapping up", "switching tasks", "summarise what we did", "summarize progress", "session summary", "handoff".
---

# 📋 Handoff

## Purpose
Prevent context loss between agent or developer sessions. The handoff doc captures what happened, what was tried, what's unresolved, and what to do next — so the next session starts informed, not from scratch.

This is not a PR summary. It captures *debugging context*, *failed attempts*, and *open questions* that a diff cannot show.

## When to run
- End of a long debugging or implementation session
- Before handing work to another developer or agent
- When pausing a multi-day task

## Steps

### 1. Gather session context
Run in parallel:
- `git log --oneline -10` — recent commits
- `git diff HEAD` — any uncommitted changes
- `git status` — working tree state

### 2. Review conversation history
Identify:
- What was the original goal?
- What was completed? (with file/line references where possible)
- What was attempted but failed? (include the reason it failed)
- What is still open or unresolved?
- What questions remain unanswered?

### 3. Write the handoff document

Write to **two paths simultaneously**:

| Path | Purpose |
|------|---------|
| `.cursor/session-handoff.md` | Machine-readable — auto-injected at next session start |
| `HANDOFF.md` (repo root) | Human-readable — shareable, committable |

Both files get identical content. `.cursor/session-handoff.md` is picked up by the `sessionStart` hook so the next Cursor session starts warm without the developer having to do anything.

```markdown
# Handoff — <date>

## Goal
<One sentence: what this session set out to accomplish.>

## Status
<Completed / In Progress / Blocked>

## What was done
- <bullet: file/feature changed and why>
- <cite files as `path/to/file.ts:line` where relevant>

## What was attempted but did not work
| Approach | Why it failed |
|----------|--------------|
| <attempt> | <root cause or blocker> |

## Open issues
- [ ] <unresolved item — be specific>
- [ ] <open question that needs an answer>

## Recommended next steps
1. <concrete action with context>
2. <second action>

## Relevant files
- `<path>` — <one-line description of relevance>

## Skills that may help
- <skill-name> — <why relevant>
```

### 4. Reference, don't duplicate
- Link to existing files rather than pasting their content.
- Reference commit SHAs for specific changes rather than re-describing the diff.

### 5. Report
Tell the user: both files written, key open issues, and recommended first next step. Remind them that `.cursor/session-handoff.md` will be auto-loaded at the next session start.

## Output
- `.cursor/session-handoff.md` — auto-injected next session (do not commit this file; add to `.gitignore`)
- `HANDOFF.md` — shareable summary for the team or future self
