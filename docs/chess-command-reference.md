# `/chess` Command — Reference Guide for Agents

> **Purpose of this doc:** Hand this to any AI agent (NanoClaw or otherwise) that works alongside Max Assoulin so it understands what `/chess` is, when to invoke it, how the intake and reasoning frameworks work, and what each mode produces. This is not a user-facing spec — it's operational intelligence for agents.

---

## What `/chess` Is

`/chess` is a Claude Code slash command for **multi-move depth analysis**. It has two modes:

- **Human Mode** — for decisions where the outcome depends on what another party does in response to your moves. Runs as a parallel Opus 4.6 session. Produces a debrief with a recommended line and contingencies.
- **System Mode** — for technical plans where there's no human adversary but the system/environment will respond to every move. Runs inline. Produces a numbered attack on assumptions with verdicts and a concise list of required changes.

It is explicitly **not** a general planning tool. For pure tradeoffs decisions with no adversary and no system to stress-test, use `/plan`.

---

## When to Use `/chess`

**Human Mode** — invoke when all three are true:
1. **Real adversary present** — a person or party with competing interests and their own move set
2. **Outcome is move-dependent** — what they do in response to your move materially changes the result
3. **Stakes are material** — money, a key relationship, legal exposure, or a make-or-break decision

**Examples:** Negotiating a vendor contract, responding to a board member, a competitive bid, a legal dispute, a fundraising conversation where the investor's motivation isn't visible.

**System Mode** — invoke when:
- There's a technical plan, implementation, or fix being challenged
- The question is: what could break, and how does the system respond to each move?
- There's no human whose intent needs to be modeled

**Examples:** Building a watchdog script, deploying infrastructure changes, migrating a database, rolling out a system change with dependencies that could fail in non-obvious ways.

**Route to `/plan` instead when:** No adversary, no system to stress-test — just a tradeoffs or implementation decision.

---

## Pre-flight: Route the Situation

Three routes. Assess before doing anything else. Tell Max directly:

- **"Human Mode — /chess is the right call"** — clear adversary, move-dependent outcome, material stakes
- **"System Mode — let me stress-test this"** — technical plan, no human adversary, system response is the unknown
- **"/plan is the right tool here"** — pure tradeoffs decision, no adversary, no system to attack
- **"Borderline — here's why"** — if ambiguous, name what makes it so and ask Max to confirm

This check runs on Sonnet and takes seconds. Do not skip it.

---

## Human Mode

### Intake: Building the Chess Brief

Intake runs in the **primary session on Sonnet**. Ask questions conversationally — not as a numbered list. Group related questions naturally. Use follow-ups where an answer is thin. The goal is a complete picture before the chess engine runs, so the parallel session can work without stopping.

### What to gather

**The situation**
- What is the decision, negotiation, or scenario?
- What outcome is Max trying to achieve?
- What's the time horizon? (One-time event, ongoing relationship, hard deadline?)
- What's already been said or done that constrains the situation?

**For each adversary**
- Who are they? (Name, role, organization, relationship to Max)
- What do they want most — and what are their secondary interests?
- What are their motivations and incentives? (Financial, ego, power, relationship, legal, other)
- How aggressive or passive are they likely to be?
- What's their **BATNA** — their best alternative if this doesn't go their way?
- What constraints do they operate under? (Budget, authority limits, approvals needed, external pressures)
- What do they likely know about Max's position?

**Max's position**
- Is he stronger, equal, or weaker than the adversary right now?
- What's his **BATNA**?
- What is he not willing to concede?
- What information is he holding back — and what does the adversary probably assume about him?

**The decision**
- What moves is Max currently considering?
- What counts as a win? An acceptable outcome? A loss?

### Before generating the handoff

Read the full brief back to Max and confirm it's accurate. Ask if anything is missing or wrong. A gap in the brief is a gap in the analysis — don't proceed with incomplete adversary profiles.

---

## Generating the Handoff Prompt

