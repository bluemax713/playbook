# Playbook Work Log

## Last updated: 2026-03-09

## Overall State: v1.0.0 published to npm, dual distribution complete, repo public

## Recent Changes (2026-03-09, session 2)

1. **Fixed /start flow** — briefing no longer blocks on `/rename` response. Rename prompt + briefing in same message. Updated in `commands/start.md`, playbook `CLAUDE.md`, and Max's global `CLAUDE.md`. Pushed to GitHub (ee9017e).
2. **Added Agent Teams to hierarchy** — Level 3 in Parallel Work section. Enabled via `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` env var in both playbook `settings.json` and Max's global `settings.json`. Documented rules (when to use, Opus lead + Sonnet teammates).
3. **Added Ralph Loop to hierarchy** — Level 4 in Parallel Work section. Plugin-based autonomous iteration for well-defined tasks. Install/invoke/cancel instructions included. Documented rules (binary success criteria only, always set max-iterations).
4. **Researched everything-claude-code** — decided NOT to add (developer-focused, wrong audience for non-technical founders). Cross-session learning concept noted as future inspiration.
5. **Researched Claude Code dashboards** — identified existing tools (Claude Code Desktop, Claude Code Crew, ClaudeX, Cox, Beam). Max interested in building/adopting a visual dashboard for multi-project management.

## Recent Changes (2026-03-09, session 1)

1. **Session naming convention** — added to commands/start.md, playbook CLAUDE.md, and Max's global CLAUDE.md. Flow: `/start` prompts user to copy/paste `/rename <project>` before the briefing. One rename, no nagging.
2. **Plugin structure built** — `.claude-plugin/plugin.json`, `hooks/hooks.json` (SessionStart + compact), 6 skills generated from commands
3. **npm package built** — `package.json`, `bin/cli.js`, `lib/installer.js`. Zero dependencies, ESM, Node 18+.
4. **Build script** — `scripts/build-skills.js` generates `skills/` from `commands/` (single source of truth). Verified idempotent.
5. **README updated** — install options: npm first, plugin second, manual third
6. **npm account created** — bluemax713 on npm, 2FA with Touch ID, linked to GitHub
7. **Published `playbook-ai@1.0.0` to npm** — `npx playbook-ai install` works globally
8. **Repo flipped back to public** — all commits pushed (da7deb4)

## Decisions (this session)

- Session naming: one rename at session start only (no topic update). Copy/paste UX with `/rename <project>`.
- Plugin can't inject CLAUDE.md natively — using SessionStart hook instead
- Plugin can't set settings.json permissions — users set up manually
- npm bin field must be object format for publish (`{"playbook-ai": "bin/cli.js"}`)

## Known Issues / Next Steps
- **Plugin marketplace submission** — not done yet. Users can manually install via `/plugin marketplace add bluemax713/playbook`. Submit to Anthropic marketplace when ready (just a PR to their repo).
- **SessionStart hook for natural language invocation** — planned but not yet implemented (e.g., "let's get started" auto-triggering /start)
- **37 early cloners** from March 7 have old version without auto-update — no action needed, they'll find the npm/public repo
- **CHANGELOG discipline** — see auto-memory `playbook-maintenance.md` for rules on when to bump version

## Previous Sessions

### 2026-03-08 (session 2)
- Created npm package structure (package.json, bin/cli.js, lib/installer.js)

### 2026-03-08 (session 1)
- Built auto-update mechanism (VERSION, CHANGELOG, update.sh, start.md update flow)
- Updated settings.json, README.md
- Made repo private temporarily
- Created project auto-memory
