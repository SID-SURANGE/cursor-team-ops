# Hooks

Hooks are shell scripts that Cursor executes automatically at specific lifecycle events. The team kit ships two hooks installed to `~/.cursor/` by `install.sh`.

---

## How hooks work

Cursor reads a `hooks.json` file and runs the listed scripts when the matching event fires. Each script receives a JSON payload on stdin and must print a JSON response to stdout.

### hooks.json schema

```json
{
  "version": 1,
  "hooks": {
    "<event>": [
      {
        "command": "<path-to-script>",
        "matcher": "<optional-regex>",
        "failClosed": false
      }
    ]
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `command` | string | ✅ | Path to the script. For machine hooks (`~/.cursor/hooks.json`), paths are relative to `~/.cursor/`. For project hooks (`.cursor/hooks.json`), paths are relative to the repo root. |
| `matcher` | string | ❌ | Regex applied to the event payload before running the script. For `beforeShellExecution`, it matches against the shell command string. If omitted, the script runs on every event of that type. |
| `failClosed` | boolean | ❌ | If `true`, a script crash or non-zero exit blocks the action. If `false` (default), a crash allows the action to proceed. Prefer `false` for guard hooks to avoid locking users out on script errors. |

---

## Supported events

| Event | When it fires | Stdin payload |
|-------|--------------|---------------|
| `beforeShellExecution` | Before the agent runs any shell command | `{"command": "<shell command string>"}` |
| `sessionStart` | When a new Cursor agent session begins | `{}` |

---

## Response format

Scripts must print a single JSON object to stdout and exit 0.

### `beforeShellExecution` responses

| Permission | Effect |
|-----------|--------|
| `allow` | Command proceeds without interruption. |
| `ask` | Cursor pauses and shows `user_message` to the user before continuing. |
| `deny` | Command is blocked. `user_message` is shown to the user; `agent_message` is fed back to the agent. |

```json
{ "permission": "allow" }

{ "permission": "ask",  "user_message": "...", "agent_message": "..." }

{ "permission": "deny", "user_message": "...", "agent_message": "..." }
```

### `sessionStart` responses

Return additional context to inject into the session:

```json
{ "additional_context": "..." }
```

---

## Installed hooks

### `git-guard.sh` — `beforeShellExecution`

Intercepts shell commands that match `git|rm\s+-r` and enforces the team's git-safety rule:

| Command pattern | Action |
|----------------|--------|
| `git push --force` / `-f` to `main` or `master` | **Deny** — blocked outright |
| `git push --force` / `-f` to any other branch | **Ask** — user must confirm |
| `git reset --hard` | **Ask** — user must confirm |
| `git … --no-verify` / `--no-gpg-sign` | **Ask** — user must confirm |
| `rm -rf /` or `rm -rf ~` (root/home) | **Deny** — blocked outright |
| Everything else | **Allow** |

### `session-context.sh` — `sessionStart`

Reads `~/.cursor/.team-kit-version` and injects a context string listing the active kit version, all always-on rules, and available skills. This ensures the agent knows the kit is loaded even when project `.cursor/` files are not present.

---

## Adding a new hook

> Hooks are maintainer-only. See [CONTRIBUTING.md](../CONTRIBUTING.md).

1. Write your script in `hooks/<name>.sh`. Add a comment header identifying the event and install path (see existing scripts for the pattern).
2. Make it executable: `chmod +x hooks/<name>.sh`.
3. Add an entry to `hooks.json` under the appropriate event key.
4. Re-run `install.sh` (or `install.ps1`) to push the change to `~/.cursor/`.
5. Test by triggering the event in Cursor and verifying the response.

### Testing a hook locally

```bash
# Simulate a beforeShellExecution call
echo '{"command":"git push --force origin main"}' | bash hooks/git-guard.sh

# Simulate a sessionStart call
bash hooks/session-context.sh
```

Expected: a valid JSON object printed to stdout, exit code 0.

---

## Project-level hooks

You can add a `hooks.json` at the repo root (or `.cursor/hooks.json`) for project-specific guards. Paths in that file are relative to the repo root.

```json
{
  "version": 1,
  "hooks": {
    "beforeShellExecution": [
      {
        "command": ".cursor/hooks/my-project-guard.sh",
        "matcher": "deploy|publish",
        "failClosed": false
      }
    ]
  }
}
```

Project hooks stack with machine hooks — both fire when the matcher matches.
