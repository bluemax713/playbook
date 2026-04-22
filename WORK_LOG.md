# Playbook Work Log

## Last updated: 2026-04-21

## Overall State: v1.3.2 live on npm + GitHub, plugin marketplace submitted, demo project live. No Playbook code changes this session — work was tech-stack hygiene + cross-project integration with consulting repo.

## Recent Changes (2026-04-21, session 13)

This session was a tech-stack audit/cleanup + cross-project plumbing. Zero changes to tracked Playbook files (no version bump). All writes landed in Max's personal config (`~/.claude/`), the consulting repo (parallel session active), and a new personal reference library (`~/Documents/Reference/`).

1. **Tech stack audit/cleanup** (`~/.claude/tech_stack.md`):
   - Added missing entries: `frontend-design` plugin, `code-review` plugin, `Context7` MCP, `feature-dev` plugin (newly installed), `agent-sdk-dev` plugin (newly installed), GitHub MCP, ClickUp MCP (official, OAuth — already installed in a prior session)
   - Moved cockpit-only entries to Deprecated (dated 2026-04-21): React 19 + Vite, Hono, Tailwind v4, shadcn/ui patterns, Bun. Cockpit is in its own repo and tracks them there.

2. **Cockpit paid-services audit** — ran in parallel session via Max. Verdict: zero cockpit-exclusive paid subscriptions, nothing to cancel. Stored API tokens (ClickUp `pk_150234564_...`, n8n JWT) in `~/.cockpit/config.json` flagged as rotation candidates since the project is mothballed — separate hygiene item, not done this session.

3. **Plugin installs** — `feature-dev` and `agent-sdk-dev` (both official Anthropic), no setup required. Researched and ranked 13 marketplace plugins; rejected the rest as off-fit for non-technical-founder audience.

4. **MCP installs / verification**:
   - **GitHub MCP** installed (`@modelcontextprotocol/server-github`). Connected.
   - **ClickUp MCP** discovered as already installed via official HTTP+OAuth endpoint (`mcp.clickup.com/mcp`) — better than the third-party `@chykalophia` package originally researched.
   - Both tools become callable next session (Claude Code only registers MCP tools at session start).

5. **GitHub PAT rotation**:
   - First token leaked into chat transcript (Max pasted it; my prompt invited it). Old token revoked in GitHub settings.
   - New token installed via file-based pattern: `read -s` to prompt + write to `~/.gh-pat-tmp` (chmod 600), then `claude mcp add ... -e "GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ~/.gh-pat-tmp)" ...`, then `rm ~/.gh-pat-tmp`. Token never appeared in transcript.
   - **Lesson learned (saved to feedback memory):** for credential installs, default to file-based passing; don't ask Max to paste tokens directly into chat.

