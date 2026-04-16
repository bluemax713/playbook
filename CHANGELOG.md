# Changelog

All notable updates to Playbook are documented here. Only impactful changes are listed — new commands, upgraded behavior, and things that make your workflow better. Cosmetic fixes and internal housekeeping are omitted.

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
