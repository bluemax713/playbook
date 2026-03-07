This command is for CLAUDE to invoke, never the user. Generate a parallel session prompt when a task should run in a separate Claude Code terminal with fresh context.

## When to use this

Only when ALL of these are true:
- The task is substantial enough to benefit from a fresh context window
- The task is independent from the main session's current work
- Continuing in the main session would materially degrade output quality
- A subagent within this session can't handle it (too large, needs its own lifecycle)

Do NOT use when:
- The session is almost done anyway
- A subagent would suffice
- The overhead of context-switching outweighs the benefit

## What to generate

Create a complete, self-contained prompt block to paste into a new Claude Code terminal. The block must include:

1. **Context** — Everything the new session needs to know. No assumptions about shared state. Include specific file paths, IDs, table names, and any decisions already made.
2. **Task** — Clear, specific instructions for what to do.
3. **Embedded commands** — If the new session should /plan first, say so explicitly in the prompt.
4. **Output instructions** — Tell the new session to:
   - Save all artifacts to files (not just terminal output)
   - Write a brief summary to `HANDOFF_RESULT.md` in the project root: what was done, what files changed, any decisions made
   - Do NOT run /end — no WORK_LOG update, no PM tool update, no commit. Just do the work and stop.
   - The user will close the terminal when done.

## Format for the user

Present the prompt in a single code block that can be copy-pasted. Preface it with:
- One sentence explaining what the parallel session will do
- "Open a new Claude Code terminal and paste the block below. When it's done, come back here and tell me 'parallel done.'"

## After return

When the user says the parallel session is done:
1. Read `HANDOFF_RESULT.md` from the project root
2. Integrate the results into the main session's work
3. Delete `HANDOFF_RESULT.md` (cleanup)
4. Continue with the main session's work