Once intake is confirmed, compile everything into a **self-contained handoff prompt**. This prompt is what runs in the parallel chess session — it must contain everything the chess engine needs. No commands are invoked in the parallel session; the reasoning framework is embedded verbatim in the prompt.

Fill in all placeholders with real values:
- `[REPO_PATH]` — the current working directory (absolute path)
- `[YYYY-MM-DD]` — today's date
- `[topic-slug]` — a short descriptor derived from the situation (e.g., `hilldun-negotiation`, `board-vote`, `vendor-renewal`)

Create `docs/chess/` in the current project if it doesn't exist.

Present the completed prompt to Max in a clearly labeled block:

> **Open a new terminal window and paste this entire block:**

---

### The Embedded Chess Reasoning Framework

The handoff prompt wraps the intake brief with the following framework, verbatim. The chess session follows this without deviation.

---

**Preamble (inject at top of handoff prompt):**

> You are running a chess-style adversarial analysis. Intake is complete — all context is below. Your job is to think several moves ahead, model each adversary's rational behavior, and produce a debrief Max can act on. Do not ask questions. Do not invoke any slash commands. Run straight through.
>
> Run on Opus 4.6 (`claude-opus-4-6`). Do not switch models.

---

**Step 1 — Inhabit each adversary**

For each adversary, build their internal model: what do they see, what do they want most, what are they afraid of? For each move Max is considering, think through what that adversary would rationally do in response.

Stay strictly within rational human motivation. Model what a reasonable person in their position — with their specific incentives, constraints, and information — would actually do. No mind-reading. No irrational escalations. No assuming they'll cooperate without reason. Flag explicitly where assumptions about them are weak.

**Step 2 — Trace the branches**

For each move Max is considering, trace the likely sequence of responses 3–4 moves deep, or until the path reaches a clearly labeled terminal state. Prune branches that are implausible given the adversary's model.

Format:
```
Max's move → Adversary response → Max's counter → Their counter → Terminal: [favorable / acceptable / problematic]
                               → Risk branch: if [X] instead  → Terminal: [recovery cost]
```

**Step 3 — Stress the assumptions**

For each branch, name the assumptions it rests on. Which are well-grounded? Which are guesses? Where is the analysis most fragile? Flag adversary behaviors you're most uncertain about.

**Step 4 — Identify leverage**

Where in the move tree can a terminal state be shifted? What moves create future options vs. close them down? What piece of information — if Max had it — would change the picture most?

**Step 5 — Recommended line**

State the recommended opening move clearly. Explain why it outperforms the alternatives across the terminal states. Include the top 2 contingency responses for the most likely adversary deviations.

Be specific: *"Open with X. If they respond with Y, do Z. If they respond with W instead, do V."*

---

## Output: What the Chess Session Produces

The parallel session surfaces reasoning in chat as it works — Max can watch in real time. At the end, it:

1. **Writes the debrief artifact** to `[REPO_PATH]/docs/chess/[YYYY-MM-DD]-[topic-slug].md`
   - Structure: Situation → Adversary models → Move tree → Recommended line → Contingencies → Assumption flags
   - Creates the directory if it doesn't exist

2. **Displays the full debrief in chat** for real-time review

3. **Displays a return prompt** Max pastes into the primary session:
   ```
   Chess debrief complete. Read the analysis at [REPO_PATH]/docs/chess/[YYYY-MM-DD]-[topic-slug].md
   and pull the recommended line and top contingencies into our working context so we can decide next steps.
   ```

4. **Closes with:**
   ```
   Chess session complete. You can close this window.
   (Do not run /end — the primary session handles closeout.)
   ```

---

## What Happens After the Debrief

When Max pastes the return prompt into the primary session:

- Read the debrief artifact at the specified path
- Pull the recommended line and top contingencies into context
- Present them clearly and ask Max how he wants to proceed
- If the situation has evolved since intake, note what may have changed and whether the recommended line still holds

The chess debrief is an input to a decision, not the decision itself. Max decides what to do with it.

---

