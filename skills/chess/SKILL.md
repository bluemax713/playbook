---
name: chess
description: Adversarial strategy analysis. Human Mode models a real opponent and traces move branches; System Mode attacks a technical plan to find failure points before building. Use for negotiations, partnerships, competitive moves, or stress-testing a plan.
---

Adversarial strategy analysis and technical stress-testing. Two modes: Human Mode (opponent-modeled, branch-traced) for situations with a real adversary; System Mode (assumption-attack, failure-traced) for technical plans with no human counterparty.

**Self-contained.** Does not require `/start`. Reads its own context.

---

## Routing check

Before starting, confirm this is the right command:
- **Real adversary with competing interests and material stakes?** → Confirm to the user and proceed to Human Mode intake.
- **Technical plan or system to stress-test, no human counterparty?** → Confirm to the user and proceed to System Mode intake.
- **Pure tradeoffs decision or task to plan?** → `/plan` is the right tool. Offer to invoke it instead.
- **Longer horizon, multiple possible futures you can't fully control?** → `/future` is the right tool. Offer to invoke it instead.

**Borderline:** Name what makes it ambiguous. Ask the user to confirm before proceeding.

---

## Human Mode

### Intake

Run in the main session on Sonnet. Ask conversationally — not as a numbered list. Group related questions naturally. Use follow-ups where the answer is thin.

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

---

### Council read (Sonnet, inline)

After intake, frame the strategic posture with the council.

Pick 4 contextually relevant advisors — real people whose documented thinking and experience apply directly to this situation. Name them, one sentence each on why they're on this panel.

Have each give their honest read on the strategic posture in 3-4 sentences — grounded in the specifics captured at intake (the adversaries, the user's standing, the BATNAs), not their general philosophy. Let them disagree where they would.

Synthesize in 2-3 sentences: what the council collectively surfaces that should shape the brief and the move tree.

Present the council output in chat, then proceed to the brief.

---

### Generate the brief and spawn subagent

Once intake is complete, compile everything into a chess brief file and spawn an Opus 4.8 subagent. Follow the `/handoff` pattern.

**1. Write the brief**

Create `docs/chess/` if it doesn't exist. Write `docs/chess/YYYY-MM-DD-[slug].md` using the template below. Fill in all [BRACKETS] with real values.

---

```
# Chess Brief — [YYYY-MM-DD] — [slug]
*Human Mode*

## Run instructions
Do not ask questions. Do not invoke slash commands. Surface reasoning in chat as you go. Append all output under ## Output in this file.

## Situation
[Situation summary]

## Objective
[What the user is trying to achieve]

## Time horizon
[One-time / ongoing / deadline: YYYY-MM-DD]

## Your position
Standing: [stronger / equal / weaker]
BATNA: [best alternative if this doesn't go their way]
Non-negotiables: [what they won't concede]
Information held back: [what they're not disclosing]
What adversary likely assumes: [their read of the user's position]

## Adversaries
[For each adversary:]
**[Name / Role]**
- Primary goal: [what they want most]
- Secondary interests: [other things they care about]
- Motivations: [financial / ego / power / relationship / legal / other]
- Aggression level: [passive / moderate / aggressive]
- BATNA: [their best alternative]
- Constraints: [budget limits, authority limits, approvals needed, external pressures]
- What they know: [their read of the user's position]

## The board
Current state: [what's happening right now]
Moves already made: [what's been said or done that constrains the situation]
Moves under consideration: [what the user is thinking about doing]
Win: [definition]
Acceptable: [definition]
Loss: [definition]

## Chess reasoning framework

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

State the recommended opening move clearly. Explain why it scores better than the alternatives across the terminal states. Include the top 2 contingency responses for the most likely adversary deviation.

Be specific: *"Open with X. If they respond with Y, do Z. If they respond with W instead, do V."*

## Output format
Structure the output as:
1. Adversary models — internal model for each adversary
2. Move tree — branches traced per Step 2
3. Recommended line — the opening move and top 2 contingencies
4. Assumption flags — where the analysis is most fragile

---

## Output

*(appended by subagent)*
```

---

**2. Hand off**

Follow `/handoff` steps 3–6: show the intake summary in chat (situation in one sentence, objective, adversaries named, standing, BATNA, non-negotiables — not the framework), give the Opus cost warning, spawn the subagent against the brief file, and surface results. When results return, present the recommended line and top contingencies in the main session. The full debrief is in the brief file at `docs/chess/[filename]`.

---

## System Mode

### Intake

If the system, plan, and constraints are already established in the conversation, skip directly to the stress-test. Only ask for information that's genuinely missing.

**If the system is technical and a `docs/solutions/` directory exists** at the project root, skim the relevant learnings there as grounding before mapping assumptions — past solved problems often name the failure modes worth attacking. Skip this if there's no `docs/solutions/`.

If context is thin, ask conversationally:

**The system**
- What are you trying to build, fix, or change?
- What does the current system look like? (components, dependencies, environment, constraints)
- What's already been decided or built that the plan must work around?

**The plan**
- What's the sequence of moves you're planning?
- What outcome are you trying to guarantee?
- What's an acceptable failure mode vs. an unacceptable one?

---

### System stress-test

**Simple systems** (single service, clear dependencies, limited blast radius): run inline on Sonnet. No subagent needed.

**Complex systems** (multiple interacting services, deep dependency chains, complex state machines): follow the `/handoff` pattern. Write a brief to `docs/chess/YYYY-MM-DD-[slug]-system.md` with the system description, plan, and the framework below. Spawn a Sonnet subagent (`model: 'sonnet'`). Escalate the subagent to Opus 4.8 (`model: 'opus'`) only when the system complexity genuinely warrants it.

Surface reasoning in chat as you go.

**Step 1 — Map the assumptions**

List every assumption embedded in the plan. These are the places where "this works if..." is implicit. Be exhaustive — surface assumptions about environment, dependencies, timing, state, permissions, behavior under failure. Name them all before attacking any.

**Step 2 — Attack each vector**

Work through the assumption list. For each one:
- **State the risk:** what breaks if this assumption is wrong?
- **Reason through the system's response:** how does the environment, dependency, or component actually behave in this case? Trace the actual mechanics, not the happy path.
- **Verdict:**
  - ✅ — assumption holds, no change needed
  - ⚠️ → [specific mitigation] — risk is real but manageable; state the required change
  - ❌ — plan-breaker; must resolve before building

Don't pad. If an assumption clearly holds, say so and move on. Depth where there's actual risk.

**Step 3 — Surface what changed**

List only the changes the stress-test produced. Not every risk — only the ones with a ⚠️ or ❌ verdict that require action. For each: what changes, and why.

**Step 4 — Ready to build?**

State clearly: the plan is sound as-is / the plan needs these N changes before it's sound. If changes are needed, offer to incorporate them and proceed.
