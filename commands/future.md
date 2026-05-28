Scenario planning via three futures. Rewinds each path month by month to today, synthesizes the decisions that mattered most, and delivers a one-screen action guide with a clear first move. Runs intake in the main session, heavy reasoning in a fresh Opus 4.6 parallel session.

**This command is self-contained.** Do not require `/start` to have been run. Do not depend on any prior session state. Read your own context.

---

## Pre-flight (Sonnet, main session)

Silently read the following before doing anything else:
- `WORK_LOG.md` in the current project
- `CLAUDE.md` in the current project
- Recent git log (last 20 commits) if available
- Any open/in-progress PM tasks if a PM MCP is connected

Do not summarize this to the user. Use it to ground the scenarios in the actual project — real constraints, real state, real recent decisions. Generic scenarios are useless.

**Check for prior runs.** Look for files in `docs/futures/` in the current project.

- If prior run(s) exist: note the most recent one and ask the user: *"I see a /future from [date] — do you want to start fresh, or run an update? An update reads what's changed since then and revises the scenarios with actual data."* If they choose update, note it — the handoff prompt will include the prior output for comparison.
- If no prior runs: proceed directly to intake.

---

## Intake (Sonnet, main session)

Ask these questions conversationally — not as a numbered list. One at a time. Use follow-ups where an answer is thin.

**The north star**
What does massive success look like in concrete terms at the end of the timeframe? Not "we grew a lot" — what's the specific outcome you'd be genuinely proud of? Name it as if it already happened.

**The fear**
What's the specific failure that keeps you up at night? The scenario you'd be embarrassed to explain to someone who believed in you. Be direct.

**The constraints**
What are the hard limits right now? Runway, team size, a deadline that isn't moveable, a dependency you're waiting on. What are you working around?

**Timeframe**
Based on project context and what the user described, propose a timeframe:
- 3–6 months: specific launch, campaign, or sprint with a hard end date
- 12 months: default for most products and ventures
- 18–24 months: platforms, infrastructure, or ventures still finding product-market fit

Say: *"Based on what you've described, I'd suggest a [N]-month horizon — does that feel right?"* Confirm before proceeding.

---

## Assumption check (Sonnet, main session)

Before generating the handoff, do a brief assumption check. This is not a full `/plan` — keep it short.

Restate the user's success scenario in one sentence. Then surface the 2–3 assumptions it rests on — the things that need to be true for that outcome to be achievable. Ask the user directly which ones feel solid and which feel shaky.

Example framing: *"Your success scenario — [restate it] — rests on a few things being true: [A], [B], [C]. Which of these feel solid, and which feel like open questions? Anything shaky here will shape what The Unraveling looks like."*

Listen to the response. Shaky assumptions become the seeds of The Unraveling. Note them — they go into the handoff prompt.

---

## Generate the handoff prompt

Compile everything from pre-flight, intake, and the assumption check into a self-contained futures brief. Fill in all [BRACKETS] with real values — current date, actual repo path (use the current working directory), a short project slug derived from the context.

Create the `docs/futures/` directory in the current project if it doesn't already exist.

Present the completed handoff prompt to the user in a clearly labeled block:

> **Open a new terminal window and paste this entire block:**

---

### Handoff prompt (embed verbatim — this is what runs in the parallel session)

---

You are running a /future scenario planning session. Intake is complete — all context is below. Your job is to write three specific, honest narratives and synthesize them into a one-screen action guide the user can act on immediately. Do not ask questions. Do not invoke any slash commands. Run straight through.

Run on Opus 4.6 (`claude-opus-4-6`). Do not switch models.

---

**PROJECT CONTEXT**
[Paste key context from WORK_LOG, CLAUDE.md, and recent git activity — current state, recent decisions, known constraints. 3–5 bullet points. Enough for grounding, not a wall of text.]

**NORTH STAR**
[What the user described as massive success — specific, concrete, past tense]

**THE FEAR**
[The specific failure they named]

**HARD CONSTRAINTS**
[Runway, team size, deadlines, dependencies]

**TIMEFRAME**
[N months — confirmed with user]

**SHAKY ASSUMPTIONS**
[The assumptions from the assumption check that the user flagged as uncertain — these seed The Unraveling]

**PRIOR /FUTURE** *(include only if retrospective mode)*
[Paste the full prior /future primary output here. Note the date it was run.]
[Add one line: "The user says the following has changed since then: [what they described]"]

---

**FRAMEWORK**

Surface your reasoning in chat as you go — the user may be watching in real time.

---

**Step 1 — Three narratives**

Write all three. Past tense throughout. The voice: explaining what happened to someone who loves you and won't let you bullshit them. Honest, specific, no spin. Start each narrative at the end of the timeframe and rewind month by month to today. Name decisions, not themes. Name the moments where the path forked.

**The Win**

Massive success landed. What happened? What decisions and actions were instrumental? What did you do in month 2 that set up month 8? What did you resist that would have derailed you? What external factors helped — and what did you do to be positioned to benefit from them?

Cover:
- The decisions that compounded (small early, large later)
- The things you didn't do that turned out to matter
- The moment it could have gone either way, and what made it go right

**The Unraveling**

Massive failure. What happened? What specific decisions, delays, and patterns led there? What looked reasonable at the time but wasn't? What was done instead of what mattered? When did you first know something was wrong, and what did you do (or not do) about it?

Anchor this in the shaky assumptions from intake — show how they played out.