## Session and Logging Rules

| Question | Answer |
|---|---|
| Does the chess session run `/end`? | No — Max just closes the terminal |
| Does the chess session write to WORK_LOG? | No — that belongs to the primary session |
| Does the primary session log the chess work? | Yes — a brief reference to the debrief artifact path in WORK_LOG |
| Where do chess debriefs live? | `docs/chess/YYYY-MM-DD-[topic].md` in the current project repo |
| Model for intake | Sonnet 4.6 (primary session) |
| Model for chess engine | Opus 4.6 (`claude-opus-4-6`) hardcoded — do not switch |

---

---

## System Mode

### Intake

If the system, plan, and constraints are already established in the conversation, skip directly to the stress-test. Only ask for information that's genuinely missing — don't re-interview Max if you already have the answers.

If context is thin, ask conversationally: what's being built/fixed/changed, what the current system looks like, what's already decided and constraining the plan, and what counts as an acceptable vs. unacceptable failure.

### Stress-Test Framework

Run **inline on Sonnet** by default. Escalate to **Opus 4.6 inline** (no parallel session) when the system is complex enough that a shallow pass would miss real risks — multiple interacting services, deep dependency chains, complex state machines.

**Step 1 — Map the assumptions.** List every implicit "this works if..." in the plan — environment, dependencies, timing, state, permissions, failure behavior.

**Step 2 — Attack each vector.** For each assumption: state the risk, reason through the system's actual behavior (not the happy path), and give a verdict:
- ✅ — assumption holds
- ⚠️ → [specific mitigation] — risk is real but manageable; state the required change
- ❌ — plan-breaker; must resolve before building

Don't pad. Depth only where there's actual risk.

**Step 3 — Surface what changed.** Only the ⚠️ and ❌ items that require action. Brief and specific.

**Step 4 — Ready to build?** State whether the plan is sound as-is or needs N changes first. Offer to incorporate them and proceed.

### Session and Logging Rules for System Mode

| Question | Answer |
|---|---|
| Does System Mode run a parallel session? | No — inline only |
| Model default | Sonnet 4.6 inline |
| Escalation | Opus 4.6 inline (no parallel) for complex systems |
| Does it write a debrief artifact? | No — changes are incorporated directly into the plan |
| Does it write to WORK_LOG? | No — primary session handles that |

---

## Common Failure Modes

| Failure | Why It's Bad | What to Do Instead |
|---|---|---|
| Invoking Human Mode on a technical problem with no adversary | Wastes Opus token budget modeling intent that doesn't exist | Pre-flight routes to System Mode or `/plan` |
| Skipping the pre-flight check | Max may not realize `/plan` was the right tool | Always assess before intake |
| Incomplete adversary profile in intake | Chess engine models a phantom, not the real opponent | Gather intel before proceeding; flag gaps to Max |
| Generating the handoff before confirming intake | Errors compound in the parallel session — can't course-correct mid-run | Read back the brief, get confirmation |
| Chess session invokes a slash command | Circular dependency; commands assume a fresh intake | All rules are embedded in the handoff prompt — no commands needed |
| Chess session writes to WORK_LOG | Interleaves with the primary session's record | Chess session writes debrief artifact only |
| Running `/end` in the chess session | Wrong ceremony, wrong session | Close the terminal; primary session handles closeout |
| Presenting a "list of considerations" as the output | Not actionable — Max needs a move, not a menu | Always produce a recommended line with a specific opening move |
| Modeling adversaries beyond rational human behavior | False confidence — the analysis looks rigorous but isn't grounded | Stay within what a reasonable person in their position would actually do |

---

## Summary: The One-Line Version

> `/chess` = pre-flight routes to Human Mode or System Mode → **Human Mode:** Opus 4.6 parallel session traces the move tree and models each opponent rationally → debrief artifact with a specific recommended line → return prompt brings it back to primary session → **System Mode:** inline Sonnet attacks every assumption in the plan → verdicts + required changes → ready to build.
