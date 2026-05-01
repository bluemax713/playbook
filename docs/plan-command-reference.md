# `/plan` and `/chess` Commands — Reference Guide for Agents

> **Purpose of this doc:** Hand this to any AI agent (NanoClaw or otherwise) that works alongside Max Assoulin so it understands what `/plan` and `/chess` are, when to use each, how they think, and what they produce. This is not a user-facing spec — it's operational intelligence for agents.

---

## Two Commands, Two Domains

Max has two planning commands. Know which one to reach for:

| | `/plan` | `/chess` |
|---|---|---|
| **Use when** | Implementation decisions — what to build and how | Strategic decisions with a real adversary |
| **Adversary present?** | No — tradeoffs between approaches, not parties | Yes — a person or party with competing interests |
| **Core technique** | Assess options → harden direction → write steps | Opponent modeling + multi-move branch tracing |
| **Session model** | Primary session, Sonnet | Intake in primary (Sonnet), reasoning in parallel (Opus 4.6) |
| **Output** | Approved implementation plan | Debrief artifact + recommended line + contingencies |

**Routing rule:** If there's no real counterparty, use `/plan`. If the outcome depends on what another party does in response to your moves — and the stakes are material — use `/chess`.

---

## `/plan` — Structured Pre-Implementation Planning

`/plan` triggers structured planning before any code is written or files are changed. The core contract: **think before you act.** For any non-trivial or multi-file change, plan first, get Max's approval, then execute. Never plan and execute in the same motion without a checkpoint.

### When to Use `/plan`

**Always use for:**
- Any change touching **3 or more files**
- **New features** that require architectural decisions
- **Cross-layer work** (e.g., frontend + backend + database + automation together)
- Anything involving **external tool selection** (new APIs, services, packages)
- Tasks where **multiple valid approaches exist** and the tradeoffs matter
- **Refactors** that change interfaces, data shapes, or execution flow
- Any work where a wrong first step creates rework downstream

**Skip for:**
- Single-file fixes with a clear, obvious path
- Bug fixes where the cause is already known and the fix is localized
- Renaming, reformatting, or cosmetic changes
- Documentation updates
- Tasks where the approach is already agreed in the current conversation
- Decisions involving a real adversary with competing interests → use `/chess` instead

**Gray zone rule:** If you're unsure, ask: *"If I get this wrong, how bad is the rework?"* If the answer is "significant," plan first.

### The Mental Model: Three Phases

---

#### Phase 1 — Assess Complexity

**Goal:** Read the landscape, surface options, get alignment on direction before writing any steps.

- Read relevant files first: schemas, existing patterns, interfaces, config files
- Check `~/.claude/tech_stack.md` — **start with what's already in Max's stack before proposing anything new**
- If the task involves external tools or services, use Perplexity to get current data (pricing, APIs, limitations). Don't rely on training data for external tool evaluation — it goes stale.
- Identify 2–3 plausible approaches, not just one. Present with pros/cons in short, scannable sections.
- Flag the recommended approach and why. Wait for Max's approval before proceeding.
- Save the decision to `docs/decisions/YYYY-MM-DD-<topic>.md` if it's non-trivial.

**Perplexity discipline:**
- Use `perplexity_research` for deep tool evaluation
- Use `perplexity_search` or `perplexity_ask` for quick factual lookups
- Always tell Max when you're pulling from live web data vs. your own knowledge
- If results include training-data caveats, follow up with `search_recency_filter: "month"` — never hand Max stale results

**Tech stack discipline:**
- Consolidation is a **tiebreaker, not a constraint**
- If a new tool is clearly better, recommend it — explain what it replaces, why it wins, migration cost
- When a new tool is evaluated (even if not adopted), log a one-liner to `~/Documents/GitHub/consulting/inbox/stack-catalog-candidates.md`

---

#### Phase 2 — Harden the Direction

**Goal:** Stress-test the chosen direction before writing any implementation steps. Scale depth to complexity — a one-file change gets a quick paragraph; a multi-system feature gets the full treatment.

