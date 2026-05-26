---
name: verify-this
description: Prove or disprove a claim with an evidence chain: baseline, treatment, commands run, and a verdict. Triggered by "verify this", "prove this works", "check if X is true".
---

# Skill: verify-this

## Purpose
Replace "I think it works" with a structured evidence chain. Prevents shipping assumptions and makes verification reproducible.

## Trigger phrases
- "verify this"
- "prove this works"
- "check if X is true"
- "is this actually correct"
- "validate this"

## Steps

### 1. State the claim
Write out the exact claim being verified in one sentence:
> "Claim: X causes Y when Z."

If the claim is implicit (e.g. "does this work?"), ask the user to confirm the specific assertion.

### 2. Establish baseline
- What existed / was true **before** the change or action in question?
- Record: relevant file contents, command output, test state, or observable behavior prior to treatment.
- If no baseline exists, note it explicitly — absence of a baseline is a risk.

### 3. Apply treatment
- Describe exactly what was changed or what action was taken.
- Run any commands needed to reproduce the state being verified.
- Record exact commands with output.

### 4. Collect evidence
For each piece of evidence, note:
| Evidence | Source | Supports / Contradicts claim |
|----------|--------|------------------------------|
| ... | ... | ... |

Evidence types in priority order:
1. Automated test output (highest weight)
2. Command output (build, lint, run)
3. File diff
4. Log output
5. Manual observation (lowest weight — note it as such)

### 5. Verdict
State one of:
- **Confirmed** — all evidence supports the claim with no contradictions.
- **Refuted** — at least one piece of evidence contradicts the claim; summarize why.
- **Uncertain** — evidence is incomplete or ambiguous; list what's missing.

### 6. Report format

```
Claim: <one-sentence claim>
Baseline: <what was true before>
Treatment: <what was done>
Evidence:
  - <evidence 1>
  - <evidence 2>
Verdict: Confirmed / Refuted / Uncertain
Reason: <one sentence>
```

## Output
A structured verification report (inline or as a file if the user requests it).
