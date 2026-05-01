# Changelog

All notable updates to Playbook are documented here. Only impactful changes are listed — new commands, upgraded behavior, and things that make your workflow better. Cosmetic fixes and internal housekeeping are omitted.

## [1.4.0] — 2026-05-01

### Strategy
- **New `/chess` command** — adversarial strategy analysis with full opponent modeling and multi-move branch tracing. Designed for negotiations, competitive decisions, legal disputes, and any high-stakes scenario with a real counterparty. Runs a structured intake in the primary session (Sonnet), then generates a self-contained handoff prompt for a parallel Opus 4.6 session that does the reasoning. The chess session delivers a structured debrief artifact and a return prompt to bring findings back into the primary session. Closes with a clean "Chess session complete. You can close this window." — no /end needed in the parallel session.
- **`/plan` lightened** — branch trace removed. It now lives in `/chess` where adversarial forward-tracing belongs. `/plan` retains its three-phase structure (assess → harden → steps) without the overhead of tracing implementation options forward multiple moves. For decisions involving a counterparty, reach for `/chess`; for implementation decisions, `/plan` is leaner and faster.

## [1.3.5] — 2026-04-28

### Planning
- **Branch trace in `/plan`** — For high-stakes decisions (architecture choices, irreversible actions, multi-system impact), Phase 1 now traces each option 2-3 moves forward to a labeled terminal state. You compare where each path *lands*, not just how it starts. Gated on decision stakes — fires only when the cost of picking wrong is high. Max 3 branches, 3 moves deep.
- **Phase reorder: harden before you write** — Phase 2 (stress test) now runs *before* Phase 3 (implementation steps). Assumption audit and risk war-game validate the chosen direction first; steps are written once, correctly, with all risks already surfaced. Eliminates the rework loop of writing steps then discovering a wrong assumption.
- **Build blockers moved into per-step notation** — Build roadblock scan is now embedded in each implementation step rather than a separate Phase 3 section. Closer to the code that needs it.

## [1.3.4] — 2026-04-23

### Model Routing
- **Concrete Haiku routing table** — replaces vague "mechanical work" guidance with explicit rules: Haiku for Explore subagents, simple Perplexity lookups, file transforms; Sonnet for Agent team members, research synthesis, and everything else. Prevents the incorrect assumption that "parallel = Haiku."

## [1.3.3] — 2026-04-23

### Model Routing (breaking behavior change)
- **Sonnet 4.6 is now the default model.** Previous policy said "default to the stronger model" — this caused Claude to pick Opus for most tasks, producing significant unnecessary API spend. Sonnet 4.6 handles the vast majority of real-world work (config, scripts, debugging, research, documentation) at ~1/5 the cost.
- **Opus 4.6 is the explicit escalation target** (not Opus 4.7, which carries a 1M context premium). Claude must tell you when it escalates and why — you can push back if it's overkill.
- **Haiku 4.5 added for mechanical subagent work** — grep, simple file reads, lookups, transforms.
- **`[1m]` context window variants are banned as defaults.** The 1M window doubles input costs — opt in only for sessions that genuinely need giant context.
- **Cost awareness rule added**: Claude must surface scope before diving into tasks requiring many tool calls, multiple subagents, or a long session.

To complete the switch: add `"model": "claude-sonnet-4-6"` to your `~/.claude/settings.json` (or run `/model sonnet` in any session).

## [1.3.2] — 2026-04-15

### New
- **Inbox folder** — Every project now supports an `inbox/` drop zone for files you want Claude to read. Added to `.gitignore` by default — nothing in it gets committed.
- **Awesome Design MD** — Added to README and Guide as a recommended design reference. 60+ brand design systems (Apple, Stripe, Linear, Notion, etc.) in DESIGN.md format Claude reads directly. Pairs with the Frontend Design plugin. Install with `npx getdesign@latest add <brand>`.

### Guide
- **"Let Claude organize your research"** — New ops tip: dump raw material into inbox/, tell Claude what you need, let it synthesize. You don't have to pre-organize anything.
- **"Match your UI to a brand you admire"** — New ops tip: use Awesome Design MD to make any interface look like a real product.

## [1.3.1] — 2026-04-15

