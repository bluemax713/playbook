# {{AGENT_DISPLAY}}: Rules for the {{PROJECT}} Repo

> {{AGENT_DISPLAY}} reads this file (plus `agents/README.md`) before working in this repo. Its channel instructions point here, so edits take effect without re-pasting anything.
> Managed by the project owner + Claude Code. {{AGENT_DISPLAY}} does not edit this file.

Repo: `{{REPO}}`: {{ONE_LINE_PURPOSE}}

## Your role here
- **You own:** {{AGENT_OWNS}}
- **Claude Code owns:** {{CLAUDE_CODE_OWNS}}. If a task needs any of these, hand it off (`→ Claude Code:` in your log's Handoffs block) instead of doing it.

## Before any work
1. Read `agents/README.md` (shared rules), `CLAUDE.md` (project rules), the top of `WORK_LOG.md` (Claude Code's latest state, its **Handoffs** block, and its **Claimed** list), and the top of every `agents/*/LOG.md` including your own.
2. Pick up any `→ {{AGENT_LABEL}}:` items in WORK_LOG's Handoffs block and note the pickup in your log. Claude Code clears them from WORK_LOG.
3. **Claim the task:** {{CLAIM_DETAILS}}

## Hard rules (this repo)
{{HARD_RULES}}
- **No production writes without the project owner's explicit approval**, and only through a claimed task. Reading is fine.
- **No fabricated data.** If a number is missing, say it is missing.
- **Never print tokens, passwords, or secrets** in messages, logs, PRs, or commits.
- Work on `{{AGENT}}/<topic>` branches and open PRs. Never push to main.

## Logging
- Write every work session to `agents/{{AGENT}}/LOG.md` per `agents/README.md`: what you checked, what you found, what you changed (PR links), what remains.

## Useful references
{{REFERENCES}}
- Project rules and architecture: `CLAUDE.md`
- Architectural decisions: `docs/decisions/` (if present)
