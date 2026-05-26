# Changelog

## 1.3.0 — 2026-05-26

### Added
- `skills/community/spec-driven-development` — write a spec before touching code; gated workflow (Specify → Plan → Implement)
- `skills/community/security-hardening` — OWASP Top 10 coverage, boundary system, pre-deployment security checklist
- `skills/community/ci-cd-pipeline` — quality gate pipeline setup, GitHub Actions config, deployment strategy, CI failure feedback loop
- `skills/community/ATTRIBUTIONS.md` — legal attribution record for community skills informed by external MIT-licensed work

### Changed
- `README.md` — added community skills table with trigger phrases and attribution link
- `session-context.sh` — updated skills list to include 3 new community skills

---

## 1.2.0 — 2026-05-26

### Added
- `hooks/README.md` — full schema reference for hooks.json, supported events, response format, testing guide, project-level hooks
- `TEAMS.md` — real-world team setup examples for web app, API, and monorepo teams
- `CONTRIBUTING.md` — documented `disable-model-invocation` frontmatter flag with guidance on when to set it

### Changed
- `README.md` — rewritten with team-ops positioning, skills-vs-commands distinction, rolling out to a team section
- `install.sh` — fixed operator precedence bug on symlink removal (`||` + `&&` without braces); added VERSION file existence check
- `sync-project.sh` — fixed hardcoded project name "briefcast" in output; added existence check on repo path argument
- `hooks/git-guard.sh` — added early exit for empty command string to prevent grep exit-code misfires

### Fixed
- `install.ps1` — added missing trailing newline to prevent prompt appearing on last output line

---

## 1.1.1 — 2026-05-26

### Added
- `sync-project.sh` / `sync-project.ps1` — copy team rules and skills into `<repo>/.cursor/` so they appear in Cursor Settings

### Changed
- `README.md` — document machine vs project install, Settings UI behavior, Windows Git Bash note
- `ONBOARDING.md` — fix verify checklist (filesystem vs Settings); troubleshooting for empty Rules/Skills panel

---

## 1.1.0 — 2026-05-12

### Added
- `agent-behavior.mdc` — Token economy section (concise responses, no preamble, tables over prose)
- `workflow-from-chats` skill — extract a repeated conversation pattern into a ready-to-commit SKILL.md
- `verify-this` skill — structured evidence chain: baseline → treatment → evidence → verdict
- `pr-review-canvas` skill — group PR changes by purpose, flag risky sections, produce reviewer map
- `deslop` skill — strip narrating comments, dead imports/variables, and empty try/catches
- `fix-merge-conflicts` skill — resolve conflict markers with explanation and post-resolution verification
- `sync-docs-after-edit` skill — scan all .md files after local changes and flag stale documentation
- `systematic-debugging` skill — hypothesis → reproduction → experiment → evidence → verdict loop
- `writing-tests` skill — test structure for any language: happy path, edge cases, error paths
- `architecture-decision-records` skill — create or update ADR files following the standard template

---

## 1.0.0 — 2026-04-28

Initial release.

### Added
- `core-development.mdc` — minimal diff, style, tests, comments
- `git-safety.mdc` — commit discipline, destructive command guards
- `agent-behavior.mdc` — read-before-edit, persistence, communication
- `security-basics.mdc` — no secrets in code/commits
- `documentation.mdc` — doc tone and BRD/requirements standards
- `discover-repo` skill — rapid codebase orientation
- `pre-commit-check` skill — staged diff review before commit
- `pr-summary` skill — PR title, summary, test plan via gh CLI
- `minimal-diff-review` skill — scope creep and convention drift check
- `requirements-qa` skill — BRD/discovery doc quality check
- `git-guard.sh` hook — blocks/warns on destructive git commands
- `session-context.sh` hook — injects kit version at session start
- `install.sh` — symlinks kit into `~/.cursor/`
- `bootstrap-project.sh` — scaffolds `.cursor/` + `AGENTS.md` in any repo
- `templates/AGENTS.md` and `templates/project-context.mdc`