6. **Inbox review + research** (18 files dropped this session):
   - 9 Wize AI Instagram screenshots = a structured 7-subagent codebase cleanup prompt with explicit "what NOT to do" guardrails. Developer-targeted, NOT a fit for Playbook (audience is non-technical founders). Saved as a reusable prompt asset to `~/Documents/Reference/prompt-library/cleanup-7-subagent-pattern.md` for Max's personal use on cockpit/magnum/palm_beach/rosie-import.
   - 8 educational explainer images (Chat-vs-Agent, OBSERVE/THINK/ACT loop, AGENTS.md before/after, MCPs-as-translator before/after, Skills before/after) saved to `~/Documents/Reference/agentic-explainers/` with a README explaining each + IP discipline (don't redistribute, recreate before publishing).
   - 1 RetentionX ad documented in consulting candidates file.

7. **Stack-catalog tee-up workflow** — answered Max's "how do we tee up evaluations for the consulting catalog" question:
   - Created `~/Documents/GitHub/consulting/inbox/stack-catalog-candidates.md` (NOT in `stack-catalog/` — parallel session is writing there). Seeded with 5 candidates: Claude Cowork, MiroFish AI, LangChain/LangSmith, RetentionX, Wize AI 7-subagent prompt pattern. Suggested 3 new categories: Decision-rehearsal/market simulation, Agent observability/eval (enterprise), Process/prompt patterns.
   - Added global rule to `~/.claude/CLAUDE.md` under "Tech Stack Awareness": every future session in any project automatically appends evaluations to the consulting candidates file.
   - Personal config rule, not a Playbook public rule (references Max's specific path).

8. **Auto-memory** — added `reference-personal-library.md` pointer in `MEMORY.md` so future sessions surface `~/Documents/Reference/` when relevant (concept explainers, prompt patterns).

9. **Inbox cleaned** — 18 files deleted at end. All useful information extracted to consulting candidates file, personal reference library, and tech_stack updates.

1. **Inbox folder added** — created `inbox/` directory with `.gitkeep`, added `inbox/` to `.gitignore`. Aligns with all other repos.
2. **Reviewed 19 inbox screenshots** — three sources: Awesome Design MD (@forgoodcode), Second Brain / Karpathy wiki pattern (@thevibefounder), community Claude Code skills (@okaashish). Evaluated each for Playbook fit.
3. **Awesome Design MD — added to README + GUIDE** — new "Design References" subsection under Plugins in README.md. New "Match your UI to a brand you admire" tip in GUIDE.md. 60+ brand design systems (Apple, Stripe, Linear, etc.) via `npx getdesign@latest add <brand>`. Pairs with Frontend Design plugin.
4. **Ops research tip — added to GUIDE** — "Let Claude organize your research" tip under Tips for Ops People. Frames the dump-and-synthesize pattern using inbox/.
5. **Second Brain pattern — evaluated, skipped as feature** — doesn't need a command or folder structure. The pattern (dump raw material, let AI organize) is already embodied by inbox/ + auto-memory. Max confirmed: no wiki command, but the principle is part of the operating philosophy and is now reflected in the guide tips.
6. **Community skills — skipped** — Refactoring UI, UX Heuristics, Hooked UX, iOS HIG Design from @okaashish. Unvetted third-party skills; will revisit when Anthropic marketplace launches.
7. **Auto-memory saved** — reference for Awesome Design MD, surfaces when Max does UI/UX work in any project.
8. **Version bump to v1.3.2** — VERSION, CHANGELOG, ~/.claude/.playbook-version updated. Committed and pushed.
9. **Inbox cleaned** — 19 screenshots deleted after extracting all useful info into README, GUIDE, and auto-memory.

## Previous Session: 2026-04-15, session 11

1. **`/plan` stress test phase** — added Phase 3 to `commands/plan.md`. Automatically pressure-tests plans before presenting for approval: assumption audit, risk war-game, build roadblock scan. Scales depth to plan complexity. Replaces Max's manual "validate your assumptions" prompts.
2. **Version bump to v1.3.1** — VERSION, CHANGELOG updated. Committed and pushed to main.
3. **Synced to personal config** — `~/.claude/commands/plan.md` updated, `~/.claude/.playbook-version` set to 1.3.1.
4. **Feedback memory saved** — always bump VERSION + CHANGELOG + .playbook-version in the same pass as any Playbook change (not as a follow-up).

## Previous Session: 2026-03-30, session 10

1. **Frontend Design plugin — default** — added as default plugin for all Playbook users. `settings.json` has `enabledPlugins` entry, `install.sh` runs `claude plugin install` automatically, documented in CLAUDE.md, README.md, GUIDE.md.
2. **Code Review Agents plugin — recommended** — added to README.md Plugins section as opt-in. Documented install command.
3. **Context7 MCP server — recommended** — added to README.md MCP servers table. Pulls version-specific library docs into Claude's context.
4. **Model routing guidance** — new "Model Selection" subsection in CLAUDE.md under Parallel Work. Replaced rigid "Opus for lead, Sonnet for teammates" with task-complexity principle. Claude picks the model, defaults to stronger, never prompts user.
5. **Max's personal config updated** — `~/.claude/CLAUDE.md` (model routing + plugins), `~/.claude/settings.json` (enabledPlugins), `~/.claude.json` (Context7 MCP added).
6. **Version bump to v1.3.0** — VERSION, CHANGELOG updated. Committed and pushed to main.

## Previous Session: 2026-03-28, session 9

1. **WORK_LOG trim cap raised from 25 to 100** — `commands/end.md` updated + synced to `~/.claude/commands/end.md`. At ~12 lines/session, 100 sessions = ~3-4 months before any trimming. No context cost since `/start` only reads header + latest session.
2. **iMessage plugin evaluated** — researched official Anthropic plugin (`anthropics/claude-plugins-official/external_plugins/imessage`). Full two-way iMessage integration via chat.db + AppleScript. **Deferred** — Max found it hacky (not sandboxed, uses your real number, Full Disk Access to all messages, awkward self-chat UX). Saved to auto-memory for future reference if a cleaner mobile input channel emerges.
3. **Demo project created** — private repo `bluemax713/demo` ("Acme Tees") for teaching friends/family Claude Code + Playbook. Wholesale t-shirt company scenario. Includes:
   - Seed data: 38 SKUs, 8 buyers, 7 orders (21 line items), 1 deliberately messy spreadsheet
   - RUNBOOK.md: modular demo script — 15/30/45/60 min combos (Quick Win, Build Something, The Memory)
   - reset.sh: one-command cleanup between demos
   - Terminal alias `demo` wired in .zshrc

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
