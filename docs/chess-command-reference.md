# `/chess` Command — Reference Guide for Agents

> **Purpose of this doc:** Hand this to any AI agent (NanoClaw or otherwise) that works alongside Max Assoulin so it understands what `/chess` is, when to invoke it, how the intake and handoff work, and what the chess reasoning framework expects. This is not a user-facing spec — it's operational intelligence for agents.

---

## What `/chess` Is

`/chess` is a Claude Code slash command for **adversarial strategy analysis**. It is built for decisions where the outcome depends on what another party does in response to your moves — negotiations, competitive positioning, legal disputes, high-stakes financial decisions with a counterparty.

It is explicitly **not** a general planning tool. For implementation decisions without a real adversary, use `/plan`.

The core contract: **model the opponent rationally, trace the move tree honestly, and deliver a specific recommended line** — not a list of considerations, not hedged optionality, a concrete opening move with contingencies.

---

## When to Use `/chess`

Invoke `/chess` when all three are true:

1. **Real adversary present** — a person or party with competing interests and their own move set
2. **Outcome is move-dependent** — what they do in response to your move materially changes the result
3. **Stakes are material** — money, a key relationship, legal exposure, or a make-or-break decision

**Examples of `/chess` territory:**
- Negotiating a vendor contract where the other side has leverage
- Responding to a board member pushing for a direction you disagree with
- A competitive bid where you know who the other bidders are
- A legal dispute where the other party's next move shapes your options
- A fundraising conversation where the investor's motivation isn't fully visible

**Do not invoke `/chess` for:**
- Architecture tradeoffs, tool selection, implementation decisions → use `/plan`
- Decisions where you're the only actor and the "opponent" is just uncertainty → `/plan` with a risk war-game
- Situations where you don't know enough about the adversary to model them — flag this to Max and gather intel first

---

## Pre-flight: Does `/chess` Make Sense Here?

Before intake begins, assess the situation. Tell Max directly:

- **"Yes, /chess is the right call"** — if there's a clear adversary, move-dependent outcome, and material stakes
- **"/plan is the right tool here"** — if it's an implementation or tradeoffs decision with no real counterparty
- **"Borderline — here's why"** — if ambiguous, name what makes it so and ask Max to confirm

This check runs on Sonnet and takes seconds. Do not skip it — invoking `/chess` on a non-adversarial problem wastes significant token budget.

---

## Intake: Building the Chess Brief

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

## Common Failure Modes

| Failure | Why It's Bad | What to Do Instead |
|---|---|---|
| Invoking `/chess` on a non-adversarial decision | Wastes significant token budget on Opus reasoning | Pre-flight check routes to `/plan` instead |
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

> `/chess` = pre-flight to confirm an adversary exists → intake to build the brief → Opus 4.6 parallel session traces the move tree and models each opponent rationally → debrief artifact with a specific recommended line → return prompt brings it back to the primary session to act on.
