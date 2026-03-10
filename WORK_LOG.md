# Playbook Work Log

## Last updated: 2026-03-10

## Overall State: v1.1.0 live, /new-project command added

## Recent Changes (2026-03-10, session 3)

1. **Added `/new-project` command** — `commands/new-project.md`. Automates full project setup: clone/create repo, terminal alias in `~/.zshrc`, thorough CLAUDE.md + WORK_LOG.md scaffolding, PM integration, initial commit. Key design: CLAUDE.md must be comprehensive (reads entire repo before writing), never a skeleton placeholder. Installed to `~/.claude/commands/` locally.
2. **Set up Wildflower project** — cloned `bluemax713/wildflower` (private) to `~/Documents/GitHub/wildflower/`, added terminal alias `wildflower` to `~/.zshrc`, wrote full CLAUDE.md (ops hub scope — not just reconciliation, covers all Wildflower/Rosie Assoulin operations work), WORK_LOG.md initialized. Three commits pushed.
3. **Updated `~/.zshrc`** — added `alias wildflower='cd ~/Documents/GitHub/wildflower && claude'` to project aliases block.

## Recent Changes (2026-03-09, session 2)

1. **Fixed /start flow** — briefing no longer blocks on `/rename` response. Rename prompt + briefing in same message. Updated `commands/start.md`, playbook `CLAUDE.md`, Max's global `CLAUDE.md` (ee9017e).
2. **Added Agent Teams to hierarchy** — Level 3 in Parallel Work section. Enabled via `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` env var in both playbook `settings.json` and Max's global `settings.json`. Documented rules.
3. **Added Ralph Loop to hierarchy** — Level 4 in Parallel Work section. Plugin-based autonomous iteration. Install/invoke/cancel instructions and rules documented.
4. **Researched everything-claude-code** — decided NOT to add (developer-focused, wrong audience for non-technical founders).
5. **Researched Claude Code dashboards** — identified existing tools (Claude Code Desktop, Claude Code Crew, ClaudeX, Cox, Beam). None match what Max wants.
6. **Version bump to v1.1.0** — CHANGELOG, VERSION updated (e85c775).
7. **Created Cockpit project** — separate repo `bluemax713/cockpit` (private), directory `~/Documents/GitHub/cockpit/`, terminal alias `cockpit` in ~/.zshrc. Handoff prompt generated.
8. **Removed destructive "Use Playbook" from update flow** — CLAUDE.md update now only offers Keep mine / Merge. Full replacement would destroy user customizations (28c8d8c).
9. **Added tech_stack.md convention** — global tech stack registry at `~/.claude/tech_stack.md`. Tracks all tools/services/integrations across projects. Consolidation is a tiebreaker, not a constraint — Claude evaluates best fit and proposes upgrades when warranted. Template added to playbook repo. Max's populated with current stack (ce598f1, a5e3182).
10. **Fixed .playbook-version sync** — now updated alongside VERSION bumps so Max doesn't get false update prompts.

## Decisions (session 2)

- Agent Teams + Ralph Loop: added as Levels 3-4 of parallel work hierarchy
- everything-claude-code: NOT for playbook (wrong audience)
- Cockpit dashboard: SEPARATE project/repo, not part of playbook
- Ralph Loop: verified real (official Anthropic plugin at anthropics/claude-code/plugins/ralph-wiggum/)
- "Use Playbook" option removed from CLAUDE.md update flow — too destructive
- tech_stack.md: tiebreaker not constraint — always evaluate best tool, propose upgrades when warranted
- No version bump needed for post-1.1.0 fixes (prompt-only changes, no functional code changes)

## Known Issues / Next Steps
- **npm publish needed** — `/new-project` command added but npm package not republished yet. Run `npm publish` when ready to ship v1.2.0 (or batch with other changes).
- **Plugin marketplace submission** — not done yet. Users can manually install via `/plugin marketplace add bluemax713/playbook`. Submit to Anthropic marketplace when ready (PR to their repo).
- **SessionStart hook for natural language invocation** — planned but not yet implemented (e.g., "let's get started" auto-triggering /start)
- **37 early cloners** from March 7 have old version without auto-update — no action needed
- **CHANGELOG discipline** — see auto-memory `playbook-maintenance.md` for rules on when to bump version
- **Cockpit** — separate project at `bluemax713/cockpit`. Handoff prompt ready. Not a playbook task.
- **update.sh should install tech_stack.md** — template should be copied to ~/.claude/ during install if it doesn't exist yet

## Previous Sessions

### 2026-03-09 (session 1)
- Session naming convention added, plugin structure built, npm package built
- Published `playbook-ai@1.0.0` to npm, repo flipped to public

### 2026-03-08 (session 2)
- Created npm package structure (package.json, bin/cli.js, lib/installer.js)

### 2026-03-08 (session 1)
- Built auto-update mechanism (VERSION, CHANGELOG, update.sh, start.md update flow)
- Updated settings.json, README.md
- Made repo private temporarily
- Created project auto-memory
