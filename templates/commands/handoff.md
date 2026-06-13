# 📋 /handoff

Generate a structured handoff document capturing session progress, failed attempts, and next steps.

1. Run `git log --oneline -10` and `git status` to capture current state.
2. Review the conversation history to identify:
   - What was the original goal?
   - What was completed? (reference files and line numbers)
   - What was attempted but failed, and why?
   - What is still open or unresolved?
3. Write `HANDOFF.md` to the repo root with:
   - **Goal** — one sentence
   - **Status** — Completed / In Progress / Blocked
   - **What was done** — bullet list with file references
   - **What failed** — table of approach + root cause
   - **Open issues** — checklist of unresolved items
   - **Recommended next steps** — ordered, concrete actions
   - **Relevant files** — paths with one-line descriptions
4. Reference existing files and commit SHAs rather than duplicating content.
5. Report: file written, key open issues, and the single most important next step.
