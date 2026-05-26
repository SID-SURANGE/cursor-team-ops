# cursor-team-kit

**The team-ops layer for Cursor.** Consistent agent rules, skills, and git guardrails — across your entire engineering team, across every repo, installed in under 5 minutes.

Most Cursor setups are solo configurations. This kit solves a different problem: *how do you roll out Cursor to a whole team so everyone gets the same guardrails, the same skills, and the same commit discipline — and keeps them in sync as the team evolves?*

> **Not just another rules collection.** cursor-team-kit is a versioned, governed distribution system with machine install, per-repo sync, enforced git hooks, and a skill library with a quality bar. See [TEAMS.md](TEAMS.md) for real-world team setups.

---

## Who this is for

| You are... | This kit gives you... |
|------------|----------------------|
| An **engineering team lead** adopting Cursor across your team | One command per developer to get everyone on identical guardrails |
| A **senior developer** tired of inconsistent agent behaviour across repos | A versioned baseline you can `git pull` to update everywhere |
| A **solo developer** who wants production-grade agent discipline | 14 curated skills and 5 always-on rules — no noise, no bloat |

---

## What makes this different

| Other kits | cursor-team-kit |
|-----------|-----------------|
| Files to copy manually | `install.sh` + `sync-project.sh` — scripted, repeatable |
| No version tracking | `~/.cursor/.team-kit-version` — every machine knows what it's running |
| No enforcement | `git-guard.sh` hook — *blocks* force-push to main, *warns* on hard reset |
| Bash-only | Full **Windows PowerShell** path (`install.ps1`, `sync-project.ps1`) |
| Dump of 1,000+ skills | 14 curated skills with guardrails, output formats, and trigger phrases |
| Individual developer focus | Team governance: CODEOWNERS, CHANGELOG, promotion pipeline |

---

## Quick start

Cursor has **two install locations**. You need **both** for the full experience:

| Step | Script | Installs to | What you get |
|------|--------|-------------|--------------|
| **1. Machine** (once) | `install.sh` / `install.ps1` | `~/.cursor/` | Hooks + global agent context |
| **2. Per repo** | `bootstrap-project.sh` + `sync-project.sh` | `<repo>/.cursor/` | Rules, skills, and commands visible in Settings |

```bash
# Step 1 — run once per machine
git clone https://github.com/SID-SURANGE/cursor-team-kit ~/cursor-team-kit
cd ~/cursor-team-kit
bash install.sh          # macOS / Linux / Git Bash on Windows
# or: .\install.ps1      # Windows native PowerShell

# Step 2 — run in each repo
cd /path/to/your/repo
bash ~/cursor-team-kit/bootstrap-project.sh
bash ~/cursor-team-kit/sync-project.sh
# then reload Cursor: Ctrl+Shift+P → Developer: Reload Window
```

See [ONBOARDING.md](ONBOARDING.md) for the full per-developer checklist with verification steps.

---

## Rolling out to a team

```bash
# Team lead does this once, commits the result
cd /path/to/your/repo
bash ~/cursor-team-kit/bootstrap-project.sh
bash ~/cursor-team-kit/sync-project.sh
# Edit AGENTS.md and .cursor/rules/project-context.mdc for your project
git add .cursor/ AGENTS.md
git commit -m "chore: add cursor-team-kit baseline"
git push

# Each developer does this once on their machine
git clone https://github.com/SID-SURANGE/cursor-team-kit ~/cursor-team-kit
bash ~/cursor-team-kit/install.sh
# then git pull in the repo — .cursor/ arrives via normal git sync
```

After that, keeping everyone in sync is just `git pull` + `bash install.sh` when the kit releases a new version.

See [TEAMS.md](TEAMS.md) for example setups for a web app team, an API team, and a monorepo.

---

## What's in the kit

| Layer | Machine (`install.sh`) | Per repo (`bootstrap` + `sync`) |
|-------|------------------------|----------------------------------|
| **Rules** | `~/.cursor/rules/*.mdc` | `.cursor/rules/*.mdc` (incl. `project-context.mdc`) |
| **Skills** | `~/.cursor/skills/<name>/` | `.cursor/skills/<name>/` |
| **Hooks** | `~/.cursor/hooks.json` + scripts | Optional project `hooks.json` |
| **Commands** | — | `.cursor/commands/*.md` (`/pr`, `/review`, `/fix-issue`) |
| **Templates** | — | `AGENTS.md` at repo root |

