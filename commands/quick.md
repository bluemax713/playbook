Quick mode — for bug fixes, small changes, and one-off tasks that don't need full session ceremony. Runs inline on Sonnet. No subagents.

Skip the full /start briefing. Instead:
1. Read CLAUDE.md (for rules) and the last WORK_LOG.md entry (for context) — don't present a briefing.
2. If the task is ambiguous, ask one targeted question before proceeding. If clear, proceed immediately.
3. Do the task.
4. Update WORK_LOG.md with a brief entry (2-3 lines under a "Quick fix" sub-header of today's date).
5. Commit with a clear message. Never commit .env, credentials, or temp files.
6. If the fix reveals a bigger issue, flag it and suggest creating a task — don't scope-creep.

Do NOT skip: task creation if a bug/gap is discovered. Do NOT skip: committing changes.
