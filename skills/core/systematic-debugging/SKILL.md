---
name: systematic-debugging
description: Structured hypothesis → minimal reproduction → experiment → evidence → verdict loop. Prevents random trial-and-error. Triggered by "debug this", "I can't figure out why", "systematic-debugging".
---

# Skill: systematic-debugging

## Purpose
Replace random trial-and-error with a disciplined loop: form a hypothesis, run the smallest possible experiment, collect evidence, and reach a verdict. Keeps debug sessions focused and reproducible.

## Trigger phrases
- "debug this"
- "I can't figure out why"
- "systematic-debugging"
- "help me debug"
- "why is this failing"
- "this doesn't work and I don't know why"

## Steps

### 1. Define the problem precisely
Write a one-sentence problem statement:
> "When X happens, Y occurs instead of Z."

If the user's description is vague, ask:
- What is the expected behaviour?
- What is the actual behaviour?
- When did it last work correctly (if ever)?
- What changed since it last worked?

### 2. Gather context (read before guessing)
- Read the relevant source files.
- Check logs, error messages, or stack traces in full — don't truncate.
- Check recent git history for the affected area: `git log --oneline -10 -- <file>`.
- Check open issues or TODOs in the file.

### 3. Form hypotheses
List 2–4 plausible causes ranked by likelihood:

| # | Hypothesis | Likelihood | How to test |
|---|-----------|------------|-------------|
| 1 | ... | High | ... |
| 2 | ... | Med | ... |
| 3 | ... | Low | ... |

Start with the most likely. Do not test all hypotheses at once.

### 4. Build the minimal reproduction
- Reduce the failing case to the smallest input/state that still triggers the bug.
- Isolate: remove unrelated code paths, external calls, or data.
- If you can write a failing test that captures the reproduction, do it — it becomes your success criterion.

### 5. Experiment
For each hypothesis (highest likelihood first):
1. State what you expect to observe if the hypothesis is correct.
2. Run the experiment (add a log line, change a value, call a function in isolation).
3. Record the actual output.
4. Compare: does the output match the prediction?

Stop when the first hypothesis is **confirmed** or **refuted** with evidence, then move to the next.

### 6. Verdict and fix

Once the root cause is confirmed:
- Write the fix.
- Verify the minimal reproduction no longer triggers the bug.
- Run the full test suite to check for regressions.
- Remove any temporary debug logs or prints added during investigation.

### 7. Report

```
Problem: <one-sentence description>

Root cause: <confirmed hypothesis>
Evidence:
  - <evidence 1>
  - <evidence 2>

Fix: <what was changed and why>

Verification:
  - Reproduction case: ✓ no longer fails
  - Test suite: ✓ / ✗ (n passed, n failed)
```

## Guardrails
- Never apply a fix before confirming the root cause with evidence.
- If the reproduction can't be made minimal within 10 minutes, stop and describe the blocker — don't keep narrowing indefinitely.
- If the fix requires a design change rather than a simple correction, surface it as a separate task.
