Read CLAUDE.md and WORK_LOG.md to understand the project and where we left off.

Check your project management tool via MCP (if available) for current task priorities. If not connected, skip this step and rely on WORK_LOG.md.

Check your auto-memory files for any relevant context from prior sessions.

## Step 0: Check for Playbook Updates

Before anything else, silently check if a newer version of Playbook is available. This must not slow down the session or require user interaction unless there's actually an update.

### Pre-flight (silent — no output to user)

1. Check if `~/.claude/.playbook-version` exists. If not, skip the update check entirely.
2. Read the installed version from `~/.claude/.playbook-version`.
3. Try to fetch the latest version:
   - **If git is available and `~/.claude/.playbook/` is a git repo:** Run `git -C ~/.claude/.playbook fetch origin main --quiet` then read `VERSION` from the fetched main branch using `git -C ~/.claude/.playbook show origin/main:VERSION`.
   - **If git is not available or fails:** Use `curl -sf https://raw.githubusercontent.com/bluemax713/playbook/main/VERSION` to get the latest version.
   - **If both fail:** Skip the update check entirely. Do not mention it to the user. Continue with the normal briefing.
4. Compare the installed version with the latest version. If they match, skip to the normal briefing.

### If an update is available

1. Fetch the CHANGELOG.md content between the installed version and the latest:
   - Via git: `git -C ~/.claude/.playbook show origin/main:CHANGELOG.md`
   - Via curl: `curl -sf https://raw.githubusercontent.com/bluemax713/playbook/main/CHANGELOG.md`
2. Extract only the entries NEWER than the user's installed version. Do not show the entry for their current version.
3. Present to the user:

   > **Playbook vX.Y.Z is available** (you have vA.B.C). Here's what's new:
   >
   > [Relevant changelog entries]
   >
   > Would you like to update?

4. **If the user says yes:**
   - Run `bash ~/.claude/.playbook/update.sh` (if git is available in the playbook dir) or fetch updated files via curl and run the update.
   - After update.sh completes, check if CLAUDE.md has changed between versions:
     - Via git: `git -C ~/.claude/.playbook diff vA.B.C..origin/main -- CLAUDE.md` (or compare the files directly)
     - Or: compare `~/.claude/CLAUDE.md` with `~/.claude/.playbook/CLAUDE.md`
   - If CLAUDE.md has NOT changed upstream: done, continue to briefing.
   - If CLAUDE.md HAS changed upstream, tell the user what changed (summarize the differences in plain language), then offer three choices:
     1. **Keep mine** — no changes to your CLAUDE.md
     2. **Use Playbook** — replace your CLAUDE.md with the new Playbook version
     3. **Merge** — I'll combine your customizations with the new Playbook changes into one file. I'll show you the result before saving.
   - If the user picks **Merge**: read both files, produce a merged version that preserves user customizations while incorporating new upstream content, show it to the user for approval, and only write it after they confirm.

   After any new settings.json permissions are available in the updated Playbook, check if the user's `~/.claude/settings.json` is missing any permissions from the Playbook version. If so, mention: "The new version includes some additional pre-approved permissions: [list them briefly]. Want me to add these to your settings?" Only add with user approval.

5. **If the user says no (skip the update):** Continue with the normal briefing. Do not mention the update again during this session.

---

## Normal Briefing

Present a concise briefing:
- **Where we left off** — last session's work (from WORK_LOG.md)
- **Current status** — what's working, what's not
- **Known issues** — bugs, blockers, pending items
- **PM tasks** — open/in-progress tasks if PM tool is available
- **Suggested next steps** — prioritized list of what to tackle, flagging anything that needs a decision

Keep it short and scannable. Bullet points. No fluff. Wait for direction before making changes.

## Session Naming

**Before the briefing**, prompt the user to name the session. Output only this — nothing else:

> Copy/paste to name this session:
> `/rename <project>`

Where `<project>` is the current directory's basename (e.g., `playbook`). Then **wait for the user to respond** before presenting the briefing. Do not include the briefing in the same message.
