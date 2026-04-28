# Playbook Work Log

## Last updated: 2026-04-28

## Overall State: v1.3.5 live on npm + GitHub. /plan command overhauled — branch trace for high-stakes decisions, phase reorder (harden before writing steps), build blockers embedded per-step.

## Session: 2026-04-28 — /plan structural overhaul (v1.3.4 → v1.3.5)

### What was done
1. **`commands/plan.md` rewritten** — three structural changes:
   - **Branch trace (Phase 1)** — for high-stakes decisions, traces each option 2-3 moves forward to a labeled terminal state (`favorable / acceptable / problematic`). Gated: only fires when cost-of-being-wrong is high. Max 3 branches, 3 moves deep. Compares endpoints, not opening positions.
   - **Phase 2/3 swapped** — assumption audit + risk war-game now run *before* writing implementation steps. Eliminates the rework loop of writing steps that turn out to be wrong.
   - **Build blockers folded into Phase 3 per-step notation** — removed as a separate section, now embedded next to each implementation step.
2. **Synced to `~/.claude/commands/plan.md`** — global installed copy updated in same pass.
3. **`package.json` version corrected** — was stuck at 1.2.1 (missed in prior bumps); updated to 1.3.5.
4. **Version bump to v1.3.5** — VERSION, CHANGELOG, `~/.claude/.playbook-version` all updated.
5. **`playbook-ai@1.3.5` published to npm** — verified live (`npm view playbook-ai version` → 1.3.5).
6. **Committed and pushed** — commits `9f2f1ac` (plan + version) and `a0d9c50` (package.json sync).

### Next
- No pending Playbook code work.

## Session: 2026-04-23 — Model cost audit + policy overhaul (v1.3.3 → v1.3.4)

### Problem
Max's Claude Code sessions were defaulting to Opus 4.7 1M context, costing $40-60/day. Root cause: CLAUDE.md Model Selection section said "default to the stronger model, err on the side of more capability, not cost savings."

