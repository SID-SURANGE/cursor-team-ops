---
name: writing-tests
description: Produce a test structure for any language: what to cover (happy path, edge cases, error paths), how to name tests, and what not to test. Triggered by "write tests for this", "what should I test", "writing-tests".
---

# 🧪 Skill: writing-tests

## Purpose
Produce well-structured, meaningful tests — not coverage theatre. Focus on what can break, not what's obvious. Works for any language or framework.

## Trigger phrases
- "write tests for this"
- "what should I test"
- "writing-tests"
- "add tests"
- "help me test this"

## Steps

### 1. Read the code under test
- Read the target function, class, or module in full.
- Identify: inputs, outputs, side effects, dependencies, error conditions.
- Note any existing tests to avoid duplication.

### 2. Identify test cases (before writing any code)
Enumerate test cases in three categories:

#### Happy path
- Typical valid inputs → expected outputs.
- At minimum one test that exercises the main purpose of the code.

#### Edge cases
Think about boundary conditions:
- Empty input (empty string, empty list, 0, null/None/undefined)
- Maximum / minimum values
- Single-element collections
- Duplicate values
- Unicode / special characters (for string handling)
- Floating-point precision (for numeric operations)
- Concurrent access (for shared state)

#### Error paths
- Invalid input types
- Out-of-range values
- Missing required fields
- Dependency failures (network down, DB unavailable) — use mocks/stubs
- Partial failures (one of many operations fails)

Present the list before writing code:
```
Tests for <function/class>:
Happy path:
  - [ ] <test case 1>
  - [ ] <test case 2>
Edge cases:
  - [ ] <test case>
Error paths:
  - [ ] <test case>
```
Ask the user to confirm or adjust before proceeding.

### 3. Naming convention
Use the pattern: `<unit>_<scenario>_<expected_outcome>`

Examples:
- `getUser_validId_returnsUser`
- `getUser_unknownId_throwsNotFound`
- `parseDate_emptyString_returnsNull`
- `processOrder_paymentFails_rollsBackInventory`

Adapt to the project's existing naming style if one is established.

### 4. Write the tests
- One assertion per test (where practical).
- No logic in test bodies — no loops, no conditionals. If you need a loop, write separate tests.
- Arrange / Act / Assert (AAA) structure.
- Mock external dependencies; test the unit in isolation.
- Use realistic but minimal test data — avoid production data.

### 5. What NOT to test
- Private/internal implementation details — test behaviour, not structure.
- Third-party library internals.
- Trivial getters/setters with no logic.
- Code that is already covered by a more integration-level test.

### 6. Coverage check
After writing tests, verify:
- Are all branches covered? (if/else, switch, try/catch)
- Are all public entry points covered?
- Is there at least one negative test (something that should fail or throw)?

### 7. Report
```
Tests written for: <target>
Total test cases: <n>
  Happy path: <n>
  Edge cases: <n>
  Error paths: <n>

Not covered (and why):
  - <item> — <reason>
```

## Guardrails
- Do not write tests that can only pass (e.g. `assert True`).
- Do not mock so aggressively that the test no longer tests anything real.
- If writing tests reveals a design problem (e.g. untestable code due to tight coupling), surface it — don't work around it silently.
