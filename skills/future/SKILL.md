---
name: future
description: Scenario planning via three futures (The Win, The Unraveling, The Headwind). Rewinds each path to today, surfaces the decisions that matter most across scenarios, and gives one specific action this week. Use when navigating uncertainty.
---

Scenario planning via three futures. Rewinds each path month by month to today, synthesizes the decisions that mattered most, and delivers a one-screen action guide with a clear first move.

**Self-contained.** Does not require `/start`. Reads its own context.

---

## Routing check

Before starting, confirm this is the right command:
- **Real adversary with competing interests?** → `/chess` (Human Mode)
- **System or plan to stress-test?** → `/chess` (System Mode)
- **Specific task to execute with steps?** → `/plan`
- **Uncertain future with multiple possible outcomes?** → You're in the right place.

---

## Pre-flight (Sonnet, inline)

Ground the scenarios in the actual project without silent token burn:
- If `WORK_LOG.md` and `CLAUDE.md` are already in context (e.g. `/start` ran this session), do not re-read them. Otherwise read them, using the partial-read rules from `/start` for long files.
- Skip the git log unless project context is still thin after those reads.
- Skip PM tasks unless intake surfaces schedule or deadline pressure.

Do not summarize this to the user.

**Check for prior runs.** Look for files in `docs/futures/`.

- If prior run(s) exist: note the most recent file and say: *"I see a /future from [date] — start fresh, or run an update? An update reads what's changed and revises the scenarios with actual data."*
- If no prior runs: proceed to intake.

---

## Intake (Sonnet, inline)

Ask conversationally — not as a numbered list. One question at a time. Follow up where answers are thin.

**The north star**
What does massive success look like in concrete terms? Not "we grew a lot" — what's the specific outcome you'd be genuinely proud of? Name it as if it already happened.

**The fear**
What's the specific failure that keeps you up at night? The one you'd be embarrassed to explain to someone who believed in you.

**The constraints**
What are the hard limits right now? Runway, team size, a deadline that can't move. Then: what's actively underway that's critical and must not slip? And what are you waiting on someone else to deliver before you can move?

**Timeframe**
Based on project context and what the user described, propose a timeframe:
- 3–6 months: specific launch, campaign, or sprint with a hard end date
- 12 months: default for most products and ventures
- 18–24 months: platforms, infrastructure, or early-stage ventures

Say: *"Based on what you've described, I'd suggest a [N]-month horizon — does that feel right?"* Confirm before proceeding.

---

## Assumption check (Sonnet, inline)

Brief — not a full /plan. Restate the user's success scenario in one sentence, then surface 2-3 assumptions it rests on. Ask which feel solid and which feel shaky.

*"Your success scenario — [restate it] — rests on a few things being true: [A], [B], [C]. Which of these feel solid, and which feel like open questions? Anything shaky will shape what The Unraveling looks like."*

Note the shaky ones. They go into the brief.

---

## Retrospective step (Sonnet subagent — only if prior run exists)

If the user chose the update path: before writing the main brief, spawn a lightweight Sonnet subagent to do the comparison work.