1. **Assumption audit** — list every assumption the direction makes. Validate each against actual code, docs, APIs, or data. Flag anything unverified or risky.
2. **Risk war-game** — for each meaningful risk: what specifically fails and what's the blast radius? How likely? What prevents it or makes it self-healing? What's the recovery path if it still happens?

Fold results back: drop wrong assumptions, adjust direction. Add a **Risks & Mitigations** summary before moving on.

---

#### Phase 3 — Implementation Steps

**Goal:** Write the execution plan once, correctly, with the direction already hardened.

1. **Scope** — what's in scope, what's NOT. State remaining assumptions.
2. **Steps** — ordered steps. For each:
   - What file(s) to change
   - What the change does
   - Build blockers to anticipate (missing dependencies, version conflicts, permission issues, API limits, edge cases) and how to get past each
   - How to verify it worked
3. **Dependencies** — what must happen in order vs. can be parallelized

Present the hardened plan and **wait for approval before making any changes.**

---

#### Execution (after approval)

- Follow the approved plan step-by-step in the approved sequence
- **Commit frequently** with clear, descriptive messages — don't batch into one giant commit
- After each material step, verify output before moving on — "it should work" is not verification
- If something unexpected changes the plan mid-execution, **stop and resurface** — don't silently adapt
- Never expand scope during execution. New ideas go on a list for later.

**If Max approves with modifications:** restate the modified plan before executing. Don't silently absorb a change and proceed.

---

### How the Plan Subagent Thinks

When `/plan` is invoked, it spins up a dedicated **Plan subagent** with read-only access to the codebase (Glob, Grep, LS, Read, NotebookRead, WebFetch, TodoWrite, WebSearch, BashOutput — no write tools). The planner cannot accidentally make changes while thinking.

The subagent:
- Does not have the main thread's conversational context unless briefed in the prompt
- Reads the codebase directly — does not guess at structure
- Returns a structured plan artifact back to the main thread
- Can run in parallel with other research agents when the task involves multiple independent domains

**Model:** Sonnet 4.6 default. Escalate to Opus 4.6 for complex architectural decisions, multi-step reasoning across large contexts, or financial modeling. Always tell Max before escalating.

---

## `/chess` — Adversarial Strategy Analysis

`/chess` is for decisions where the outcome depends on what another party does. It models opponent behavior, traces move sequences multiple steps deep, and produces a recommended line with contingencies. It runs intake in the primary session, then hands off to a parallel Opus 4.6 session for the heavy reasoning.

### When to Use `/chess`

Use when all three are true:
1. There is a real adversary — a person or party with competing interests and their own move set
2. The outcome depends on what that adversary does in response to your moves
3. The stakes are material — money, a key relationship, legal exposure, or a make-or-break decision

Examples: negotiations, competitive positioning, legal disputes, board dynamics, high-stakes vendor or partnership decisions.

### How `/chess` Works

**Pre-flight:** Before intake begins, `/chess` assesses whether the situation actually warrants it. If there's no real adversary, it tells Max to use `/plan` instead.

**Intake (primary session, Sonnet):** Conversational questions to build the chess brief:
- The situation, objective, and time horizon
- Each adversary: name/role, goals, motivations, aggression level, BATNA, constraints, what they know about Max's position
- Max's position: standing (stronger/equal/weaker), BATNA, non-negotiables, information held back
- The board: moves under consideration, what's already been said or done, definition of win/acceptable/loss

**Handoff:** Once intake is complete, `/chess` compiles everything into a self-contained handoff prompt — with the chess reasoning framework embedded verbatim — and presents it to Max to paste into a new terminal window. The parallel session runs on Opus 4.6 and does not invoke any commands.

