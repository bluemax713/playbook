# Changelog

All notable updates to Playbook are documented here. Only impactful changes are listed — new commands, upgraded behavior, and things that make your workflow better. Cosmetic fixes and internal housekeeping are omitted.

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
