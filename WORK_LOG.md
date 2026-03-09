# Playbook Work Log

## Last updated: 2026-03-08

## Overall State: Auto-update shipped, dual distribution (npm + plugin) planned

## Recent Changes (this session — 2026-03-08)

1. **Built auto-update mechanism** — VERSION, CHANGELOG.md, updated install.sh, new update.sh, updated start.md with silent pre-flight + update flow + CLAUDE.md merge (Keep mine / Use Playbook / Merge)
2. **Updated settings.json** — added permissions for update commands (git -C, bash update.sh, chmod)
3. **Updated README.md** — added Updates section, non-git install option, customization safety language, new files in table
4. **Dry-run tested** — fresh install, re-install with customizations, update with outdated version, curl fallback all pass
5. **Committed and pushed** to main (commit 5a2936b)
6. **Made repo private** — temporarily, until npm package is ready
7. **Created project auto-memory** — playbook-maintenance.md with changelog discipline rules

## Planned: Dual Distribution (npm + plugin)

### Decisions made (approved by Max):
- **npm = primary distribution** — `npx playbook-ai install`, clean `/start` commands, download tracking
- **Plugin = secondary** — ecosystem discovery, `/playbook:start` namespace, auto-updates via plugin system
- **SessionStart hook** — both paths get a hook that auto-invokes skills when user speaks naturally ("let's get started", "plan this out", "I'm done for today")
- **Single source of truth** — commands/*.md are the source, build script generates skills/*/SKILL.md for plugin format
- **Package name** — `playbook-ai` (available on npm). Backups: `cc-playbook`, `the-playbook`
- **npm account** — Max needs to create one (walk him through it)

### Implementation plan (approved):
1. Plugin structure: `.claude-plugin/plugin.json`, `skills/`, SessionStart hook with auto-invocation
2. npm package: `package.json`, `bin/install.js`
3. Build script: generate skills from commands (prevents drift)
4. README: npm first, plugin second, manual third
5. Keep install.sh/update.sh/VERSION/CHANGELOG for npm + manual paths
6. Test both paths end-to-end

### Open questions:
- Plugin CLAUDE.md injection — docs say it works, but needs real testing
- Plugin settings.json may not support permission allowlists — may need to suggest permissions at first run
- Marketplace submission (Anthropic official) — do after launch, just a PR to their repo

## Known Issues / Next Steps
- **Next session:** Build dual distribution (npm + plugin)
- **GitHub repo is currently PRIVATE** — flip back to public after npm package is ready
- 37 unique cloners on March 7 before we made it private — they have old version without auto-update
