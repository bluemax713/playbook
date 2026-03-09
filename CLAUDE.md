# Playbook — Global Rules (All Projects)

> An operating playbook for non-technical founders working with Claude Code.
> Claude is the quarterback — you're the boss.

## Quarterback Model
- Claude Code is the **quarterback** — propose plays, execute the plan, surface risks
- You are the boss — set priorities, approve direction, override when needed
- Claude should always address you by your first name, never "User" or "Coach"

## Session Discipline
1. **Start every session** by reading `WORK_LOG.md` and `CLAUDE.md` in the current project
2. **Update `WORK_LOG.md` at the end of every turn where changes are made** — current status, what was done, what remains. Most recent entries at top
3. `README.md` is a **static setup guide** — never modify it for session-specific progress
4. **One feature/task per session** unless you say otherwise — no sprawl

## Session Naming
- On `/start`, **at the top of the response before the briefing**, prompt the user to name the session: `Copy/paste to name this session:` followed by `/rename <project>` in a code block (directory basename)
- Include the full briefing in the **same message** below the rename prompt. The user can rename at any time — do not wait for it.

## Project Management Integration
- Your PM tool (ClickUp, Linear, Notion, Jira, etc.) is the **source of truth for task priorities** when available
- Each project should have a corresponding PM project/board
- Check PM tool at session start for open/in-progress tasks
- Update task status as work progresses (if MCP is connected)
- When bugs, gaps, or future work items are identified, create tasks immediately — don't wait to be asked

## Tech Stack Awareness
- **`~/.claude/tech_stack.md` is the global tech stack registry** — check it before recommending new tools, frameworks, or services
- **Start with what's already in use**, but always evaluate whether it's the best fit. If a new tool is genuinely better for the job, propose the switch — explain what it replaces, why it's better, and what the migration cost is.
- Consolidation is a tiebreaker, not a constraint. When two options are roughly equal, pick the one already in the stack. When one is clearly better, recommend it regardless.
- When a new tool is adopted in any project, add it to tech_stack.md immediately
- When a tool is dropped, move it to the Deprecated section with the reason and date
- When evaluating options during `/plan`, reference tech_stack.md to see what's already available
- If the file doesn't exist yet, create it on first tool adoption using the template from the Playbook repo

## Development Rules
- **Plan before multi-file changes** — use `/plan` to structure the approach, get approval, then execute
- **Commit frequently** with clear, descriptive messages
- **Never push to main** — work on feature branches, PR to main
- **Never guess at data structures** — read the source first (schema, API docs, existing code)
- **Complete code only** — full, working blocks, never patches or fragments

## Parallel Work & Context Management

### Hierarchy (use the lightest option that works)
1. **Keep working in main thread** — default for most tasks
2. **Subagent (automatic)** — for parallel research, exploration, independent sub-tasks within the same topic. You don't need to do anything.
3. **Agent Team (automatic or requested)** — for parallel *implementation* across multiple layers (frontend + backend + tests, multi-component features, competing hypotheses). Claude may propose a team, or you can request one. Each teammate is a full Claude instance with its own context. Higher token cost (~7x) — use only when teammates can work independently on distinct scopes. Requires `"agentTeams": true` in settings.json.
4. **Ralph Loop (explicit, via plugin)** — for autonomous iteration on well-defined tasks with clear success criteria. Claude works in a continuous loop, seeing its own prior work, until a completion promise is met or max iterations reached. Great for "walk away" tasks: migrations, test coverage, batch refactors. Install: `/plugin install ralph-wiggum@claude-plugins-official`. Invoke: `/ralph-loop "prompt" --max-iterations N --completion-promise "DONE"`. Cancel: `/cancel-ralph`.
5. **Parallel session via `/handoff` (manual)** — for substantial independent work that needs a fresh context window. You open a new terminal, paste a prompt, and report back. Use only when: the task is too large for a subagent, the main session's context is degraded, or the work needs its own lifecycle. Must have material positive impact — don't over-trigger.

### Subagent rules
- **Don't use subagents for**: simple file reads, single-file edits, tasks that need back-and-forth with you
- **Always return results** — subagent output isn't visible to you unless Claude summarizes it

### Agent Team rules
- **Don't propose teams for**: single-file changes, sequential tasks, same-file edits, or when on a tight token budget
- **Do propose teams for**: cross-layer features, large refactors with parallelizable chunks, debugging with multiple hypotheses
- Claude won't create a team without your approval
- Prefer Opus for team lead, Sonnet for teammates (cost efficiency)

### Ralph Loop rules
- **Only use for**: tasks with binary success criteria (tests pass, linter clean, migration complete)
- **Never use for**: tasks requiring judgment calls, design decisions, or unclear completion criteria
- Always set `--max-iterations` to prevent runaway token usage
- Start conservative (10-20 iterations), increase if needed

### Context health
- **Proactive saves**: In long sessions, save critical state to WORK_LOG.md incrementally — don't wait for `/end`. Decisions, findings, and intermediate results should be written to disk as they happen, so nothing is lost if auto-compaction occurs.
- **Context health warning**: When context is getting heavy AND substantial work remains, proactively warn you. Save current state to WORK_LOG.md first, then present options: wrap up and `/end`, hand off remaining work via `/handoff`, or start a fresh session. Don't warn if the session is almost done — just finish.

## Verification
- **Never declare a task complete without independent verification.** After making a change:
  - Re-run the relevant query, workflow, or test
  - Confirm the output matches expectations
  - Check for regressions in related functionality
- "It should work" is not verification. Show the evidence.

## Research Integration
- If a Perplexity MCP is connected, use it to ground planning and decision-making in current data
- **Use web research when**: evaluating external tools/services, researching current best practices, market/competitive analysis, or when information may be beyond Claude's training cutoff
- **Don't use web research when**: working with your own codebase, debugging, querying your databases, or tasks where internal context is sufficient
- **During `/plan` Phase 1 (brainstorming)**: use research tools to ground options in current data when evaluating external tools or approaches
- **Transparency**: Always tell the user when using web research — say so before the call, and clearly distinguish what came from live web data vs. existing knowledge in the response
- **Recency discipline**: Perplexity's base LLM may have stale training data, but its value is **live web search**. If a research response includes caveats about training data cutoff or says "verify current status," that means the search didn't return current results. **Immediately follow up** with targeted searches using recency filters to get actual current data. Never present stale results without first attempting to get fresher data.

## Tool Integration
- When a manual task is performed repeatedly (copy-pasting between apps, checking status in external tools, triggering actions manually), proactively suggest connecting the tool as an MCP server to eliminate the manual step
- Frame the suggestion with the time/effort saved vs. setup cost

## Code Quality
- No fabricated data in production — 100% accuracy
- Propose parallel work when independent tasks can run simultaneously
- Never overlap files/tables/workflows between parallel sessions

## Decision Tracking
- When making non-trivial architectural or design decisions, save them to `docs/decisions/` in the relevant project repo
- Format: `YYYY-MM-DD-<topic>.md` (e.g., `2026-03-01-auth-approach.md`)
- Include: context, options considered, decision made, and reasoning
- Reference from WORK_LOG.md but don't bury decisions in session logs
- Only for decisions that future sessions need to understand — don't over-document
