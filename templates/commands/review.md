# /review

Run a quick AI review pass on all local changes before human code review.

1. Run `git diff main...HEAD --stat` to see which files changed.
2. Run `git diff main...HEAD` to read the full diff.
3. For each changed file, check:
   - No hardcoded secrets, tokens, or credentials.
   - No debug code (`console.log`, `print(`, `debugger`, `breakpoint()`).
   - No placeholder comments (`// TODO: implement this`, stub returns).
   - Logic matches the intent described in the commit message.
   - No unrelated changes bundled in (scope creep).
   - Tests exist for non-trivial logic (flag if missing, don't add automatically).
4. Summarize findings as a table:

| File | Issue | Severity |
|------|-------|----------|
| ...  | ...   | High / Med / Low |

5. If no issues found, say so in one line. Do not generate a long report for a clean diff.