Subagent receives:
- The prior /future output (read from `docs/futures/[most-recent-file].md` — the ## Output section only)
- The user's answer to: *"What's the most significant thing that's changed since then — in the project, market, or your constraints?"*

Subagent produces: a 200-300 word comparison note — what the prior thesis got right, where reality diverged, what that changes going into the updated scenarios. This note gets included in the main brief so the Opus subagent doesn't need to re-read the full prior file.

---

## Generate the brief and spawn subagent

Compile everything into a futures brief file and spawn an Opus 4.8 subagent. Follow the `/handoff` pattern.

**1. Write the brief**

Create `docs/futures/` if it doesn't exist. Write `docs/futures/YYYY-MM-DD-[slug].md` using the template below. Fill in all [BRACKETS] with real values.

---

```
# Future Brief — [YYYY-MM-DD] — [slug]
[Fresh run / Retrospective update from [prior date]]

## Run instructions
Do not ask questions. Do not invoke slash commands. Surface reasoning in chat as you go. Append all output under ## Output in this file.

## Project context
[3-5 bullet points from WORK_LOG + CLAUDE.md: current state, recent decisions, known constraints. Enough to ground the scenarios — not a wall of text.]

## Intake
- North star: [specific success outcome, past tense]
- Fear: [specific failure]
- Constraints: [runway, team, deadlines, dependencies]
- Critical and active: [what's underway and must not slip — extracted from WORK_LOG + intake]
- Waiting on third party: [what's blocked on an external dependency — extracted from WORK_LOG + intake]
- Timeframe: [N months]
- Shaky assumptions: [the ones the user flagged as uncertain]

## What's already in motion
[Omit entire section if both buckets are empty]
- [critical, active]: [item] — must not slip
- [waiting: third party]: [item] — blocked on [who/what], not actionable until they respond

[If retrospective:]
## What's changed since [prior date]
[The 200-300 word comparison note from the Sonnet retrospective step]

## Futures framework

**Three narratives**

Write all three in past tense. Voice: explaining what happened to someone who loves you and won't let you bullshit them. Start each at the end of the timeframe and rewind month by month to today. Name decisions, not themes. Name the fork points.

**The Win**
Massive success. What decisions and actions were instrumental? What did you do in month 2 that set up month 8? What did you resist that would have derailed you?

Cover:
- The decisions that compounded early and paid off late
- The things you didn't do that turned out to matter
- The moment it could have gone either way — and what made it go right
- External factors that helped, and what you did to be positioned for them

**The Unraveling**
Massive failure. Anchor this in the shaky assumptions from intake — show how they played out.

Cover:
- What was tempting but harmful (looked like a good idea at the time)
- What was delayed past the point of recovery
- The earliest warning sign — before it became obvious
- What you'd tell yourself in month 2 if you could

**The Headwind**
You did almost everything right. The universe didn't cooperate. This scenario teaches what you need to be resilient against, not just what to do differently.

Cover:
- What external forces hit that you couldn't have fully predicted
- What exposure you had that you didn't need
- What resilience you had — and what you wish you'd built
- The real ceiling on what was achievable, even with strong execution

[If retrospective:] For each narrative, note where the prior projections diverged from what actually happened. What did the prior /future get right? What did it miss?

---

**Synthesis**

Do this reasoning internally. Only the output appears in the final results.

**Quadrant analysis** — classify every significant decision/action across the three scenarios:
- ✅ Double-confirmed critical — appears in The Win AND its absence drives The Unraveling. Highest-confidence levers.
- ⚠️ Swing-state — present in both Win and Unraveling but executed differently. Hard calls, not obvious moves. Flag each — don't flatten them.
- ❌ Failure driver — appears in The Unraveling, absent from The Win. Anti-patterns.
- Resilience gap — surfaces from The Headwind. Within your control but requires deliberate preparation.

**Leading indicators** — for each ❌ and ⚠️ item: what was the earliest signal it was going wrong? Not month 8 — month 2. Extract from the narratives, not asked of the user.

**Irreversibility** — tag each ✅ and ⚠️ item:
- *(irreversible)* — hiring, pricing model, core tech choices, pivots, strategic commitments
- *(iterable)* — can be course-corrected without major cost

**Order by when** — sort output items by when the decision needs to be made. Timing drives action.

**Chess candidates** — for each ⚠️ swing-state decision: does it involve a real counterparty with genuinely competing interests? If yes, note it internally. These get surfaced in the /chess bridge section of the output.

---

**Agency filter — run before writing primary output**

Cross-reference every candidate output item against `## What's already in motion` in the brief.

- `[waiting: third party]` items: the user can't act on these differently right now. If the item is on the critical path, note it as "Watching: [item] — blocked on [who/what]" in the primary output. Do not call it as an action.
- `[critical, active]` items: the user is already on it. Do NOT make these the headline recommendation. Add one line — "Keep going on: [item] — it's on the critical path" — before the primary "Your move" output. Then move on.
- `[Your move this week]` must surface things NOT already underway and NOT blocked on a third party. The user's highest-value output is what they haven't started or haven't prioritized yet — not confirmation of what they already know.

---

**Primary output**

Write the one-screen summary. Tight — everything that matters, nothing that doesn't.

**The thesis**
One paragraph. The single most important variable separating The Win from The Unraveling. Name the one fork in the road.

[If retrospective:] One sentence first: whether the prior thesis still holds or has shifted.

**3 load-bearing decisions** (✅ double-confirmed, ordered by when)

For each:
- **The decision** — stated plainly
- **When** — specific window, not "eventually"
- **Early warning sign** — earliest signal it's going wrong
- Mark *(irreversible)* where it applies

Three max.

**3 things not to do** (❌ failure drivers)

For each:
- **The anti-pattern** — what it is
- **Why it's tempting** — if it weren't, you wouldn't need the warning
- **The signal you're sliding into it** — earliest sign

Three max.

**Your move this week**
If there are `[critical, active]` items: one line acknowledging them ("Keep [X] moving — it's on the critical path"). Then: one or two specific actions that are NOT already underway and NOT blocked on a third party. Entry points the user hasn't taken yet.

---

*Full narratives, complete quadrant, and everything else surfaced are in the appendix. Ask to see it.*

---

## Output

*(appended by subagent)*
```

---

**2. Hand off**

Follow `/handoff` steps 3–6: show the intake summary in chat (north star in one sentence, fear, constraints, timeframe, shaky assumptions — not the framework), give the Opus cost warning, spawn the subagent against the brief file, and surface results. When results return, present the one-screen primary output (thesis → 3 decisions → 3 anti-patterns → your move this week) in the main session for discussion.

---

## Council reaction (Sonnet, inline)

After presenting the primary output, run the council.

Pick 4 contextually relevant advisors for this domain and project type — real people whose thinking applies to the specific situation. Name them, one sentence each on why they're on this panel.

Have each react to the 3 load-bearing decisions in 2-3 sentences. Let them disagree where they would.

Present the council reactions in chat. No synthesis needed — the reactions are the output. Then proceed to the /chess bridge evaluation below.

---

## /chess bridge (after results return)

After presenting the primary output, evaluate the chess candidates the subagent identified. For each ⚠️ swing-state decision that involves a real counterparty:

Apply a strict filter before surfacing. BOTH must be true:
1. **Real adversarial tension** — a counterparty whose interests genuinely compete with yours, not just a vendor you're selecting or a partner whose goals are aligned
2. **Material and hard to reverse** — significant money, a strategic dependency, or a relationship where getting it wrong costs you something you can't easily get back

If both aren't true, don't mention /chess. Most /future runs surface zero chess candidates. One is meaningful.

**When a candidate clears the filter**, present it as:

> **[Decision name]**
> [One sentence: what the decision is and who the counterparty is.]
> [One sentence: what their competing interest is and why that creates genuine tension.]
> [One sentence: what's at stake — the material downside or opportunity cost if this goes wrong.]
> **Recommendation: [Run /chess / Skip /chess]** — [one-line rationale]
>
> *Run /chess on this?*

The recommendation to run should be conservative. If the stakes are meaningful and the outcome is genuinely uncertain, recommend run. If the adversarial component is minor, the counterparty's interests are broadly aligned, or the decision is iterable — recommend skip.

If no candidates clear the filter, say nothing about /chess.

---

## Follow-up

After the /chess bridge (or if no chess candidates), offer once:
- If ClickUp MCP is connected: *"Want me to create a ClickUp task to review the load-bearing decisions 30 days from now?"*
- Otherwise: *"Want me to add a 30-day review reminder to WORK_LOG.md?"*

One line. Don't push it.