**Chess session (parallel, Opus 4.6):** Works straight through without stopping:
1. Inhabits each adversary — models what they see, want, and would do in response to each move. Stays within rational human motivation — no mind-reading, no irrational escalations.
2. Traces branches 3–4 moves deep to labeled terminal states (favorable / acceptable / problematic)
3. Stresses the assumptions — flags where the analysis is weakest
4. Identifies leverage points — where moves shift terminal states or open/close options
5. Produces a recommended line with top contingency responses

**Output:**
- Writes debrief artifact to `docs/chess/YYYY-MM-DD-[topic].md`
- Displays the debrief in chat for real-time review
- Provides a return prompt Max pastes into the primary session to bring findings back
- Closes with: `Chess session complete. You can close this window.` — Max does not run `/end` in the chess session

---

## Interaction With Other Systems (both commands)

### ClickUp
Reference relevant task IDs in the plan. Update ClickUp status as execution begins. The plan itself doesn't need to live in ClickUp — the implementation does.

### n8n Workflows
- Always `get_workflow` before proposing changes — never push blind updates
- Show the current workflow structure and the proposed delta, not just the end state
- Activation requires Max's explicit approval — never implicit in a plan sign-off

### WORK_LOG.md
After a plan is approved and execution begins, the plan summary goes into WORK_LOG.md. For `/chess`, the primary session logs a reference to the debrief artifact path — the chess session itself does not write to WORK_LOG.

### Decisions Archive
Non-trivial architectural or design decisions → `docs/decisions/YYYY-MM-DD-<topic>.md`. Chess debriefs → `docs/chess/YYYY-MM-DD-<topic>.md`. Both referenced from WORK_LOG but not buried in session logs.

---

## Common Failure Modes to Avoid

| Failure | Why It's Bad | What to Do Instead |
|---|---|---|
| Planning and executing in the same response | Skips Max's approval gate | Hard stop between plan and execute |
| Vague plans ("update the config") | Different agent can't pick it up; Max can't approve what he can't read | Specify file path, key, value, and why |
| Only presenting one option | Looks like selling, not engineering | Always show 2–3 options with tradeoffs |
| Using `/plan` for adversarial decisions | Wrong tool — no opponent modeling | Route to `/chess` if there's a real counterparty |
| Using `/chess` for implementation decisions | Overkill — adds cost and complexity where tradeoffs analysis suffices | Route to `/plan` if there's no real adversary |
| Starting with a new tool before checking the existing stack | Adds complexity, cost, and cognitive load | Check `tech_stack.md` first |
| Using Perplexity training data for tool evaluation | May be months stale | Always hit live search for external tools |
| Silent scope creep during execution | Plan was approved; the expanded version wasn't | Surface new ideas, don't fold them in |
| Declaring success without verification | "Should work" is not evidence | Run the test, query, or check; show the output |
| Amending the plan mid-execution without telling Max | Approval was for a different plan | Stop, describe the change, get re-approval |
| Running `/end` in the chess parallel session | Wrong ceremony in the wrong session | Just close the terminal — primary session handles closeout |

---

## Quick Reference: Plan Quality Checklist

Before presenting a `/plan` to Max:

- [ ] At least 2–3 approaches were considered (even if one is obviously right)
- [ ] Strongest arguments **against** the chosen approach are named
- [ ] All file paths are explicit (no "update the relevant file")
- [ ] Data structures and interfaces are read from source, not assumed
- [ ] Execution sequence is ordered and dependencies are called out
- [ ] Parallelizable steps are labeled as such
- [ ] Risks and open questions are surfaced, not buried
- [ ] Verification checkpoints are defined for each material step
- [ ] External tool choices are grounded in current data (Perplexity)
- [ ] Existing stack was checked before proposing new tools
- [ ] n8n workflows were fetched before proposing changes (if applicable)

---

## Summary

> `/plan` = explore options, harden the direction, write steps once correctly, present to Max, get approval, execute exactly what was approved — no shortcuts, no scope creep, no silent adapts.

> `/chess` = intake the situation, model each adversary rationally, trace branches to terminal states, identify the best opening move and contingencies, deliver a debrief — then hand it back to the primary session to act on.