Cover:
- What was tempting but harmful (the anti-patterns that looked like good ideas)
- What was delayed past the point of recovery
- The earliest warning sign — before it became obvious
- What you'd tell yourself in month 2 if you could

**The Headwind**

You did almost everything right. The universe didn't cooperate. This scenario teaches a different lesson — not what you did wrong, but what you needed to be resilient against.

What external forces hit that you couldn't have fully predicted? A market shift, a competitor move, a platform change, a regulatory event, a macro condition, a key relationship that fell through.

Cover:
- What you were exposed to that you didn't need to be
- What resilience you had or hadn't built
- The difference between "bad luck" and "we were fragile in a way we could have fixed"
- What the real ceiling was, even with strong execution

*If this is a retrospective run:* For each narrative, note where the prior projections diverged from what actually happened. What did the prior /future get right? What did it miss? This grounds the updated scenarios in real data, not pure speculation.

---

**Step 2 — Synthesis**

Do this reasoning internally. Only the output appears.

**Quadrant analysis**

Classify every significant decision and action across the three scenarios:

- ✅ **Double-confirmed critical** — appears in The Win AND its absence drives The Unraveling. Highest-confidence levers.
- ⚠️ **Swing-state** — present in both Win and Unraveling, but executed differently. These are the hard calls with imperfect information. Flag each one — don't flatten them into simple advice.
- ❌ **Failure driver** — appears in The Unraveling, absent from The Win. The anti-patterns.
- **Resilience gap** — surfaces from The Headwind. Within your control, but requires deliberate preparation.

**Leading indicators**

For each ❌ failure driver and ⚠️ swing-state decision: what was the *earliest signal* it was going wrong? Not month 8 — month 2. Extract from the narratives. These are the monitoring signals, not asked of the user.

**Irreversibility**

Tag each ✅ and ⚠️ item:
- *(irreversible)* — hiring, pricing model, core tech choices, pivots, strategic commitments. Deserves more upfront thought.
- *(iterable)* — can be course-corrected without major cost.

**Chess flag**

For each ⚠️ swing-state decision: does it involve a real counterparty with competing interests — a negotiation, a key hire where the candidate has leverage, a partnership where the other party wants different things? If yes, mark it: *[/chess candidate]*

**Order by when**

Sort all output items by when the decision needs to be made. Timing drives action. Importance doesn't.

---

**Step 3 — Primary output**

Write the one-screen output. This is what goes back to the main session. Keep it tight — everything that matters, nothing that doesn't.

---

**The thesis**

One paragraph. The single most important variable — the fork in the road that, more than anything else, separates The Win from The Unraveling. Don't list three things. Name the one.

*If retrospective:* Open with one sentence on whether the prior thesis still holds or has shifted based on what's happened.

---

**3 load-bearing decisions** *(✅ double-confirmed, ordered by when)*

For each:
- **The decision** — stated plainly
- **When it needs to be made** — a specific window, not "eventually"
- **Early warning sign** — the earliest signal it's going wrong
- Mark *(irreversible)* where it applies
- Mark *[/chess candidate]* where it applies

Three max. If more surfaced, they go in the appendix.

---

**3 things not to do** *(❌ failure drivers)*

For each:
- **The anti-pattern** — what it is
- **Why it's tempting** — if it weren't tempting, you wouldn't need the warning
- **The signal you're sliding into it** — earliest sign, before it's entrenched

Three max. The most dangerous — the ones that looked like good ideas.

---

**Your move this week**

One or two specific actions, this week. The entry point into the critical path. Everything else waits until these are done.

---

*Full narratives, complete quadrant, and everything else the exercise surfaced are in the appendix. Ask to see it.*

---

**Step 4 — Save and return**

1. Write the full output to: `[REPO_PATH]/docs/futures/[YYYY-MM-DD]-[project-slug].md`
   - Create the directory if it doesn't exist
   - Structure: all three narratives → full quadrant synthesis → primary output
   - Include the date run at the top

2. Display the **primary output only** (thesis → 3 decisions → 3 anti-patterns → your move) in chat so the user can read it.

3. Display this block at the end — formatted exactly as shown:

---
**Return prompt — paste this into your original session:**

> /future session complete. The full output is saved at `[REPO_PATH]/docs/futures/[YYYY-MM-DD]-[project-slug].md`. Here is the one-screen summary — bring it into our working context so we can discuss next steps and act on it:
>
> [Paste the primary output verbatim here — thesis through "your move this week"]
---

4. Close with a clearly formatted terminal closer — display exactly this as the final output:

```
Future session complete. You can close this window.
(Do not run /end — the primary session handles closeout.)
```

---

End of handoff prompt.

---

After presenting the handoff prompt to the user, say:

> *"Open a new terminal, paste the block above, and watch it run. When it's done, use the return prompt to bring the output back here so we can discuss it and act on it."*

---

## After the return (main session)

When the user pastes the return prompt back, the one-screen output is now live in the main session as working context. Discuss it directly — load-bearing decisions, anti-patterns, the thesis, anything they want to dig into.

If any decisions are marked *[/chess candidate]*, surface this: *"Decision [X] has a counterparty component — /chess would let us model how that plays out before you commit."*

Offer the 30-day follow-up once, as a single line:
- If ClickUp MCP is connected: *"Want me to create a ClickUp task to review the load-bearing decisions 30 days from now?"*
- Otherwise: *"Want me to add a 30-day review reminder to WORK_LOG.md?"*
