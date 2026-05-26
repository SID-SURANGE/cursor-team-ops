# /fix-issue [number]

Fetch a GitHub issue, implement a fix, and open a pull request.

1. Fetch the issue details: `gh issue view <number>`
2. Understand the problem. Ask the user for clarification if the issue description is ambiguous.
3. Find the relevant code using search tools (Grep, Glob, codebase search).
4. Implement the fix — minimal change that resolves the reported issue.
5. Run the project's test command to verify no regressions.
6. Commit with a message referencing the issue: `fix: <description> (closes #<number>)`.
7. Push and open a PR: `gh pr create` with title `fix: <description>` and body linking the issue.
8. Return the PR URL.

Do not modify unrelated code. Do not add features. Fix exactly the reported issue.
