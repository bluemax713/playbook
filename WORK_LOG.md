# Playbook Work Log

## Last updated: 2026-03-28

## Overall State: v1.2.1 live on npm + GitHub, plugin marketplace submitted, beginner's guide + README overhaul live

## Recent Changes (2026-03-28, session 9)

1. **WORK_LOG trim cap raised from 25 to 100** — `commands/end.md` updated + synced to `~/.claude/commands/end.md`. At ~12 lines/session, 100 sessions = ~3-4 months before any trimming. No context cost since `/start` only reads header + latest session.
2. **iMessage plugin evaluated** — researched official Anthropic plugin (`anthropics/claude-plugins-official/external_plugins/imessage`). Full two-way iMessage integration via chat.db + AppleScript. **Deferred** — Max found it hacky (not sandboxed, uses your real number, Full Disk Access to all messages, awkward self-chat UX). Saved to auto-memory for future reference if a cleaner mobile input channel emerges.

## Previous Session: 2026-03-23, session 8

1. **README overhaul** — 4 major additions to `README.md`:
   - **Prerequisites section** — Claude Code install instructions for Mac (Terminal + curl) and Windows (VS Code extension or PowerShell). Explains Claude Code vs Claude chat app (context/memory differences). Account requirements + link to Anthropic docs.
   - **"What is a project?" section** — defines project as a self-contained hub, shows folder structure example, explains context isolation between projects, clarifies GitHub is not required.
   - **`/new-project` added** to "What's included" table and Commands section — describes the guided interview process (not just scaffolding).
   - **"After installing" updated** — step 3 now uses `/new-project` instead of manual WORK_LOG creation. Link to GUIDE.md for beginners.
2. **GUIDE.md created** — 235-line beginner's guide for non-technical founders/ops people:
   - 6 sections: What Is This, Key Concepts, Your First Session, Example Conversations, Common Patterns, Tips for Ops People
   - 4 fictional examples using "Sunrise Bakery" (simple update, debugging, complex planning with 3 rounds of back-and-forth, quick fix)
   - Heavy emphasis on planning before execution as the single most important habit
   - Zero developer jargon throughout
3. **`/end` sign-off line** — `commands/end.md` now ends with "Session complete. You can close this window." so users can confirm session ended without scrolling. Synced to `~/.claude/commands/end.md`.
4. **Nomenclature decision** — settled on "project" for top-level repos (what `/new-project` creates), no formal term for subdirectories inside. Rejected "hub" (not natural enough for ops audience) and "workstream" (too close to "workflow").
5. **Committed + pushed** — `55d86fd` on main

## Previous Session: 2026-03-15, session 7

1. **Speedtest CLI integration** — added network diagnostics across 4 playbook files:
   - `templates/tech_stack.md`: new "Diagnostics" section with Speedtest CLI entry
   - `commands/debug.md`: conditional Step 0 — connectivity check only when sessions are slow
   - `README.md`: new "Troubleshooting" section with install instructions and thresholds (>500ms latency, >5% packet loss, <1 Mbps upload)
   - `~/.claude/tech_stack.md` (global): added Speedtest under Diagnostics
2. **Version bump to v1.2.1** — VERSION, CHANGELOG, package.json updated. Published `playbook-ai@1.2.1` to npm.
3. **Committed + pushed** — `bab4a38` on main

## Previous Session: 2026-03-12, session 6

1. **Inbox drop zone convention** — new feature across 4 files:
   - `CLAUDE.md`: new `## Inbox` section — gitignored drop zone, large file warning, implicit intent detection ("check my files" → inbox/), cleanup at /end
   - `commands/start.md`: Step 2 lists inbox files in briefing (name + size), no auto-read
   - `commands/end.md`: inbox cleanup step — extract useful info, move keepers, delete the rest, report
   - `commands/new-project.md`: creates `inbox/` with `.gitkeep`, adds `inbox/*` + `!inbox/.gitkeep` to `.gitignore`
2. **Commands synced** — updated start.md, end.md, new-project.md copied to `~/.claude/commands/`
3. **Committed + pushed** — `6ce6038` on main

