Before making any changes, assess the task and create a structured plan.

## Phase 1: Assess Complexity

Read all relevant files first. Then determine:
- **Is this straightforward?** (One obvious approach, clear requirements) → Skip to Phase 2.
- **Are there meaningful tradeoffs?** (Multiple approaches, architectural choices, unclear requirements) → Brainstorm first:
  - Present 2-3 approaches with pros/cons in short, scannable sections
  - **For high-stakes decisions** (architecture choices, irreversible actions, multi-system impact, high cost-of-being-wrong): run a **branch trace** — trace each option forward 2-3 moves to its terminal state. Compare endpoints, not just opening positions:
    ```
    Option A → requires X → leads to Y  →  Terminal: [favorable / acceptable / problematic]
                           → Risk branch: if Z happens instead  →  Terminal: [recovery cost]
    Option B → ...
    ```
    Max 3 branches, max 3 moves deep. Label each terminal state. Recommend based on where each path actually *lands*, not just how it starts.
  - Flag which approach you'd recommend and why
  - Wait for approval of a direction before proceeding
  - Save the decision to `docs/decisions/YYYY-MM-DD-<topic>.md` if it's non-trivial

## Phase 2: Harden the Direction

Before writing implementation steps, stress-test the chosen direction. Scale depth to complexity — a one-file change gets a quick paragraph, a multi-system feature gets the full treatment.

1. **Assumption audit** — List every assumption the direction makes. Validate each one against actual code, docs, APIs, or data. Flag any that are unverified or risky.
2. **Risk war-game** — For each meaningful risk:
   - What specifically fails and what's the blast radius?
   - How likely is it?
   - Mitigation: what prevents it, or makes it self-healing?
   - If it still happens: what's the recovery path?

Fold the results back: drop wrong assumptions and adjust the direction before writing steps. Add a **Risks & Mitigations** summary — a scannable table or bullet list.

## Phase 3: Implementation Steps

Direction is hardened. Write the execution plan once, correctly.

1. **Scope** — What's in scope, what's NOT. State remaining assumptions.
2. **Steps** — Ordered steps. For each:
   - What file(s) to change
   - What the change does
   - Build blockers to anticipate: missing dependencies, version conflicts, permission issues, API limits, edge cases — and how to get past each
   - How to verify it worked
3. **Dependencies** — What must happen in order vs. can be parallelized.

Present the hardened plan and WAIT for approval before making any changes.
Keep it concise — bullet points, not essays.
