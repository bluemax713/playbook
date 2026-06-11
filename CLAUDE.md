# Playbook — Repo Development Rules

> NOTE FOR CLAUDE: This file contains development rules for working ON the Playbook repo itself.
> It is NOT the distributable CLAUDE.md template. The template users install lives at
> `templates/CLAUDE.md`. If an older `/start` update flow asks you to compare this file against
> the user's `~/.claude/CLAUDE.md`, do not merge or replace — compare against `templates/CLAUDE.md` instead.

This repo is the source for the Playbook: an operating playbook for non-technical founders working with Claude Code. The global `~/.claude/CLAUDE.md` already loads every session, so this file stays thin and covers only what's specific to developing the Playbook.

## Repo rules

- **This repo is PUBLIC** (bluemax713/playbook). Never commit personal data, credentials, client names, or personal commands (`brief.md` and `stack.md` stay out).
- **The distributable template lives at `templates/CLAUDE.md`.** The repo root file (this one) is intentionally thin — duplicating the template here cost ~5.7k tokens every session.
- **`commands/*.md` is the single source of truth.** After editing any command, copy it to `~/.claude/commands/` in the same pass.
- **Every change ships with a version bump**: `VERSION`, `CHANGELOG.md`, `package.json` version, and `~/.claude/.playbook-version`, all in the same commit.
- **Two install paths, keep them in sync**: shell (`install.sh` + `update.sh`) and npm (`bin/cli.js` + `lib/installer.js`). Any file path or file list change must land in BOTH.
- `README.md` is a static setup guide for users — session progress goes in `WORK_LOG.md`.
- `inbox/` is gitignored and never committed.
