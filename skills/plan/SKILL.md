---
name: plan
description: Structured planning before multi-file changes. Assesses complexity, brainstorms approaches with tradeoffs if needed, then produces a scoped implementation plan with steps, dependencies, and risks. Use before any non-trivial change.
---

Before making any changes, assess the task and create a structured plan.

## Phase 1: Assess Complexity

Read all relevant files first. Then determine:
- **Is this straightforward?** (One obvious approach, clear requirements) → Skip to Phase 2.
- **Are there meaningful tradeoffs?** (Multiple approaches, architectural choices, unclear requirements) → Brainstorm first:
  - Present 2-3 approaches with pros/cons in short, scannable sections
  - Flag which approach you'd recommend and why
  - Wait for approval of a direction before proceeding to Phase 2
  - Save the decision to `docs/decisions/YYYY-MM-DD-<topic>.md` if it's non-trivial

## Phase 2: Implementation Plan

1. **Scope** — What's in scope, what's NOT. State assumptions.
2. **Steps** — Ordered steps. For each:
   - What file(s) to change
   - What the change does
   - What could go wrong
   - How to verify it worked
3. **Dependencies** — What must happen in order vs. can be parallelized.
4. **Risks** — Highest-risk changes and rollback plan.

Present the plan and WAIT for approval before making any changes.
Keep it concise — bullet points, not essays.
