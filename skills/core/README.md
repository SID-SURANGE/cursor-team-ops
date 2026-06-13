<div align="center">

# 🧠 Core Skills

[![skills](https://img.shields.io/badge/skills-12%20curated-6366f1?style=flat-square)](#skill-reference)
[![tier](https://img.shields.io/badge/tier-core%20%28maintainer%20reviewed%29-a855f7?style=flat-square)](#skill-reference)

Curated, maintainer-reviewed skills — tested on real projects, kept minimal.
Triggered automatically by phrase. No slash command needed.

</div>

---

## How skills work

Each skill is a `SKILL.md` file with YAML frontmatter the agent uses to decide when to load it:

```yaml
---
name: skill-name
description: What it does and what phrases trigger it.
disable-model-invocation: true  # optional — pure procedural skills only
---
```

The agent matches the `description` field against the current task context. When it fires, it reads the full `SKILL.md` and follows the steps inside.

`disable-model-invocation: true` marks a skill as a pure checklist — the agent executes it directly without spawning a sub-model. Set this on procedural skills (commit checks, PR creation). Omit it on open-ended reasoning skills (debugging, test writing).

Skills are installed flat — both `core/` and `community/` land in `~/.cursor/skills/` and `<repo>/.cursor/skills/`.

---

## Skill reference

### 🔍 `pre-commit-check`

**Say:** *"commit this"* / *"create a commit"*

**Use when:** You're about to make a git commit. Before touching `git commit`, this skill scans your staged diff for secrets, debug code, unrelated file changes, and empty staging areas. It also checks your commit message matches the project's convention. Think of it as a last-second sanity check so you don't accidentally push a password or a half-finished change.

---

### 💬 `commit-message`

**Say:** *"write a commit message"* / *"conventional commit"* / *"what should I commit this as"*

**Use when:** You've made changes but aren't sure how to describe them. The skill reads your staged diff, infers the right Conventional Commits type (`feat`, `fix`, `refactor`, etc.) and scope from the changed file paths, and writes a properly formatted message for you — not just a generic AI summary, but one that follows the `type(scope): subject` structure your team expects.

---

### 📬 `pr-summary`

**Say:** *"open a PR"* / *"push and PR"* / *"submit for review"*

**Use when:** Your branch is ready for review. The skill reads every commit in the branch (not just the latest), drafts a clear PR title and summary, writes a test plan checklist, then runs `gh pr create` for you. It handles the push if the branch isn't on the remote yet.

---

### 🔎 `minimal-diff-review`

**Say:** *"review my changes"* / *"check the diff"* / *"look at what I changed"*

**Use when:** You've made a batch of changes and want a quick gut-check before committing or opening a PR. The skill looks for scope creep (changes unrelated to the task), convention drift (style inconsistencies), leftover debug code, and anything that seems off. Good to run after a long session before you commit.

---

### 🗺️ `pr-review-canvas`

**Say:** *"review canvas"* / *"map this PR"*

**Use when:** You're reviewing someone else's PR (or your own large one) and the diff is hard to parse. Instead of reading the raw diff top-to-bottom, this skill groups changes by purpose — new features, bug fixes, refactors, config changes — flags the riskiest sections, and produces a reviewer map so you know where to focus your attention first.

---

### 📋 `requirements-qa`

**Triggers automatically** when you're working in `docs/`, `requirements/`, or BRD files.

**Also say:** *"did we capture this correctly?"* / *"review this requirements doc"*

**Use when:** You're writing or reviewing a requirements, BRD, or discovery document. The skill checks for invented assumptions (things nobody said but got written in), open questions that were never answered, and conflicts between source documents. Useful before handing off requirements to engineering to avoid "we never said that" moments.

---

### 🏛️ `architecture-decision-records`

**Say:** *"create an ADR"* / *"document this decision"*

**Use when:** Your team just made a meaningful technical decision — choosing a database, picking an auth strategy, deciding to deprecate a service — and you want it on record. The skill creates a structured ADR file (Context → Decision → Consequences) so future developers understand why things are the way they are, not just what they are.

---

### 🧹 `deslop`

**Say:** *"deslop"* / *"clean this up"* / *"remove dead code"*

**Use when:** Code has accumulated noise — comments that just describe what the code already says, unused imports, variables that are assigned but never read, empty try/catch blocks that swallow errors silently. The skill strips that clutter without touching logic. Good to run after a feature is complete and working, before the PR goes for review.

---

### 📝 `sync-docs-after-edit`

**Say:** *"sync docs"* / *"did my change break any docs?"* / *"check if docs are up to date"*

**Use when:** You've just changed code — a function signature, a CLI flag, an API endpoint — and you're not sure if the README, CHANGELOG, or other markdown files still reflect reality. The skill scans all `.md` files in the repo and flags anything that contradicts or is stale relative to your changes.

---

### 💡 `document-this`

**Say:** *"document this function"* / *"add comments"* / *"write docstrings"*

**Use when:** A function, class, or module has non-obvious behaviour that would confuse the next developer — a hidden constraint, a subtle invariant, or a workaround for a specific bug. The skill writes *why-comments* (explaining intent and constraints) rather than *what-comments* (narrating the code). It won't add a comment just to have one.

---

### 📋 `write-changelog`

**Say:** *"update changelog"* / *"write a changelog entry"* / *"what changed since last release"*

**Use when:** You're cutting a release and need to update `CHANGELOG.md`. The skill reads the commits since the last release (or a PR range you specify), groups them into Added / Changed / Fixed / Removed sections following Keep-a-Changelog format, and skips internal-only entries (chores, CI, style) that users don't care about.

---

### 🤝 `handoff`

**Say:** *"generate handoff"* / *"close session"* / *"write handoff doc"*

**Use when:** You're finishing a session — especially a long debugging session or multi-day task — and someone else (or future you) needs to pick it up. The skill writes a `HANDOFF.md` capturing what was done, what was tried and failed (and why), what's still open, and the recommended first next step. Unlike a PR summary, it records the *debugging context and failed attempts* that a diff can't show.

---

## Promoting a community skill to core

A skill in `skills/community/` may be nominated for promotion after:

- 3+ months with no reported issues
- Positive feedback from at least two independent teams
- Clean, minimal `SKILL.md` with no external dependencies

Open a discussion to nominate. See [CONTRIBUTING.md](../../CONTRIBUTING.md).