---

## Rules (always-on)

Five rules apply to every file in every session. They are intentionally minimal — each one was kept because it changes agent behaviour in a measurable way.

| Rule | Enforces |
|------|---------|
| `core-development` | Minimal diffs · match existing style · no unrequested changes · no placeholders |
| `git-safety` | No force-push main · no `--no-verify` · commit only when asked · HEREDOC message format |
| `agent-behavior` | Read before edit · use tools not shell · concise output · no preamble |
| `security-basics` | No secrets in code or commits · warn before staging sensitive files |
| `documentation` | Precise prose · no invented requirements · cite existing content |

---

## Skills (on-demand)

Skills are loaded automatically when the agent detects a matching trigger phrase. No slash command needed — just work naturally.

### Core skills (curated, maintainer-reviewed)

| Skill | Triggered by |
|-------|-------------|
| `discover-repo` | "explore this codebase", "walk me through this project" |
| `pre-commit-check` | "commit this", "create a commit", "git commit" |
| `pr-summary` | "open a PR", "create a pull request", "push and PR" |
| `minimal-diff-review` | "review my changes", "review this diff" |
| `requirements-qa` | Working in BRD / docs / requirements folders |
| `workflow-from-chats` | "make this a skill", "extract this workflow" |
| `verify-this` | "verify this", "prove this works" |
| `pr-review-canvas` | "review canvas", "map this PR" |
| `deslop` | "deslop", "clean this up", "remove dead code" |
| `fix-merge-conflicts` | "fix merge conflicts", "resolve conflicts" |
| `sync-docs-after-edit` | "sync docs", "did my change break any docs?" |
| `systematic-debugging` | "debug this", "I can't figure out why" |
| `writing-tests` | "write tests for this", "what should I test" |
| `architecture-decision-records` | "create an ADR", "document this decision" |

### Community skills

_None yet. [Contribute one →](CONTRIBUTING.md)_

### Skills vs. commands — what's the difference?

- **Skills** are loaded automatically by the agent when it detects a trigger phrase. The developer does not type anything special.
- **Commands** (`.cursor/commands/*.md`) are invoked manually with `/command-name` in the agent input. Use them for explicit, user-initiated workflows.

---

## Slash commands (per-project)

`bootstrap-project.sh` copies three starter commands into every new repo:

| Command | What it does |
|---------|-------------|
| `/pr` | Commit, push, and open a PR with a generated description |
| `/review` | Pre-PR diff review: secrets, debug code, scope creep |
| `/fix-issue [number]` | Fetch a GitHub issue, implement a fix, open a PR |

Edit or delete them per-project. Add your own in `.cursor/commands/<name>.md`.

---

## Hooks (automatic enforcement)

| Hook | Event | Behaviour |
|------|-------|-----------|
| `git-guard.sh` | `beforeShellExecution` | Blocks force-push to main · warns on hard reset / `--no-verify` / root `rm -rf` |
| `session-context.sh` | `sessionStart` | Injects kit version + active rules/skills list as session context |

See [hooks/README.md](hooks/README.md) for the full schema reference, response format, how to test hooks locally, and how to add project-level hooks.

---

## Install details

### macOS / Linux

```bash
git clone https://github.com/SID-SURANGE/cursor-team-kit ~/cursor-team-kit
cd ~/cursor-team-kit
bash install.sh
# Restart Cursor
```

`install.sh` symlinks rules, skills, and hooks into `~/.cursor/`. Re-run after `git pull` to update.

### Windows — Git Bash (recommended)

```bash
git clone https://github.com/SID-SURANGE/cursor-team-kit ~/cursor-team-kit
cd ~/cursor-team-kit
bash install.sh
# Restart Cursor
```

> Use **Git for Windows** Bash (e.g. `C:\Program Files\Git\bin\bash.exe`), not WSL `bash`. WSL uses a different `$HOME` and files may land in the wrong place.

### Windows — native PowerShell

```powershell
git clone https://github.com/SID-SURANGE/cursor-team-kit $HOME\cursor-team-kit
cd $HOME\cursor-team-kit
.\install.ps1
# Restart Cursor
```

