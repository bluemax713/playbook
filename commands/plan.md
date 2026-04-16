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

## Phase 3: Stress Test

Before presenting the plan for approval, pressure-test it. Scale the depth to the plan's complexity — a one-file change gets a quick paragraph, a multi-system feature gets the full treatment.

1. **Assumption audit** — List every assumption the plan makes. Validate each one against the actual code, docs, APIs, or data. Flag any that are unverified or risky.
2. **Risk war-game** — For each meaningful risk:
   - What specifically fails and what's the blast radius?
   - How likely is it?
   - Mitigation: what prevents it, or makes it self-healing / low-maintenance?
   - If it still happens: what's the recovery path?
3. **Build roadblock scan** — Anticipate errors and blockers you'll hit during implementation: missing dependencies, version conflicts, permission issues, API limits, edge cases, test gaps. For each, state your plan to get past it.

Fold the results into the plan:
- Drop any assumptions that turned out to be wrong and adjust the steps.
- Add a **Risks & Mitigations** summary at the end — a scannable table or bullet list showing each risk, its severity, and the mitigation. The user should see that you already thought through what could go wrong.

Present the hardened plan and WAIT for approval before making any changes.
Keep it concise — bullet points, not essays.