## Previous Session: 2026-03-12, session 5

1. **Context bloat fix in `/start`** — `commands/start.md` reads WORK_LOG.md efficiently: first 30 lines + most recent session only (full read if <80 lines). Prevents unbounded context growth across projects.
2. **WORK_LOG auto-trim in `/end`** — `commands/end.md` step 3 trims to 25 sessions max on closeout.
3. **Claude Code version check in `/start`** — nudges users if 2+ minor versions behind v2.0.0.
4. **tech_stack.md template install** — added to both `install.sh` and `update.sh`. Copies template to `~/.claude/tech_stack.md` if missing. Created `templates/tech_stack.md`.
5. **Version bump to v1.2.0** — VERSION, CHANGELOG, package.json, plugin.json, marketplace.json all updated. Published `playbook-ai@1.2.0` to npm.
6. **update.sh improvements** — added `new-project.md` to curl fallback list, added `templates/` directory fetch.
7. **Self-hosted plugin marketplace** — created `.claude-plugin/marketplace.json` + updated `.claude-plugin/plugin.json`. Users can install via `/plugin marketplace add bluemax713/playbook`.
8. **Official Anthropic marketplace** — submitted via form at `claude.ai/settings/plugins/submit`. Awaiting review.
9. **SessionStart hook attempted + reverted** — `SessionStart` is NOT a supported hook type in Claude Code v2.1.x. Available hooks: PreToolUse, PostToolUse, PostToolUseFailure, Notification, UserPromptSubmit. Hook removed from both playbook and Max's settings.json.
10. **Comprehensive CLAUDE.md for magnum** — 94-line file covering tech stack, data pipeline, MCP servers, database/n8n/Metabase rules, session discipline.
11. **Comprehensive CLAUDE.md for rosie-import** — expanded from 32 to ~80 lines. Architecture, vendor conventions, markup types, MCP servers.
12. **Comprehensive CLAUDE.md for palm_beach** — expanded from 87 to ~155 lines. Context log system, audience isolation, all 7 workflows + orchestrators, ApparelMagic rules.
13. **Feedback memory saved** — always sync `commands/*.md` to `~/.claude/commands/` after editing.
14. **Release checklist saved to memory** — 9-step process for version bumps, all files that must stay in sync.

## Decisions (session 5)

- SessionStart hook: NOT supported in Claude Code v2.1.x — will revisit when Anthropic adds session lifecycle hooks
- WORK_LOG trim threshold: 25 sessions (not 3) — months of history before kicking in
- /start reads WORK_LOG efficiently: header + latest session only (not full file)
- Hook trigger: WORK_LOG.md only (not WORK_LOG + CLAUDE.md) — older projects may lack CLAUDE.md
- Version bump 1.2.1 not needed — post-1.2.0 changes are internal packaging only
- Official marketplace: submit once, only re-submit for major versions

## Known Issues / Next Steps
- **Anthropic marketplace review pending** — submitted, awaiting approval. No action needed.
- **SessionStart hook** — blocked on Claude Code adding session lifecycle hooks. Monitor future releases.
- **37 early cloners** from March 7 have old version without auto-update — no action needed
- **CHANGELOG discipline** — see auto-memory `playbook-maintenance.md` for rules on when to bump version
- **Cockpit** — separate project at `bluemax713/cockpit`. Not a playbook task.

## Previous Sessions

### 2026-03-11 (session 4)
- Context bloat fix, WORK_LOG trim, Claude Code version check (merged into session 5 above — same day)

### 2026-03-10 (session 3)
- Added `/new-project` command, set up Wildflower project

### 2026-03-09 (session 2)
- Fixed /start flow, Agent Teams + Ralph Loop, tech_stack.md, Cockpit project created, v1.1.0

### 2026-03-09 (session 1)
- Session naming, plugin structure, npm package, published v1.0.0

### 2026-03-08 (session 2)
- npm package structure (package.json, bin/cli.js, lib/installer.js)

### 2026-03-08 (session 1)
- Auto-update mechanism, VERSION, CHANGELOG, update.sh, settings.json