`install.ps1` creates symlinks when Developer Mode is enabled (Windows 10+); otherwise copies files. Re-run after `git pull` to refresh.

> Hooks are bash scripts. On native Windows without Git Bash or WSL, hooks will not fire. Use the Git Bash path for full hook support.

---

## Bootstrap a new repo

```bash
cd /path/to/your/repo
bash ~/cursor-team-kit/bootstrap-project.sh   # creates AGENTS.md, project-context.mdc, commands/
bash ~/cursor-team-kit/sync-project.sh         # copies rules + skills into .cursor/
# Reload Cursor
```

**PowerShell:**

```powershell
cd C:\path\to\your\repo
bash $HOME\cursor-team-kit\bootstrap-project.sh
.\$HOME\cursor-team-kit\sync-project.ps1
# Reload Cursor
```

`bootstrap-project.sh` creates (if not present):
- `AGENTS.md` — project identity, key paths, commands, conventions
- `.cursor/rules/project-context.mdc` — project-specific agent rule
- `.cursor/commands/` — starter slash commands

`sync-project.sh` copies team rules and skills into `.cursor/`. Safe to re-run after kit updates.

Commit `.cursor/` and `AGENTS.md` so the whole team shares the same setup via `git pull`.

---

## Keeping the kit up to date

```bash
cd ~/cursor-team-kit
git pull
bash install.sh                              # refresh ~/.cursor/ on this machine
bash sync-project.sh /path/to/your/repo      # refresh repo .cursor/ (repeat per repo)
# Reload Cursor
```

Version is recorded at `~/.cursor/.team-kit-version` and printed at every session start by the `session-context.sh` hook.

---

## Project file layout

After `bootstrap-project.sh` + `sync-project.sh`, a repo looks like:

```
your-repo/
  AGENTS.md                          ← what this repo is; read before making changes
  .cursor/
    rules/
      core-development.mdc           ← team rule (from sync-project)
      git-safety.mdc
      agent-behavior.mdc
      security-basics.mdc
      documentation.mdc
      project-context.mdc            ← project-specific rule (from bootstrap, edit this)
    skills/                          ← 14 core skills (from sync-project)
    commands/
      pr.md                          ← /pr command
      review.md                      ← /review command
      fix-issue.md                   ← /fix-issue command
    hooks.json                       ← optional project-level hooks
```

---

## Cursor Settings UI vs `~/.cursor/`

**Settings → Rules, Commands** shows **project** files only (`<repo>/.cursor/`). It does not enumerate `~/.cursor/rules/` or `~/.cursor/skills/` even after a successful `install.sh`. Global files still influence the agent — they just won't appear in the panel. Run `sync-project.sh` in the repo if you want rules and skills visible in Settings.

---

## Contributing

Community skills are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md) for the quality bar, SKILL.md format, and submission process.

Rules, hooks, and install scripts are maintainer-only.

---

## Governance

- Rules and core skill changes: PR + `CHANGELOG.md` entry, maintainer approval.
- Community skills: PR reviewed against the quality bar in `CONTRIBUTING.md`.
- Quarterly review: trim rules the agent ignores; promote community skills with a proven track record.
- Version is tagged; `sessionStart` hook prints the active version at the start of every session.

---

## Attributions

### Inspired-by credit

The workflow patterns behind three skills were inspired by the [awesome-cursor-skills](https://github.com/spencerpauly/awesome-cursor-skills) community repository (Spencer Pauly and contributors). The SKILL.md files in this kit are independently written and do not reproduce text from that source; the underlying engineering methods (structured debugging, test structure, ADR format) are generic practices that predate it.

> `awesome-cursor-skills` does not publish an explicit license. We credit the community work as inspiration, not a copy. If you are the maintainer and would prefer different attribution, please open an issue.

| Skill | Inspired by |
|-------|------------|
| `systematic-debugging` | awesome-cursor-skills community patterns |
| `writing-tests` | awesome-cursor-skills community patterns |
| `architecture-decision-records` | awesome-cursor-skills community patterns |

All other content in this kit is original.

### Cursor

This kit is an **unofficial** community project. It is not affiliated with or endorsed by Anysphere (Cursor). "Cursor" is a trademark of Anysphere, Inc.
