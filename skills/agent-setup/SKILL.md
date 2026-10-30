---
name: agent-setup
description: Sets up or re-syncs the outside-agent coordination pattern (agents/ folder, shared rules, per-agent log and instructions, WORK_LOG handoffs, PM claim tags, branch protection check) so an agent like Claude Duet can work alongside Claude Code without collisions. Outputs a paste-ready channel section. Safe to re-run.
---

Set up (or re-sync) the outside-agent coordination pattern in the current project, so an outside agent such as Claude Duet can work in this repo alongside Claude Code without collisions or lost handoffs. Runs inline on Sonnet. No subagents — with one exception: the PM tag setup in step 6 may route through a Haiku subagent, same as `/start`.

**Usage:** `/agent-setup <agent-name>`. Default agent name: `duet`.

**Idempotent.** Safe to re-run on a repo that is already set up: every step checks what exists first, creates only what's missing, and never overwrites a log. A re-run is how a project picks up a newer `agents/README.md` from the Playbook.

## Step 0: Inputs and templates

1. **Agent name.** Take it from the argument; default `duet`. Normalize to lowercase, one word, no spaces (this is the folder name and the claim tag). Work out two display forms:
   - **Display name** for headings (`duet` → `Claude Duet`; anything else → ask the user, defaulting to the capitalized name).
   - **Label** for handoff lines (`duet` → `Duet`; anything else → the capitalized name).
   - The name `claude-code` is reserved for Claude Code. Refuse it.
2. **Project facts.** Read the project's `CLAUDE.md`, the top of `WORK_LOG.md`, and auto-memory. Get the repo slug with `gh repo view --json nameWithOwner -q .nameWithOwner` (if that fails, use `git remote get-url origin`; if there's no remote, use the directory name and note that branch protection and PR checks don't apply).
3. **Templates.** The canonical files ship with the Playbook:
   - `~/.claude/.playbook/templates/agents/README.md`
   - `~/.claude/.playbook/templates/agents/_template/LOG.md`
   - `~/.claude/.playbook/templates/agents/_template/instructions.md`

   If any is missing locally, fetch it from `https://raw.githubusercontent.com/bluemax713/playbook/main/templates/agents/...` with `curl -sf`. If that fails too, stop and tell the user to update the Playbook. Never improvise the shared rules from memory.

## Step 1: Shared rules (`agents/README.md`)

- **Missing:** create `agents/README.md` as an exact copy of the template.
- **Exists and identical:** say nothing, move on.
- **Exists and differs:** show the diff (`diff -u agents/README.md <template>`), summarize it in plain language, and ask: **Use Playbook** (replace with the template) or **Keep mine**. Never replace it silently. If the local copy has project-specific additions, point them out: those belong in `agents/<name>/instructions.md`, not the shared file, so suggest moving them there.

## Step 2: The agent's folder

- **`agents/<name>/LOG.md`:** create from the template if missing, filling `{{PROJECT}}` (directory basename), `{{AGENT}}`, `{{AGENT_DISPLAY}}`, `{{DATE}}` (today). **If it exists, never overwrite it**, not even with the user's approval: it's the agent's own record. If an existing log lacks a **Handoffs** or **Claimed** block, report that and suggest the agent add it (or add the empty block yourself near the top only if the user approves, touching nothing else).
- **`agents/<name>/instructions.md`:** create from the template if missing (Step 3 fills it). If it exists, leave it alone unless the user asks to revise it; offer to check it against the current template's sections and report any missing ones.

## Step 3: Fill `instructions.md` (new files only)

Draft every placeholder from what you read in Step 0, then show the user the full draft for confirmation before writing. Mark anything you can't source as `[TBD]` rather than inventing it.

