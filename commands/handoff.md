This command is for Claude to invoke — not the user. It defines the canonical subagent pattern used by /chess, /future, /plan, and any task that benefits from a fresh context window. Replaces the old copy-paste terminal approach entirely.

---

## The pattern

**Step 1 — Intake in main session (Sonnet)**
Run intake conversationally. Collect everything the subagent needs to execute without asking questions.

**Step 2 — Write the brief**
Compile intake data + execution framework into a structured .md file. Use the relevant subdirectory:
- `/chess` → `docs/chess/YYYY-MM-DD-[slug].md`
- `/future` → `docs/futures/YYYY-MM-DD-[slug].md`
- `/plan` → `docs/plans/YYYY-MM-DD-[slug].md`
- Generic → `docs/handoffs/YYYY-MM-DD-[slug].md`

Create the directory if it doesn't exist.

**Brief file structure:**
```
# [Command] Brief — [YYYY-MM-DD] — [slug]

## Run instructions
Run on [model]. Do not ask questions. Do not invoke slash commands.
Append all output under ## Output in this file.

## [Intake data — context, goals, constraints, situation]

## Framework
[Full execution instructions for the subagent]

---

## Output

*(appended by subagent)*
```

**Spec quality bar.** The bar for every brief: the subagent can execute it with **zero questions back**. Before spawning, confirm the brief carries all four:
- **One task + end state** — what to do, and what exists and is true when it's done, plus the repo facts the subagent can't infer on its own
- **Verification loop** — the exact commands or checks the subagent must run, and what passing looks like
- **Scope boundary** — what not to touch, what may stay rough, no unrelated refactors. If the correct result plausibly needs one small edit outside scope (a config entry, an export line), name that file as allowed — a blanket ban forces the subagent to either violate scope or ship a workaround
- **Compact output contract** — what to report back: what changed, how it was verified, anything surprising. Conclusions, not narration

**Step 3 — Show intake summary in chat**
Display 150-250 words covering what was captured. This is what the user reviews and approves — not the full brief or the framework. Say: *"Here's what I captured — [summary]. Does this look right?"*

If the user wants to inspect or edit before running: *"The full brief is at [path] if you want to adjust anything first."*

**Step 4 — Cost warning for Opus**
If the subagent will run on Opus, say before spawning: *"This runs on Opus — noticeably more expensive than a standard session. Proceed?"*

**Step 5 — Spawn the subagent**
After the user confirms, spawn an Agent with the appropriate model:
- Opus 4.8 (`model: 'opus'`): /chess Human Mode, /future narratives + synthesis
- Sonnet (`model: 'sonnet'`): /plan Phases 2+3, /chess System Mode, generic handoffs

Subagent prompt: *"Read [absolute path to brief file], then execute exactly as instructed in that file. Do not ask questions. Do not invoke slash commands. Append all output under the ## Output section of that same file. Your reply back to the main session must be the primary output only (a one-screen summary) — everything else stays in the file."*

**Step 6 — Receive and surface results**
The subagent appends output to the brief file and returns a summary to the main session. Present the key findings to the user for discussion.

**Step 7 — Continue in main session**
Discussion, follow-up decisions, and next steps happen here. Do not start a new session for the debrief.

---

## When to use subagents vs. inline

Use a subagent when:
- The task will generate substantial output (3,000+ tokens) that would bloat main session
- A fresh context window produces meaningfully better output (adversarial analysis, scenario narratives)
- The task is independent enough to run without back-and-forth

Stay inline when:
- The task is conversational or needs real-time course-correction
- The output is short and immediately actionable
- The overhead of a subagent isn't worth it

---

## Generic handoff (no specific command)

When handing off work not covered by /chess, /future, or /plan:
1. Summarize task + context into a brief
2. Save to `docs/handoffs/YYYY-MM-DD-[slug].md`
3. Follow steps 3-7 above
4. After return: read the Output section, integrate results into the main session's work
