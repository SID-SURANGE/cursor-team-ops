# Team Setup Examples

Real-world examples of cursor-team-kit deployed across three common team structures. Each shows the exact files committed to the repo, what goes in `AGENTS.md`, and any project-specific rule or hook additions worth making.

---

## Example 1 — Web App Team (React + Node API)

**Setup:** 6 developers, two repos (`frontend/`, `backend/`), feature-branch workflow, GitHub Actions CI.

### What the team lead did

```bash
# Frontend repo
cd ~/repos/frontend
bash ~/cursor-team-kit/bootstrap-project.sh
bash ~/cursor-team-kit/sync-project.sh
# edited AGENTS.md and project-context.mdc (see below)
git add .cursor/ AGENTS.md && git commit -m "chore: add cursor-team-kit baseline"

# Backend repo — same steps
cd ~/repos/backend
bash ~/cursor-team-kit/bootstrap-project.sh
bash ~/cursor-team-kit/sync-project.sh
git add .cursor/ AGENTS.md && git commit -m "chore: add cursor-team-kit baseline"
```

### What each developer ran (once)

```bash
bash ~/cursor-team-kit/install.sh
# then git pull in each repo — .cursor/ arrives via normal git sync
```

### `AGENTS.md` — frontend repo

```markdown
# frontend — Agent Context

> Read this file before making any changes in this repository.

## What this repo is

React SPA for the customer dashboard. TypeScript, Vite, Tailwind CSS, React Query.

## Key paths

| Path | Contents |
|------|----------|
| `src/components/` | Shared UI components — always use existing ones before creating new |
| `src/pages/` | Route-level page components |
| `src/hooks/` | Custom React hooks |
| `src/api/` | React Query definitions — all server state lives here |
| `tests/` | Vitest unit + integration tests |

## Source of truth

Requirements and design decisions: `docs/product-spec.md`
Always read before answering questions about scope or intended behaviour.

## Commands

\`\`\`bash
npm install          # install dependencies
npm run dev          # dev server on :5173
npm test             # vitest
npm run lint         # eslint + tsc --noEmit
npm run build        # production build
\`\`\`

## Conventions

- All components are functional. No class components.
- Data fetching via React Query only — no raw fetch/axios in components.
- Tailwind only for styling — no CSS modules, no inline styles.
- Component files: PascalCase. Hook files: camelCase prefixed with `use`.

## Do not touch without asking

- `src/api/queryClient.ts` — shared React Query config; changes affect the whole app
- `docs/product-spec.md` — source of truth for requirements; never edit without explicit instruction

## Open questions

- Dark mode: not yet specified. Do not add theming until it appears in product-spec.md.
```

### `.cursor/rules/project-context.mdc` — frontend repo

```markdown
---
description: Frontend project context — React SPA, Tailwind, React Query
alwaysApply: true
---

# Project Context — Frontend

Source of truth for requirements: `docs/product-spec.md`. Read it before answering scope questions.

## Non-negotiable conventions
- Tailwind classes only. No CSS modules.
- All server state via React Query (`src/api/`). No fetch/axios in components.
- TypeScript strict mode. Never use `any` without a comment explaining why.
- Test file naming: `ComponentName.test.tsx` co-located with the component.

## What to check before every PR
- `npm run lint` passes with zero errors.
- No `console.log` left in changed files.
- No new dependencies added without being asked.
```

---

## Example 2 — API / Backend Team (Python FastAPI)

**Setup:** 4 developers, monolithic API repo, Postgres, Docker Compose for local dev, pytest, GitHub Actions.

### `AGENTS.md`

```markdown
# api — Agent Context

> Read this file before making any changes in this repository.

## What this repo is

FastAPI REST API for the platform backend. Python 3.12, SQLAlchemy 2.0 (async), Alembic migrations, pytest.

## Key paths

| Path | Contents |
|------|----------|
| `app/routers/` | FastAPI route handlers — one file per resource |
| `app/models/` | SQLAlchemy ORM models |
| `app/schemas/` | Pydantic request/response schemas |
| `app/services/` | Business logic — routers call services, not DB directly |
| `app/db/` | Database session, base model, engine config |
| `alembic/` | Migration scripts — never edit generated files by hand |
| `tests/` | pytest — mirrors `app/` structure |

## Source of truth

API contract: `docs/openapi-spec.yaml`
Read before adding, changing, or removing any endpoint.

## Commands

\`\`\`bash
docker compose up -d          # start Postgres + Redis locally
pip install -e ".[dev]"       # install deps including test/lint extras
uvicorn app.main:app --reload # dev server on :8000
pytest                        # full test suite
alembic upgrade head          # apply pending migrations
ruff check . && ruff format . # lint + format
\`\`\`

## Conventions

- Routers import from services only. Services import from models. Models have no business logic.
- All DB access is async (`async with get_session() as session`).
- Pydantic v2 schemas. Use `model_validator` not `validator`.
- Migration naming: `alembic revision --autogenerate -m "add_user_preferences_table"`.

## Do not touch without asking

- `alembic/versions/` — never manually edit migration files
- `app/db/base.py` — shared declarative base; changes affect every model
- `docs/openapi-spec.yaml` — source of truth for the API contract

## Open questions / constraints

- Rate limiting: not yet implemented. Placeholder middleware exists in `app/middleware/rate_limit.py` — do not remove.
```

### `.cursor/rules/project-context.mdc`

