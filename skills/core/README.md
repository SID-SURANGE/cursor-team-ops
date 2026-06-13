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

| Skill | Triggered by |
|-------|-------------|
| 🔍 `pre-commit-check` | *"commit this"* / *"create a commit"* |
| 💬 `commit-message` | *"write a commit message"* / *"conventional commit"* |
| 📬 `pr-summary` | *"open a PR"* / *"push and PR"* |
| 🔎 `minimal-diff-review` | *"review my changes"* / *"check the diff"* |
| 🗺️ `pr-review-canvas` | *"review canvas"* / *"map this PR"* |
| 📋 `requirements-qa` | *(auto — when working in BRD / docs / requirements folders)* |
| 🏛️ `architecture-decision-records` | *"create an ADR"* / *"document this decision"* |
| 🧹 `deslop` | *"deslop"* / *"clean this up"* / *"remove dead code"* |
| 📝 `sync-docs-after-edit` | *"sync docs"* / *"did my change break any docs?"* |
| 💡 `document-this` | *"document this"* / *"add a why-comment"* |
| 📋 `write-changelog` | *"write a changelog entry"* / *"update CHANGELOG"* |
| 🤝 `handoff` | *"generate handoff"* / *"close session"* |

---

## Promoting a community skill to core

A skill in `skills/community/` may be nominated for promotion after:

- 3+ months with no reported issues
- Positive feedback from at least two independent teams
- Clean, minimal `SKILL.md` with no external dependencies

Open a discussion to nominate. See [CONTRIBUTING.md](../../CONTRIBUTING.md).
