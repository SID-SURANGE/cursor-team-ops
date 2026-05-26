---
name: pr-summary
description: Create a pull request with a clear title, summary, and test plan using the gh CLI. Use when the user asks to open a PR, create a pull request, "push and PR", or "submit for review". Analyzes all commits in the branch, not just the latest.
disable-model-invocation: true
---

# 📬 PR Summary

## Run these in parallel first
1. `git status` — confirm no uncommitted changes.
2. `git log [base-branch]...HEAD --oneline` — all commits that will be in the PR.
3. `git diff [base-branch]...HEAD` — full diff for context.
4. `git status` — check if branch tracks a remote (determines if push is needed).

Use `main` or `master` as the base branch unless the user specifies otherwise.

## Analyze ALL commits (not just the latest)
Identify: what changed, why it changed, and what a reviewer needs to verify.

## Draft
- **Title**: imperative, present tense, ≤60 chars, no trailing period.
- **Summary**: 1–3 bullet points — what and why.
- **Test plan**: checklist of steps to verify the change works.

## Create the PR
```bash
# Push if not already on remote
git push -u origin HEAD

# Create PR
gh pr create --title "your title" --body "$(cat <<'EOF'
## Summary
- bullet

## Test plan
- [ ] step
EOF
)"
```

Return the PR URL when done.

## Do not
- Force-push unless the user explicitly asks.
- Merge or delete branches without being asked.
- Summarize work you have not read — read the full diff first.
