Adversarial strategy analysis — multi-move, opponent-modeled, branch-traced. Runs intake in the primary session (Sonnet), then generates a self-contained handoff prompt for a parallel Opus 4.6 session that does the heavy reasoning.

---

## Pre-flight: Is this a /chess situation?

Before intake, assess the situation. Ask yourself:

- Is there a real adversary — a person or party with competing interests and their own move set?
- Does the outcome depend on what that adversary does in response to your moves?
- Are the stakes material — money, a key relationship, legal exposure, or a make-or-break decision?

**All three yes:** Confirm to the user that /chess is the right call and proceed to intake.

**No real adversary:** Tell the user directly — *"/plan is the right tool here — this is a tradeoffs decision, not a strategic scenario with a counterparty."* Offer to invoke /plan instead.

**Borderline:** Name what makes it ambiguous. Ask the user to confirm before proceeding.

The pre-flight runs on Sonnet. Do not begin intake until the situation is confirmed as a /chess scenario.

---

## Intake: Build the chess brief

Run this in the primary session on Sonnet. Ask these questions conversationally — not as a numbered list. Group related questions naturally. Use follow-ups where the answer is thin. The goal is a complete picture before the chess engine runs, so the parallel session can work without stopping.

**The situation**
- What is the decision, negotiation, or situation you're navigating?
- What outcome are you trying to achieve?
- What's the time horizon? (One-time event, ongoing relationship, hard deadline?)
- What's already been said or done that constrains the situation?

**For each adversary**
- Who are they? (Name, role, organization, relationship to you)
- What do they want most — and what are their secondary interests?
- What are their motivations and incentives? (Financial, ego, power, relationship, legal, other)
- How aggressive or passive are they likely to be?
- What's their BATNA — their best alternative if this doesn't go their way?
- What constraints do they operate under? (Budget, authority limits, approvals needed, external pressures)
- What do they likely know about your position?

**Your position**
- Are you stronger, equal, or weaker than the adversary right now?
- What's your BATNA?
- What are you not willing to concede?
- What information are you holding back, and what do they probably assume about you?

**The decision**
- What moves are you currently considering?
- What counts as a win? An acceptable outcome? A loss?

Once intake is complete, read the summary back to the user and confirm it's accurate before generating the handoff prompt.

---

## Generate the handoff prompt

Compile everything from intake into a self-contained chess brief. Fill in all [BRACKETS] with real values — current date, actual repo path (use the current working directory), and a short topic slug derived from the situation (e.g., `hilldun-negotiation`, `board-vote`, `vendor-renewal`).

Create the `docs/chess/` directory in the current project if it doesn't already exist.

Present the completed handoff prompt to the user in a clearly labeled block:

> **Open a new terminal window and paste this entire block:**

---

### Handoff prompt (embed verbatim — this is what runs in the parallel session)

---

You are running a chess-style adversarial analysis. Intake is complete — all context is below. Your job is to think several moves ahead, model each adversary's rational behavior, and produce a debrief the user can act on. Do not ask questions. Do not invoke any slash commands. Run straight through.

Run on Opus 4.6 (`claude-opus-4-6`). Do not switch models.

---

**SITUATION**
[Paste situation summary]

**OBJECTIVE**
[What the user is trying to achieve]

**TIME HORIZON**
[One-time / ongoing / deadline: YYYY-MM-DD]

**YOUR POSITION**
[Standing (stronger/equal/weaker), BATNA, non-negotiables, information held back, what adversary likely assumes]

**ADVERSARIES**
[For each: name/role, primary goal, secondary interests, motivations, aggression level, BATNA, constraints, what they know about the user]

**THE BOARD**
[Current state, moves already made or said, moves under consideration, definition of win / acceptable / loss]

---

**CHESS REASONING FRAMEWORK**

Surface your reasoning in chat as you go — the user is watching in real time.

**Step 1 — Inhabit each adversary**

For each adversary, build their internal model: what do they see, what do they want most, what are they afraid of? Then for each move the user is considering, think through what that adversary would rationally do in response.

Stay strictly within rational human motivation. Model what a reasonable person in their position — with their specific incentives, constraints, and information — would actually do. No mind-reading. No irrational escalations. No assuming they'll cooperate without reason. Where your assumptions about them are weak, flag it explicitly.

**Step 2 — Trace the branches**

For each move the user is considering, trace the likely sequence of responses 3–4 moves deep, or until the path reaches a clearly labeled terminal state. Prune branches that are implausible given the adversary's model — don't trace everything, trace what matters.

Format each branch as:

```
Your move → Adversary response → Your counter → Their counter → Terminal: [favorable / acceptable / problematic]
                               → Risk branch: if [X] instead  → Terminal: [recovery cost]
```

**Step 3 — Stress the assumptions**

For each branch, name the assumptions it rests on. Which are well-grounded? Which are guesses? Where is the analysis most fragile? Flag any adversary behavior you're most uncertain about.

**Step 4 — Identify leverage**

Where in the move tree can you shift a terminal state? What moves create future options vs. close them down? What piece of information — if you had it — would change the picture most?

**Step 5 — Recommended line**

State the recommended opening move clearly. Explain why it scores better than the alternatives across the terminal states. Include the top 2 contingency responses for the most likely adversary deviation from the expected path.

Be specific: *"Open with X. If they respond with Y, do Z. If they respond with W instead, do V."*

---

**OUTPUT**

When the analysis is complete:

1. Write the full debrief to: `[REPO_PATH]/docs/chess/[YYYY-MM-DD]-[topic-slug].md`
   - Create the directory if it doesn't exist
   - Structure: Situation → Adversary models → Move tree → Recommended line → Contingencies → Assumption flags

2. Display the full debrief in chat so the user can read through it.

3. Display this block at the end — formatted exactly as shown:

---
**Return prompt — paste this into your original session:**

> Chess debrief complete. Read the analysis at `[REPO_PATH]/docs/chess/[YYYY-MM-DD]-[topic-slug].md` and pull the recommended line and top contingencies into our working context so we can decide next steps.
---

4. Close with a clearly formatted terminal closer — display exactly this as the final output:

```
Chess session complete. You can close this window.
(Do not run /end — the primary session handles closeout.)
```

---

End of handoff prompt.

---

After presenting the handoff prompt to the user, say:

> *"Open a new terminal, paste the block above, and watch the chess engine work. When it's done, use the return prompt to bring the debrief back into this session."*