```markdown
---
description: Backend API context — FastAPI, SQLAlchemy async, Alembic
alwaysApply: true
---

# Project Context — API

Source of truth for the API contract: `docs/openapi-spec.yaml`. Read before touching any endpoint.

## Layer discipline (enforce strictly)
- Routers → Services → Models. Never skip a layer.
- No SQLAlchemy queries in routers. No business logic in models.

## Before every migration
- Run `alembic check` to confirm the migration matches the model changes.
- Migration files are auto-generated — never edit them by hand after creation.

## Test conventions
- Every new endpoint needs at least one happy-path and one error-path test.
- Use `pytest-asyncio` with `AsyncClient` from `httpx` — not `requests`.
- Fixtures live in `tests/conftest.py`. Add shared fixtures there, not in individual test files.
```

### Project-level hook — block accidental migration runs

Added `.cursor/hooks.json` to the repo:

```json
{
  "version": 1,
  "hooks": {
    "beforeShellExecution": [
      {
        "command": ".cursor/hooks/migration-guard.sh",
        "matcher": "alembic upgrade",
        "failClosed": false
      }
    ]
  }
}
```

`.cursor/hooks/migration-guard.sh`:

```bash
#!/usr/bin/env bash
# Warn before running alembic upgrade — confirm it's intentional
printf '%s\n' '{"permission":"ask","user_message":"About to run a database migration. Confirm you have a backup and are targeting the correct environment.","agent_message":"Migration requires explicit confirmation per team policy."}'
exit 0
```

---

## Example 3 — Monorepo Team (Node.js, multiple services)

**Setup:** 8 developers, monorepo with `apps/web`, `apps/api`, `packages/shared`, Turborepo, pnpm workspaces.

### Monorepo-specific challenge

A single `.cursor/` at the monorepo root works for the whole team. Add one `project-context.mdc` that maps the workspace structure, and let each service have its own `AGENTS.md` inside its directory.

### Root `AGENTS.md`

```markdown
# monorepo — Agent Context

> Read this file first. Then read the AGENTS.md inside the specific app or package you're working in.

## What this repo is

Turborepo monorepo. pnpm workspaces. Node 20. TypeScript throughout.

## Workspace layout

| Path | What it is |
|------|-----------|
| `apps/web` | Next.js 14 customer-facing app |
| `apps/api` | Express REST API |
| `apps/admin` | Internal ops dashboard (React) |
| `packages/shared` | Shared types, utils, and validation schemas used by all apps |
| `packages/ui` | Shared component library |

## Commands (run from root unless noted)

\`\`\`bash
pnpm install                    # install all workspace deps
pnpm dev                        # start all apps in parallel (turbo)
pnpm dev --filter=web           # start one app only
pnpm test                       # run all tests (turbo)
pnpm test --filter=api          # test one workspace
pnpm build                      # build all (turbo, cached)
pnpm lint                       # lint all
\`\`\`

## Cross-workspace conventions

- Shared types always go in `packages/shared/src/types/`. Never duplicate type definitions across apps.
- Never import from `apps/*` in `packages/*`. Packages must not depend on apps.
- `packages/ui` components are unstyled by default. Apps apply Tailwind classes at usage site.

## Do not touch without asking

- `turbo.json` — pipeline config; wrong changes silently break caching
- `packages/shared/src/types/api.ts` — contract between frontend and backend; discuss changes in a PR first

## Open questions

- `apps/admin` — currently unmaintained. Do not add features without checking with the team.
```

### Root `.cursor/rules/project-context.mdc`

```markdown
---
description: Monorepo context — Turborepo, pnpm workspaces, shared packages
alwaysApply: true
---

# Project Context — Monorepo

## Before making any change

1. Identify which workspace the change belongs to (`apps/web`, `apps/api`, `packages/shared`, etc.).
2. Read the `AGENTS.md` inside that workspace directory if one exists.
3. Check whether the change touches `packages/shared` — if so, it affects all apps and needs extra care.

## Import discipline
- `packages/*` must not import from `apps/*`. Ever.
- Shared types, schemas, and utilities go in `packages/shared`. Do not duplicate them.

## Running commands
- Always scope `pnpm` commands with `--filter=<workspace>` when working on a single app.
- Run `pnpm build` from the root before opening a PR — Turborepo will catch broken cross-package dependencies.
```

---

## What to commit vs. what to keep local

| File | Commit to repo? | Why |
|------|----------------|-----|
| `.cursor/rules/*.mdc` | ✅ Yes | Team-wide — everyone should get the same rules via `git pull` |
| `.cursor/skills/` | ✅ Yes | Ensures consistent skill versions across the team |
| `.cursor/commands/` | ✅ Yes | Shared starting point; developers can add their own |
| `AGENTS.md` | ✅ Yes | Project context for the agent — essential for new developers and new Cursor sessions |
| `.cursor/hooks.json` | ✅ Yes (if project-level) | Project-specific enforcement belongs in the repo |
| `~/.cursor/` (machine install) | ❌ No | Machine-level; each developer runs `install.sh` themselves |

---

## Keeping the whole team in sync after a kit update

When the kit releases a new version:

```bash
# Team lead — update one repo, commit, push
cd ~/cursor-team-kit && git pull
cd /path/to/your/repo
bash ~/cursor-team-kit/sync-project.sh
git add .cursor/
git commit -m "chore: sync cursor-team-kit to v$(cat ~/cursor-team-kit/VERSION)"
git push

# Each developer — pull the repo update, re-run machine install
git pull
cd ~/cursor-team-kit && git pull && bash install.sh
# Reload Cursor
```

The `sessionStart` hook prints the active kit version at the start of every session. If a developer's version differs from the repo's, they'll see it immediately.