### What was done
1. **Rewrote Model Selection in `CLAUDE.md`** — flipped polarity: Sonnet 4.6 is now the default, Opus 4.6 is explicit escalation only (with required one-line heads-up to Max), Haiku 4.5 for mechanical subagent work.
2. **Added concrete Haiku routing table** (v1.3.4) — Haiku for Explore subagents and simple Perplexity lookups; Sonnet for Agent team members, research synthesis, and all implementation work. Prevents "parallel = Haiku" misassumption.
3. **Bumped version to v1.3.4**, updated CHANGELOG, pushed to `bluemax713/playbook` main.
4. **Pinned `claude-sonnet-4-6` in `~/.claude/settings.json`** (Max's personal config — not part of the playbook repo).
5. **Updated personal `~/.claude/CLAUDE.md`** with matching policy (same text as playbook, Max-specific pronouns).

### Key decisions
- Opus 4.6 is the escalation target, never 4.7 — no 1M context premium, same capability class.
- Haiku is "transport layer only" — when Claude relays results, not when it reasons.
- Agent team members always use Sonnet minimum — they do real implementation work.
- settings.json update is manual for playbook users (CHANGELOG explains how); update script doesn't touch personal config.

### Next
- No pending Playbook code work. Haiku-for-agents work is in the openclaw session.

---

## Last updated: 2026-04-22

## Overall State: v1.3.2 live on npm + GitHub, plugin marketplace submitted, demo project live. No Playbook code changes this session — work was a GWS daily-digest skills evaluation that pivoted into building a custom `/brief` command in Max's global config + cross-session plumbing with the consulting catalog.

## Recent Changes (2026-04-22, session 14 — GWS digest evaluation)

Session goal: install and test three mcpmarket "daily brief" Google Workspace skills (Daily Briefing, Weekly Digest, The Day AI Daily Planner); pick one, seed its style profile, document for personal stack + consulting. Zero changes to tracked Playbook files (no version bump). All writes landed in `~/.claude/`, the consulting repo `inbox/`, and a scratch dir for test artifacts.

1. **Investigated all three skills before installing** (hard rule: don't install blind):
   - "The Day AI Daily Planner" (durandom/skills) — ARCHIVED upstream on 2026-02-18 (`BREAKING: Remove the-day skill from active set`). Skipped per hard rules.
   - "Google Workspace Weekly Digest" (pleaseai/claude-code-plugins) — 6-line SKILL.md wrapper that calls `gws workflow +weekly-digest`. The helper ships natively in the gws CLI Max already has.
   - "Daily Briefing for Google Workspace" (mcpmarket listing) — `gws-workflow-daily-briefing` identifier does not exist in any source repo or registry. Closest match is `persona-exec-assistant` (~10-line SKILL.md orchestrating native gws helpers). Advertised "style profile" and "stakeholder weighting" are marketing copy, absent from code.

2. **Audible to Max** — scope as written produced a predetermined outcome (hollow wrappers vs. a CLI Max already has). Max approved Path C: honestly document the three for consulting catalog AND build the real thing (custom `/brief` command) for personal use.

3. **Consulting deliverables** (to `~/Documents/GitHub/consulting/inbox/`):
   - `stack-catalog-candidates.md` — appended new "Daily-digest / morning-brief evaluations (Playbook session, 2026-04-22)" block with 4 one-liners: gws CLI workflow helpers (ADOPTED as real engine), Daily Briefing (NOT ADOPTED, marketing claims don't exist in code), Weekly Digest (NOT ADOPTED, trivial wrapper), The Day (NOT ADOPTED, archived).
   - `aggregator-verification-rule.md` — NEW file, 3-line summary of the mcpmarket.com finding for folding into `stack-catalog/cross-cutting/research-rules.md`. Rule: before recommending any aggregator-listed skill/tool, resolve to upstream source, confirm the identifier exists, read SKILL.md to verify advertised features, check for archival.

4. **Personal config — `/brief` command built end-to-end:**
   - `~/.claude/commands/brief.md` — new slash command. Pulls calendar + unread email + chat + tasks via gws in parallel, ranks with P0/P1/P2/Noise tiers using `~/.claude/stakeholders.md`, extracts literal actions (not fuzzy "think about it" ones), drafts replies in Max's voice using `~/.claude/style-profile.md`. Pure markdown output to `~/.claude/briefs/YYYY-MM-DD-brief.md`. The feature set mcpmarket listings advertised but didn't implement.
   - `~/.claude/style-profile.md` — populated from 6 real sent emails via gws. Captured cues: short replies (1–3 sentences), no pleasantries on internal threads, em-dashes for asides, `Thanks,\nMax` close, single-ask discipline, Superhuman auto-signature.
   - `~/.claude/stakeholders.md` — T1 (advisor@assoulin.com, Eric, Joseph, Gusto, JPMorgan, Hilldun), T2 (@rosieassoulin.com catch-all, Stripe, Shopify, ApparelMagic), T3 (industry newsletters), Noise (no-reply, notifications, Google Groups digests, BoF marketing).
   - `~/.claude/briefs/` — output dir, gitignored.
   - `~/.claude/.gitignore` — protects briefs/, style-profile.md, stakeholders.md, .playbook/tmp/.

5. **Live test run (today, 2026-04-22)** — blocked initially on gws OAuth (`invalid_rapt`), unblocked after Max ran `gws auth login`. Then:
   - Native `gws workflow +standup-report` (JSON + table) saved to scratch.
   - Native `gws workflow +weekly-digest` (JSON + table) saved — 12 meetings this week, 201 unread.
   - Pulled 15 unread emails via `mcp__gws__gmail` + 6 sent for style extraction.
   - `/brief` produced real 2026-04-22 output: 4 P0s surfaced (Gusto wire due 11am PDT, Gusto contractor payments blocked, JPMorgan secure message, Tania LA buyer lookbook request). Native helpers surfaced 0 of these by name — they returned counts.
   - All artifacts in `~/.claude/.playbook/tmp/gws-skill-test/2026-04-22/`.

6. **Deployment recommendation** — two-phase rollout documented at `~/.claude/briefs/deployment-plan.md`:
   - **Week 1 (now → 2026-04-29):** manual `/brief` in Claude Code each morning. Tunes stakeholders + style profile against real drafts.
   - **Week 2+ (2026-04-29):** port logic to Joseph/openclaw. openclaw already runs 24/7 with GWS OAuth via Composio; push brief to Max's phone before he opens the laptop. Claude Code `/brief` stays available for afternoon reruns.
   - Kill criteria: drafts consistently wrong voice → keep /brief, disable drafts; ranking buries P0s → rewrite heuristics, don't migrate; Max ignores by day 5 → format is wrong, redesign.

7. **tech_stack.md updates:**
   - New "Daily Operations" section: gws CLI (googleworkspace/cli) + /brief command (with build context noted: "built 2026-04-22 after evaluating three mcpmarket listings").
   - Deprecated section: three mcpmarket listings added with one-line reasons + dates.

8. **Memory updates:** None this session — findings are either codified in tech_stack.md (durable facts) or in the consulting inbox (to be folded into stack-catalog cross-cutting rules). No new auto-memory entries needed.

## Previous Session: 2026-04-21, session 13 (tech-stack hygiene + cross-project plumbing)

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
- **/brief week-1 tuning (2026-04-22 → 2026-04-29)** — run `/brief` each morning, tune `~/.claude/stakeholders.md` and `~/.claude/style-profile.md` against real drafts. Kill criteria documented in `~/.claude/briefs/deployment-plan.md`. Not a Playbook repo task but worth surfacing here so /start prompts the next session.
- **/brief → Joseph migration (2026-04-29+)** — after tuning, open a Claude Code session in the openclaw project and port /brief logic into Joseph's morning workflow. Directive in deployment-plan.md. Do NOT tell Joseph directly in chat — changes won't stick.
- **gws OAuth expiry** — token refresh failed mid-session today (`invalid_rapt`). Re-auth via `gws auth login`. Expect this to recur every few weeks; factor into any automation that runs /brief unattended.

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
