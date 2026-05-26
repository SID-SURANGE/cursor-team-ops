---
name: fix-merge-conflicts
description: Resolve conflict markers, explain what each side was doing and what was picked, then verify the result builds/tests pass. Triggered by "fix merge conflicts", "resolve conflicts", "fix this conflict".
---

# Skill: fix-merge-conflicts

## Purpose
Resolve Git conflict markers systematically: understand both sides before picking, explain every decision, and verify the result is coherent before marking resolved.

## Trigger phrases
- "fix merge conflicts"
- "resolve conflicts"
- "fix this conflict"
- "help me merge this"

## Steps

### 1. Inventory all conflicts
```bash
git diff --name-only --diff-filter=U
```
List every conflicted file. Do not start resolving until you have the full list.

### 2. For each conflicted file

#### a. Read the conflict markers
Each conflict has this shape:
```
<<<<<<< HEAD (current branch — "ours")
<our version>
=======
<their version>
>>>>>>> feature/branch-name (incoming — "theirs")
```

#### b. Understand both sides
Before picking, answer:
- What was **ours** trying to do?
- What was **theirs** trying to do?
- Are the two changes **independent** (can merge both) or **mutually exclusive** (must pick one)?
- Is there a **semantic conflict** even if there's no textual one nearby?

#### c. Resolve
Choose one of:
| Strategy | When to use |
|----------|-------------|
| **Keep ours** | Their change is superseded by ours or already incorporated |
| **Keep theirs** | Their change is correct and ours is stale |
| **Merge both** | Independent changes — combine them |
| **Write new** | Neither version is right after the merge context — craft a correct result |

Remove all `<<<<<<<`, `=======`, `>>>>>>>` markers after resolving.

#### d. Document the decision
After resolving, note:
```
<filename>:<approx line>
  Ours: <one sentence what our side did>
  Theirs: <one sentence what their side did>
  Picked: <ours / theirs / merged / rewritten>
  Reason: <one sentence>
```

### 3. Stage resolved files
```bash
git add <resolved-file>
```

### 4. Verify
After all conflicts are resolved:
```bash
# Build check (adapt to project)
# e.g. npm run build / cargo build / make / python -m py_compile ...

# Test check
# e.g. npm test / pytest / go test ./... ...
```

If build or tests fail after resolution, investigate — a resolution may have introduced a semantic conflict even though the markers are gone.

### 5. Complete the merge
```bash
git merge --continue
# or git rebase --continue if rebasing
```

### 6. Report

```
Conflicts resolved: <count> files

Resolution summary:
| File | Strategy | Reason |
|------|----------|--------|
| ...  | ...      | ...    |

Build: ✓ / ✗
Tests: ✓ / ✗ (n passed, n failed)
```

## Guardrails
- Never auto-accept "ours" or "theirs" wholesale without reading both sides.
- If the conflict involves generated files (lock files, compiled output) — prefer the incoming version and regenerate locally.
- If the conflict is in a migration file, stop and ask the developer — migration conflicts are high-risk.
- If build/tests fail post-resolution, do not commit. Surface the failure and debug first.
