---
name: discover-repo
description: Explore an unfamiliar or newly cloned repository to understand its structure, tech stack, entry points, and conventions. Use when the user opens a new repo, asks "what is this?", "how does this work?", "walk me through the codebase", or asks you to understand a project before making changes. Also use proactively when switching between repositories.
disable-model-invocation: true
---

# 🔭 Discover Repo

## Goal
Give yourself enough context to work effectively in an unfamiliar repo in under 2 minutes. Do not make any changes during discovery.

## Steps

1. **Root scan** — read `README.md`, `AGENTS.md` (if present), and any top-level config files: `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Makefile`, `pom.xml`. These override your inferences.

2. **Check `.cursor/`** — read `.cursor/rules/*.mdc` and any `SKILL.md` files. Project rules take precedence over team defaults.

3. **Structure** — list top-level directories. Identify `src/`, `lib/`, `app/`, `tests/`, `docs/`, `scripts/`.

4. **Entry points** — find the main executable, API server start file, or primary import/export path.

5. **Tech stack** — language version, framework, database, test runner, CI config (`.github/`, `.gitlab-ci.yml`).

6. **Conventions** — read 1–2 representative source files to infer naming style, import order, error handling pattern, and comment density.

## Output
Summarize in ≤10 bullet points:
- What the repo does (one sentence)
- Stack and runtime version
- Entry point and how to run
- Test command
- 1–2 non-obvious conventions to follow
- Any `.cursor/` rules or `AGENTS.md` constraints that override defaults
