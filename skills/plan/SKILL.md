---
name: plan
description: Structured planning before multi-file changes. Assesses complexity, brainstorms approaches with tradeoffs if needed, then produces a scoped implementation plan with steps, dependencies, and risks. Use before any non-trivial change.
---

Before making any changes, assess the task and create a structured plan.

**Self-contained.** Does not require `/start` to have been run.

---

## Routing check

Before starting, confirm this is the right command:
- **Real adversary with competing interests?** → `/chess` (Human Mode)
- **System or plan you need to stress-test before building?** → `/chess` (System Mode)
- **Multiple possible futures you're navigating?** → `/future`
- **Task to execute or decision to plan?** → You're in the right place.

---

## Phase 1: Assess Complexity (Sonnet, inline)

**First, clarify the task if needed.** Read what was asked. If the desired outcome, scope, or key constraints are unclear, ask before proceeding — 1–3 targeted questions in a single message. Once answered (or if the task is already clear), state the spec in one sentence: "We are [doing X] to [achieve Y], [constraint]." This anchors the rest of the plan.

Read all relevant files first. Then determine:
- **Is this straightforward?** (One obvious approach, clear requirements) → proceed directly to Phase 2 inline.
- **Are there meaningful tradeoffs?** (Multiple approaches, architectural choices, unclear requirements) → Brainstorm first:
  - Present 2-3 approaches with pros/cons in short, scannable sections
  - Run the council inline on Sonnet: pick 4 contextually relevant advisors — real people whose thinking applies to this type of decision. Name them, one sentence each on why they're relevant. Have each weigh in on the approaches in 2-3 sentences. Let them disagree. Synthesize what the council surfaces before making your recommendation.
  - Flag which approach you'd recommend and why (incorporating council input)
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

Spawn a Sonnet subagent (`model: 'sonnet'`): *"Read [absolute path], then execute exactly as instructed. Do not ask questions. Do not invoke slash commands. Append all output under ## Output in that file."*

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

**For complex plans (subagent path):** When the user approves and execution begins, write the implementation steps as a markdown checkbox list under `## Active Plan: [task name]` in WORK_LOG.md. Tick off each step as it completes — this persists progress across turns and context compression.

Keep it concise — bullet points, not essays.
