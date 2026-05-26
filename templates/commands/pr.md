# /pr

Create a pull request for the current changes.

1. Run `git diff` (staged and unstaged) and `git log --oneline -5` to understand what changed.
2. Write a clear commit message following the project's convention (imperative, ≤72 chars subject, HEREDOC format per git-safety rule).
3. Stage and commit if there are uncommitted changes — only with explicit user confirmation.
4. Push the branch to the remote with `-u origin HEAD`.
5. Run `gh pr create` with:
   - A concise, descriptive title
   - A body covering: what changed, why, and a brief test plan
6. Return the PR URL when done.

If the branch is already up to date with the remote, skip the push step.
