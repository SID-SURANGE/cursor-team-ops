<div align="center">

# 🛡️ Rules

[![rules](https://img.shields.io/badge/rules-5%20always--on-6366f1?style=flat-square)](#rule-reference)
[![scope](https://img.shields.io/badge/scope-all%20files%20%7C%20all%20sessions-06b6d4?style=flat-square)](#rule-reference)

Always-on agent guardrails — loaded automatically in every session, every file, every repo.
No trigger phrase needed. No configuration required.

</div>

---

## How rules work

Rules are `.mdc` files with a YAML frontmatter block that tells Cursor when to apply them:

```yaml
---
description: What this rule does
alwaysApply: true       # fires on every file
globs: **/*.md,**/*.mdc # or: fires only on matching files
---
```

- `alwaysApply: true` — rule is injected into every agent context window
- `globs` without `alwaysApply` — rule fires only when the active file matches the pattern
- Both can coexist: `alwaysApply: true` + `globs` scopes the rule to matching files only

Rules live in two places after install:

| Location | Installed by | Visible in Settings UI? |
|----------|-------------|------------------------|
| `~/.cursor/rules/` | `install.sh` / `install.ps1` | ❌ No — active but not listed |
| `<repo>/.cursor/rules/` | `sync-project.sh` / `sync-project.ps1` | ✅ Yes — Settings → Rules, Commands |

---

## Rule reference

| File | `alwaysApply` | Scope | Enforces |
|------|:-------------:|-------|---------|
| `core-development.mdc` | ✅ | all files | Minimal diffs · match existing style · no placeholders · no over-engineering |
| `git-safety.mdc` | ✅ | all files | No force-push main · no `--no-verify` · commit only when asked · HEREDOC message format |
| `agent-behavior.mdc` | ✅ | all files | Read before edit · use tools not shell · concise output · no preamble · parallel tool calls |
| `security-basics.mdc` | ✅ | all files | No secrets in code or commits · warn before staging sensitive files |
| `documentation.mdc` | ❌ | `**/*.md`, `**/*.mdc` | Precise prose · no invented requirements · cite existing content · no duplicate files |

---

## Adding a project-specific rule

After `bootstrap-project.sh`, your repo gets `.cursor/rules/project-context.mdc` — edit that file for project-level overrides. You do not need to add a new file.

If you genuinely need a separate project rule (e.g. a client-requirements pointer):

1. Create `.cursor/rules/<name>.mdc` in the repo
2. Add frontmatter with `description` and `alwaysApply: true` (or a `globs` pattern)
3. Keep it focused — one rule, one concern
4. Commit it — teammates get it on `git pull`

Rules in `<repo>/.cursor/rules/` stack with team rules. They do not override them.

---

## Changing a team rule

Team rules are maintainer-only. See [CONTRIBUTING.md](../CONTRIBUTING.md) for the process.

> Every `alwaysApply: true` rule adds token cost to **every session for every user**. Rules are kept intentionally minimal — each one was retained because it measurably changes agent behaviour.