- `{{REPO}}`, `{{ONE_LINE_PURPOSE}}`: the repo slug and one line on what the project does (from CLAUDE.md).
- `{{AGENT_LABEL}}`: the label from Step 0.
- `{{AGENT_OWNS}}` / `{{CLAUDE_CODE_OWNS}}`: propose a division of labor and ask the user to confirm. Sensible default: the outside agent owns monitoring, scheduled checks and audits, drafted follow-ups for the user's approval, and small well-scoped PRs; Claude Code owns architecture, production writes, PR review and merge calls, and anything high-risk.
- `{{HARD_RULES}}`: the project's own non-negotiables, drawn from CLAUDE.md and memory: systems the agent must never write to, read-only connectors it must use instead of write-capable ones, audience or data-isolation rules, formatting and time-zone conventions, writing style. One bullet each, bolded lead. Only include rules that actually appear in the sources; cite where each came from when you show the draft. The template already carries the generic rules (no production writes without approval, no fabricated data, no secrets, branches + PRs only), so don't repeat them.
- `{{CLAIM_DETAILS}}`: from Step 6. With a PM tool: where tasks live and the tags (`<name>`, `claude-code`), e.g. "In <PM tool> (<workspace/space/list>): if the task is tagged `claude-code`, don't touch it. Otherwise tag it `<name>` and move it to in progress." Without one: "This project has no PM tool. Add the task under **Claimed** at the top of your log and check every other log's Claimed list first (see `agents/README.md` rule 1)."
- `{{REFERENCES}}`: pointers to where the agent will find IDs, data flow, and exports (CLAUDE.md sections, `docs/`, export folders and whether they're read-only for the agent). Pointers, not copies.

## Step 4: `WORK_LOG.md` Handoffs block

If `WORK_LOG.md` has no `## Handoffs` section, add one directly below the header block (after "Overall State" or equivalent, above the first dated session entry):

```markdown
## Handoffs

Open items addressed to outside agents (rules: `agents/README.md`). The receiver notes pickup in its own log; Claude Code then clears the item here.

- → <Label>: _(none)_

## Claimed

Tasks Claude Code is working right now. Used only when the project has no PM tool (otherwise claim with the `claude-code` tag). Remove a line when done.

- _(none)_
```

Include the **Claimed** block only when the project has no PM tool. If the Handoffs block already exists but has no `→ <Label>:` line for this agent, add one. Touch nothing else in WORK_LOG.

## Step 5: Project `CLAUDE.md` "Other Agents" section

If CLAUDE.md has no "Other Agents" section, add one (end of file, or near any existing integrations section). If it exists, add this agent to it when it isn't listed, and leave the rest alone. Shape:

```markdown
## Other Agents

Outside agents work on this repo between Claude Code sessions. Shared rules: `agents/README.md`. Each agent's rules: `agents/<name>/instructions.md`.

| Agent | Owns | Rules | Log |
|---|---|---|---|
| <Display name> | <one line from instructions.md> | `agents/<name>/instructions.md` | `agents/<name>/LOG.md` |

- **On `/start`:** read every `agents/*/LOG.md` (Handoffs, Claimed, latest entry), check open PRs on `<name>/` branches, skip PM tasks claimed by another agent.
- **On `/end`:** write `→ <Label>:` handoffs into WORK_LOG's Handoffs block; clear items the agent has picked up.
- Outside agents never push to main or edit CLAUDE.md / WORK_LOG.md. Claude Code reviews and merges their PRs.
```

## Step 6: Claim tags in the PM tool

- **PM tool MCP connected:** check whether tags `<name>` and `claude-code` exist in the project's space/board. Create any that are missing (via a Haiku subagent if the lookup is verbose). Report which existed and which were created. Record the location (workspace/space/list names or IDs) for Step 3's `{{CLAIM_DETAILS}}` — these IDs go in the project's own files, never anywhere public.
- **No PM tool:** skip tagging. The Claimed fallback (WORK_LOG Claimed block + each agent log's Claimed block) is the claim mechanism; make sure Step 3 and Step 4 documented it.

## Step 7: Branch protection on main

Outside agents are trusted not to push to main; branch protection is what enforces it.

- Check with `gh api repos/<owner>/<repo>/branches/main/protection` (a 404 means unprotected; if the call errors for a different reason, such as permissions or a plan that doesn't support protection on private repos, say so plainly).
- **Protected:** report it in one line.
- **Not protected:** recommend enabling it (require a PR before merging; no direct pushes). **Do not enable it yourself without explicit approval** — it changes how everyone pushes to this repo. If the user approves, apply it with `gh api -X PUT` and confirm by re-reading the protection.

## Step 8: Commit

Make the changes on a feature branch (never main), commit (`chore: set up agents/ coordination for <name>`), push, and open a PR — docs-only, so mechanical checks suffice. On a re-run with nothing changed, skip this step and say the repo was already in sync.

## Step 9: Paste-ready channel section

Outside agents like Duet often have per-channel (or per-workspace) instructions covering several repos. Those instructions point at repo files rather than copying the rules, so they rarely need re-pasting.

1. **Pick the channel.** Decide which of the agent's channels this repo belongs to, from CLAUDE.md, memory, and what the project is. If it isn't clear, ask the user, and list the channels you know about.
2. **Output the section** in a code block, ready to paste:

   ```
   You work on repo <owner/repo>. Before working in it, read agents/README.md and agents/<name>/instructions.md and follow them. Log work in agents/<name>/LOG.md.
   ```

3. Tell the user: if other repos share this channel, each repo's `/agent-setup` produces its own section; concatenate them into the channel's instructions. Remember the channel choice in auto-memory so a re-run doesn't ask again.

## Summary

End with a short checklist of what was created, refreshed, already in place, or needs the user's action (approve branch protection, paste the channel section, confirm `[TBD]` items in instructions.md).
