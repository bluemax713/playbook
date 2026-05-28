Scenario planning via three futures. Rewinds each path month by month to today, synthesizes the decisions that mattered most, and delivers a one-screen action guide with a clear first move.

---

## Pre-flight: Read context

Silently read the following before doing anything else:
- `WORK_LOG.md` in the current project
- `CLAUDE.md` in the current project
- Recent git log (last 20 commits) if available
- Any open/in-progress PM tasks if a PM MCP is connected

Do not summarize this to the user. Use it to ground the scenarios in the actual project — real constraints, real state, real recent decisions. Generic startup scenarios are useless.

---

## Intake

Ask these questions conversationally — not as a numbered list. One at a time, naturally. Use follow-ups where an answer is thin. The goal is enough material to write scenarios that are specific, not vague.

**Question 1 — The north star**
What does massive success look like in concrete terms? Not "we grew a lot" — what's the specific outcome, 12 months from now, that you'd genuinely be proud of? Name it as if it already happened.

**Question 2 — The fear**
What's the specific failure that keeps you up at night? The scenario you'd be embarrassed to explain to someone who believed in you. Be direct.

**Question 3 — The constraints**
What are the hard limits right now? Runway, team size, a deadline that isn't moveable, a dependency you're waiting on. What are you working around?

**Timeframe**
Based on the project context and what the user just described, propose a timeframe. Default is 12 months, but:
- Shorter (3–6 months) for a specific launch, campaign, or sprint with a hard end date
- Longer (18–24 months) for platforms, infrastructure, or ventures still finding product-market fit
- Say: *"Based on what you've described, I'd suggest a [N]-month horizon — does that feel right, or should we adjust?"*

Confirm the timeframe before proceeding.

---

## Three scenarios

Write all three. Past tense throughout. The narrative voice is: you're explaining what happened to someone who loves you and won't let you bullshit them — honest, specific, no spin. This isn't a case study or a consultant's report. It's a candid debrief.

For each scenario, start at the end of the timeframe and rewind month by month to today. Name specific decisions, not themes. Name the moments where the path forked. Name what was done and what wasn't.

---

### Scenario A: The Win

Massive success landed. Rewind from the end state to today.

What happened? Not just what worked — what *decisions* and *actions* were instrumental? What did you do in month 2 that set up month 8? What did you resist that would have derailed you? What was the moment where it could have gone either way, and what made it go right?

Be specific about:
- The decisions that compounded (small early, large later)
- The things you *didn't* do that turned out to matter
- The external factors that helped — and what you did to be positioned to benefit from them

---

### Scenario B: The Unraveling

Massive failure. Rewind from the end state to today.

What happened? Not just "we ran out of money" or "we lost momentum" — what specific decisions, delays, and patterns led there? What looked reasonable at the time but wasn't? What was done instead of what actually mattered? When did you first know something was wrong, and what did you do (or not do) about it?

Be specific about:
- What was tempting but harmful (the anti-patterns that looked like good ideas)
- What was delayed past the point of recovery
- What the earliest warning sign was — before it became obvious
- What you'd tell yourself in month 2 if you could

---

### Scenario C: The Headwind

You did almost everything right. The universe didn't cooperate. Rewind from the end state to today.

This is the scenario most people don't think about because it's uncomfortable — you can't control it, and it feels like an excuse. But naming it clearly is the difference between being blindsided and being resilient.

What external forces hit that you couldn't have fully predicted? A market shift, a competitor move, a platform change, a regulatory event, a macro condition, a key relationship that fell through. What was the real ceiling on what could be achieved even with strong execution?

Be specific about:
- What you were exposed to that you didn't need to be
- What resilience you had built — and what you wish you'd built
- The difference between "bad luck" and "we were fragile in a way we could have fixed"
- What "doing everything right" actually looked like in this world

---

## Synthesis

Do this internally before writing the final output. Do not show the synthesis process to the user — only the output.

**Quadrant analysis**
Classify decisions and actions across the three scenarios:

- **Double-confirmed critical** — appears in The Win AND its absence appears in The Unraveling. These are the highest-confidence levers.
- **Swing-state decisions** — present in The Win but also present (differently executed) in The Unraveling. These are hard calls, not obvious moves. Flag them explicitly.
- **Failure drivers** — appear in The Unraveling and are absent from The Win. The anti-patterns.
- **Resilience gaps** — surface from The Headwind. Things within your control that would have changed your exposure to external forces.

**Leading indicators**
For each critical decision or turning point in The Unraveling: what was the *earliest signal* that this was coming? Not month 8 when it was obvious — month 2, when there was still time. Extract these from the narrative, don't ask the user. They're already embedded in the story.

**Irreversibility flag**
Tag each load-bearing decision as:
- **Hard to reverse** — hiring, pricing model, core tech choices, pivots, strategic commitments
- **Iterable** — things you can course-correct on without major cost

Hard-to-reverse decisions deserve more upfront thought and appear earlier in the output.

**Order by when, not importance**
Sort all output items by *when* the decision needs to be made, not by abstract importance. Timing drives action; importance doesn't.

---

## Output

Present the primary output in full. Then offer the appendix.

---

**The thesis**

One paragraph. The single most important variable — the fork in the road that, more than anything else, separates The Win from The Unraveling. Don't list three things. Name the one.

---

**3 load-bearing decisions**

The decisions that cascade if you get them wrong or delay them. For each:
- **The decision** — what it is, stated plainly
- **When it needs to be made** — a specific window ("before month 3," "within the next 6 weeks"), not "eventually"
- **Early warning sign** — the earliest signal that this is going wrong, before it's obvious
- Mark hard-to-reverse decisions with *(irreversible)*

Ordered by when, not importance. Three max. If more surfaced, put the rest in the appendix.

---

**3 things not to do**

From The Unraveling. For each:
- **The anti-pattern** — what it is
- **Why it's tempting** — if it weren't tempting, you wouldn't need the warning
- **The signal you're sliding into it** — the earliest sign, before it becomes entrenched

Three max. The most dangerous ones — the ones that looked like good ideas.

---

**Your move this week**

One or two specific actions, this week. Not "eventually" — this week. These are the entry point into the critical path. Everything else can wait until these are done.

---

*Full narratives, complete quadrant synthesis, and everything else the exercise surfaced are in the appendix. Type "show appendix" to read.*

---

**Follow-up**

After presenting the output, offer one of the following (based on what tools are connected):
- If ClickUp MCP is connected: *"Want me to create a ClickUp task to review the load-bearing decisions 30 days from now?"*
- Otherwise: *"Want me to add a reminder to WORK_LOG.md to revisit these decisions in 30 days?"*

This is a one-line offer. Don't push it.

---

## Appendix (on request)

If the user types "show appendix" or asks to see more:

1. **Full narratives** — all three scenarios in full
2. **Quadrant synthesis** — the full classification of every decision/action that surfaced
3. **Everything else** — items that didn't make the top 3 in either output section, labeled "worth knowing, not the priority right now"

Present the appendix cleanly, clearly separated from the primary output.
