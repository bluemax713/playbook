Session closeout. Do everything needed so the user can walk away without taking notes or remembering anything. The next `/start` must pick up seamlessly.

## Steps

1. **Review what was done this session.** Look at all changes made, files edited, commits created, and conversations had. Don't miss anything.

2. **Update WORK_LOG.md.** This is the critical handoff document.
   - Update "Last updated" date
   - Update "Overall State" headline if it changed
   - Add numbered entries under "Recent Changes (this session)" for everything done — be specific (file names, node counts, what changed and why)
   - Update "Workflow Status" or equivalent current-state section to reflect reality
   - Update "Known Issues / Next Steps" — remove anything completed, add anything new discovered, reprioritize if needed. Be explicit about what's next and what's blocked
   - If any task is partially done, document exactly where it was left off and what remains

3. **Trim WORK_LOG.md if needed.** Count the number of dated session entries (lines matching `## YYYY-MM-DD` or `### YYYY-MM-DD`). If there are more than 25 sessions:
   - Keep the Overall State / header section intact
   - Keep the 25 most recent session entries
   - Remove everything older — those sessions have served their purpose and the important bits should already be captured in Overall State and auto-memory
   - Do NOT archive to a separate file — just delete. Git history has the full log if ever needed.

4. **Update PM tool** (if MCP is connected). Mark completed tasks as done. Update in-progress tasks with status notes. Create new tasks for anything discovered during the session that needs tracking.

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
   - **Left in progress** — anything partially done and where it stands
   - **Next session priorities** — what `/start` will surface as the top items
   - **Action items** — anything that requires action outside of Claude Code

Keep it concise. The goal is zero information loss between sessions.

9. **Sign off.** After everything above is complete, end your response with a clear, unmissable closing line so the user knows the session is fully wrapped — even if they scroll back later:

   > **Session complete. You can close this window.**
