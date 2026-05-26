# Community Skills — Attributions

This file records attribution for community skills whose development was informed
by external open-source work. All skills listed here are **independently written**
original works — no text, code, or content was copied from the referenced sources.
Attribution is provided out of respect for the community members whose published
work informed the approach.

---

## agent-skills — Addy Osmani

**Source:** https://github.com/addyosmani/agent-skills
**Author:** Addy Osmani and contributors
**License:** MIT License — Copyright (c) 2025 Addy Osmani

The following skills in `skills/community/` were informed by workflow patterns
and structural approaches published in `agent-skills`:

| Skill | What was informed by the source |
|-------|---------------------------------|
| `spec-driven-development` | Spec-before-code gated workflow structure (Specify → Plan → Tasks → Implement) |
| `security-hardening` | Boundary system pattern (Always / Ask First / Never), pre-deployment checklist structure |
| `ci-cd-pipeline` | Quality gate ordering, CI failure feedback loop, anti-rationalization table structure |

**What was NOT taken:** No prose, no sentences, no code examples, no YAML snippets
were copied from the source. The engineering practices themselves (OWASP Top 10,
GitHub Actions, spec-driven development) are publicly documented industry standards
that predate the source repository.

**MIT License notice (as required):**

> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.

---

*To add attribution for a new community skill, open a PR updating this file.*
