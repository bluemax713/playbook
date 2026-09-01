Session closeout. Do everything needed so the user can walk away without taking notes or remembering anything. The next `/start` must pick up seamlessly. Runs inline on Sonnet. No subagents — with one exception: the PM ticket pull in step 4 routes through a Haiku subagent, same as `/start`.

## Steps

1. **Review what was done this session.** Look at all changes made, files edited, commits created, and conversations had. Don't miss anything.

2. **Update WORK_LOG.md.** This is the critical handoff document.
   - Update "Last updated" date
   - Update "Overall State" headline if it changed
   - Add numbered entries under "Recent Changes (this session)" for everything done — be specific (file names, node counts, what changed and why)
   - Update "Workflow Status" or equivalent current-state section to reflect reality
   - Update "Known Issues / Next Steps" — remove anything completed, add anything new discovered, reprioritize if needed. Be explicit about what's next and what's blocked
   - If any task is partially done, document exactly where it was left off and what remains

2b. **Refresh the project's living workstream map, if one exists.** Check for `docs/WORKSTREAMS.md` (or a similarly-purposed living map named in the project's CLAUDE.md). If present: follow the maintenance rules in its own header, update every workstream the session touched, and bump its "Last refresh" date. If that date shows prior sessions missed the refresh, catch the file up from WORK_LOG.md history before adding the current session. If no such file exists, skip silently.

3. **Compress WORK_LOG.md if needed.** Count the number of entries — dated session headers (`## YYYY-MM-DD` or `### YYYY-MM-DD`) plus any existing `## Compressed:` blocks. If the total exceeds 100:
   - Read the 10 oldest entries (whether raw sessions or prior compressed blocks)
   - Summarize each to 2-3 bullets: what was done, what changed, what was decided
   - Replace those 10 entries with a single block at the bottom: `## Compressed: [earliest date] – [latest date]` followed by the bullet summaries
   - Keep the Overall State / header section intact
   - Result: you drop from 101+ entries to ~92, with history preserved in compressed form
   - This fires roughly once every 9-10 sessions — not every session after the limit

4. **Ticket closure** (if a PM tool MCP is connected). Reconcile the session against the ticket queue so the next `/start` doesn't tee up work that's already finished. This is not optional bookkeeping — skipping it is how future sessions waste time re-opening completed tasks.
   - **Pull the open queue.** Get the project's open and in-progress tasks. If the project has a REST reader script (e.g. `scripts/clickup-tasks.sh`), use it. Otherwise spawn an Agent (`model: 'haiku'`) to query the PM MCP and return a compact list (task name, status, ID) — never pull the list inline, the responses are too verbose.
   - **Match against the session's work.** Compare every open task to what was actually done — including tasks nobody mentioned this session that the work happens to have finished. Match on outcomes, not title similarity: read the task's intent and ask "did this session accomplish it?"
   - **Close completed tasks automatically.** Mark every matched task done/closed via the PM MCP (writes stay on the MCP). Do not ask for confirmation — closing a finished ticket is just recording reality. If a match is genuinely uncertain, leave the task open and flag it in the closeout summary instead of guessing.
   - **Update in-progress tasks** with a one-line status note of where they stand.
   - **Create new tasks** for anything discovered during the session that needs tracking.
   - **Mirror every closure in WORK_LOG.md.** List the closed tickets by name in this session's entry, and delete them from "Known Issues / Next Steps" (or equivalent) so they can't resurface at the next `/start`. A ticket closed in the PM tool but still listed as open in the work log will get teed up again — both records must agree.

5. **Cleanup** — remove temporary artifacts:
   - Delete `HANDOFF_RESULT.md` if it exists in the project root
   - Remove any other temp files created during the session (scratch scripts, debug output, etc.)
   - Do NOT delete docs/decisions/ files — those are permanent
   - **Inbox cleanup:** If `inbox/` exists and has files:
     - Review each file — extract any information that should persist (save to memory, docs, code, etc.)
     - If a file needs to live permanently in the project, move it to the right location (e.g., `docs/`, `templates/`)
     - Delete everything remaining in `inbox/` — the goal is zero files after every session
     - Report what was cleaned up: "Cleaned inbox: deleted X files, moved Y to Z"

6. **Pre-commit checklist** — before committing, verify:
   - All changes tested/verified (not just "should work" — show evidence)
   - No hardcoded secrets, tokens, or credentials in code
   - No uncommitted changes left behind accidentally
   - No temp files being committed
   - Branch pushed to origin

7. **Commit and push.** Stage all changed files, commit with a clear message summarizing the session's work, and push to remote. Do NOT commit .env or credentials.

8. **Present the closeout summary:**
   - **Done this session** — bullet list of completed work
   - **Tickets closed** — which PM tasks were closed (or "none matched"), plus any uncertain matches left open for the user to judge
   - **Left in progress** — anything partially done and where it stands
   - **Next session priorities** — what `/start` will surface as the top items
   - **Action items** — anything that requires action outside of Claude Code

Keep it concise. The goal is zero information loss between sessions.

9. **Shut down all background agents.** Idle spawned agents/teammates block the user from exiting the CLI. Before signing off:
   - Send every named agent/teammate spawned this session a shutdown request via SendMessage: `{"type": "shutdown_request", "reason": "Session closing"}`
   - If any agent is still mid-task, wait for it to finish (or stop it via TaskStop if its work is no longer needed) before sending the shutdown
   - Verify none remain — the user must be able to `/exit` cleanly with nothing left running or idle in the background

10. **Sign off.** After everything above is complete, end your response with a clear, unmissable closing line so the user knows the session is fully wrapped — even if they scroll back later:

   > **Session complete. You can close this window.**
