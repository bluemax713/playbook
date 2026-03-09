# Playbook Work Log

## Last updated: 2026-03-09

## Overall State: v1.1.0 published, Agent Teams + Ralph Loop added, repo public

## Recent Changes (2026-03-09, session 2)

1. **Fixed /start flow** — briefing no longer blocks on `/rename` response. Rename prompt + briefing in same message. Updated in `commands/start.md`, playbook `CLAUDE.md`, and Max's global `CLAUDE.md`. Pushed (ee9017e).
2. **Added Agent Teams to hierarchy** — Level 3 in Parallel Work section. Enabled via `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` env var in both playbook `settings.json` and Max's global `settings.json`. Documented rules (when to use, Opus lead + Sonnet teammates).
3. **Added Ralph Loop to hierarchy** — Level 4 in Parallel Work section. Plugin-based autonomous iteration for well-defined tasks. Install/invoke/cancel instructions included. Documented rules (binary success criteria only, always set max-iterations).
4. **Researched everything-claude-code** — decided NOT to add (developer-focused, wrong audience for non-technical founders). Cross-session learning concept noted as future inspiration.
5. **Researched Claude Code dashboards** — identified existing tools (Claude Code Desktop, Claude Code Crew, ClaudeX, Cox, Beam). Max interested in building a visual dashboard for multi-project management.
6. **Version bump to v1.1.0** — CHANGELOG, VERSION updated. Committed and pushed (e85c775).
7. **Cockpit project created** — separate repo `bluemax713/cockpit` (private), directory `~/Documents/GitHub/cockpit/`, terminal alias `cockpit` added to ~/.zshrc. Handoff prompt generated for new session.

## Decisions (session 2)

- Agent Teams + Ralph Loop belong in playbook as Levels 3-4 of parallel work hierarchy
- everything-claude-code: NOT for playbook (wrong audience — developer-focused, not founder-focused)
- Cockpit dashboard is a SEPARATE project/repo, not part of playbook
- Ralph Loop IS real (verified in official anthropics/claude-code repo) despite another session claiming otherwise

## Recent Changes (2026-03-09, session 1)

1. **Session naming convention** — added to commands/start.md, playbook CLAUDE.md, and Max's global CLAUDE.md
2. **Plugin structure built** — `.claude-plugin/plugin.json`, `hooks/hooks.json`, 6 skills generated
3. **npm package built** — `package.json`, `bin/cli.js`, `lib/installer.js`. Zero dependencies, ESM, Node 18+.
4. **Build script** — `scripts/build-skills.js` generates `skills/` from `commands/`
5. **Published `playbook-ai@1.0.0` to npm** — `npx playbook-ai install` works globally
6. **Repo flipped back to public** — all commits pushed (da7deb4)

## Known Issues / Next Steps
- **Plugin marketplace submission** — not done yet. Users can manually install via `/plugin marketplace add bluemax713/playbook`. Submit to Anthropic marketplace when ready (just a PR to their repo).
- **SessionStart hook for natural language invocation** — planned but not yet implemented (e.g., "let's get started" auto-triggering /start)
- **37 early cloners** from March 7 have old version without auto-update — no action needed
- **CHANGELOG discipline** — see auto-memory `playbook-maintenance.md` for rules on when to bump version
- **Cockpit** — separate project at `bluemax713/cockpit`. Handoff prompt ready. Not a playbook task.

## Previous Sessions

### 2026-03-08 (session 2)
- Created npm package structure (package.json, bin/cli.js, lib/installer.js)

### 2026-03-08 (session 1)
- Built auto-update mechanism (VERSION, CHANGELOG, update.sh, start.md update flow)
- Updated settings.json, README.md
- Made repo private temporarily
- Created project auto-memory
