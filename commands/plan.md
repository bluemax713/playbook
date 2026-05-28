Before making any changes, assess the task and create a structured plan.

**Self-contained.** Does not require `/start` to have been run.

---

## Phase 1: Assess Complexity (Sonnet, inline)

Read all relevant files first. Then determine:
- **Is this straightforward?** (One obvious approach, clear requirements) → proceed directly to Phase 2 inline.
- **Are there meaningful tradeoffs?** (Multiple approaches, architectural choices, unclear requirements) → Brainstorm first:
  - Present 2-3 approaches with pros/cons in short, scannable sections
  - Flag which approach you'd recommend and why
  - Wait for approval of a direction before proceeding
  - Save the decision to `docs/decisions/YYYY-MM-DD-<topic>.md` if it's non-trivial

Once the direction is approved, assess whether the plan warrants a subagent:
- **Simple plan** (single file, clear scope, low risk surface) → continue inline for Phases 2+3
- **Complex plan** (multi-file, architectural choices, meaningful risk surface, current session context is already heavy) → spawn a Sonnet subagent for Phases 2+3

---

## Phase 2: Harden the Direction

**Simple plans — inline (Sonnet):**

Before writing implementation steps, stress-test the chosen direction.

1. **Assumption audit** — List every assumption the direction makes. Validate each one against actual code, docs, APIs, or data. Flag any that are unverified or risky.
2. **Risk war-game** — For each meaningful risk:
   - What specifically fails and what's the blast radius?
   - How likely is it?
   - Mitigation: what prevents it, or makes it self-healing?
   - If it still happens: what's the recovery path?

Fold the results back: drop wrong assumptions and adjust the direction before writing steps. Add a **Risks & Mitigations** summary — a scannable table or bullet list.

**Complex plans — Sonnet subagent (follow `/handoff` pattern):**

Write a brief to `docs/plans/YYYY-MM-DD-[slug].md` containing:
- The approved direction and all relevant context (file paths, schemas, APIs, constraints)
- The Phase 2+3 framework below
- Instruction to return the complete hardened plan in its response

Show the user a short summary of the direction and context captured. Confirm before spawning.

Spawn a Sonnet subagent (`model: 'sonnet'`): *"Read [absolute path] in full, then execute exactly as instructed. Do not ask questions. Do not invoke slash commands. Append all output under ## Output in that file."*

When the subagent returns, present the hardened plan to the user and wait for approval before making any changes.

---

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