### Improvements
- **`/plan` stress test phase** — Plans now include an automatic Phase 3 that pressure-tests the plan before presenting it for approval. Validates assumptions against actual code/docs, war-games risks with mitigations, and scans for build roadblocks. Scales depth to plan complexity — lightweight for simple changes, thorough for multi-system features. No more manually asking Claude to "validate your assumptions."

## [1.3.0] — 2026-03-30

### Plugins
- **Frontend Design** — installed by default for all users. Generates distinctive, production-grade frontend interfaces with bold typography, unique color palettes, and creative layouts. No opt-in needed.
- **Code Review Agents** — recommended plugin for PR-based workflows. Automated multi-agent code review with confidence-based scoring. Install with `/plugin install code-review@claude-plugins-official`.

### Model Routing
- **Task-complexity model selection** — Claude now chooses which model to use based on task complexity, not role. Defaults to the stronger model; only drops to lighter models for genuinely mechanical work. Replaces the rigid "Opus for lead, Sonnet for teammates" rule.

### New MCP Server
- **Context7** — added to recommended MCP servers. Pulls version-specific, up-to-date library documentation directly into Claude's context. Solves stale-docs problems when working with external libraries.

### Infrastructure
- **`install.sh` installs plugins** — the installer now automatically installs the Frontend Design plugin during setup.
- **`settings.json` includes `enabledPlugins`** — Frontend Design is pre-enabled in the default settings template.

## [1.2.1] — 2026-03-15

### Improvements
- **Network diagnostics** — `/debug` now includes a Step 0 connectivity check when sessions are slow. Runs `speedtest` (if installed) to rule out network issues before diving into code debugging.
- **Speedtest CLI recommended** — Added to tech stack template under new "Diagnostics" section. Install with `brew install teamookla/speedtest/speedtest`.
- **Troubleshooting section in README** — Guidance for diagnosing slow sessions with install instructions and thresholds.

## [1.2.0] — 2026-03-11

### New Commands
- **`/new-project`** — Automates full project setup: clone or create a repo, wire terminal alias, generate comprehensive CLAUDE.md and WORK_LOG.md, connect PM tool, and make the initial commit. One command to go from zero to working project.

### Context Management
- **Efficient WORK_LOG reads** — `/start` now reads only the header + most recent session from WORK_LOG.md instead of the full file. Prevents context bloat as your projects accumulate session history.
- **Auto-trim on `/end`** — WORK_LOG.md is automatically trimmed to 25 sessions on closeout. Older entries are removed (git history preserves them). No manual cleanup needed.
- **Claude Code version check** — `/start` now checks your Claude Code version and nudges you if you're significantly behind. Non-blocking, single-line heads up.

### Improvements
- **Tech stack template** — `tech_stack.md` is now installed automatically during setup and updates (if you don't already have one). Tracks your tools and integrations across projects.
- **`/new-project` in update flow** — The update script now includes the new-project command in its file list.

## [1.1.0] — 2026-03-09

### Parallel Work Upgrades
- **Agent Teams** — added as Level 3 in the parallel work hierarchy. Claude can now propose or you can request multi-agent teams for cross-layer features, large refactors, and parallel implementation. Enabled via `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` env var in settings.json.
- **Ralph Loop** — added as Level 4 in the parallel work hierarchy. Autonomous iteration on well-defined tasks using the official `ralph-wiggum` plugin. Walk-away capability for migrations, test coverage, batch refactors.
- **Updated hierarchy** — 5 levels from lightest to heaviest: main thread → subagents → agent teams → ralph loop → /handoff

### Fixes
- **`/start` flow** — briefing no longer blocks waiting for `/rename` response. Rename prompt and briefing now appear in the same message.

## [1.0.0] — 2026-03-08

### Initial Release
- **Quarterback model** — Claude proposes, you decide. Every session follows this pattern.
- **Session commands** — `/start`, `/end`, `/plan`, `/debug`, `/quick`, `/handoff`
- **Context management** — Automatic state saving, context health warnings, subagent delegation
- **Verification rules** — Claude must prove changes work, not just say "it should work"
- **Permission allowlist** — Pre-configured `settings.json` so common commands don't need manual approval
- **MCP server recommendations** — Curated list of integrations for project management, databases, communication, and more
