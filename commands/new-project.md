Set up a new project for Claude Code — clone or create a repo, wire all local config, and get ready for `/start`.

## Gather Info

Ask the user (skip anything they already provided):
1. **Project name** — this becomes the folder name and terminal alias (e.g., `wildflower`)
2. **Repo situation** — one of:
   - **Existing GitHub repo** — provide the repo (e.g., `bluemax713/wildflower` or a full URL)
   - **Create new repo** — public or private? Description?
   - **No repo yet** — just set up the local folder, wire git later
3. **PM tool** — should a project/list be created in their PM tool (ClickUp, etc.) via MCP? Skip if no PM MCP is connected.

## Execute Setup

Run these steps. Skip any that are already done (e.g., repo already cloned, alias already exists).

### 1. Local repo

- **Existing repo:** `git clone` into `~/Documents/GitHub/<name>/`
- **Create new:** `gh repo create <name> --private/--public --clone` in `~/Documents/GitHub/`
- **No repo:** `mkdir -p ~/Documents/GitHub/<name> && cd ~/Documents/GitHub/<name> && git init`
- If `~/Documents/GitHub/<name>/` already exists, STOP and ask — don't overwrite.

### 2. Terminal alias

- Add `alias <name>='cd ~/Documents/GitHub/<name> && claude'` to `~/.zshrc`
- Place it in the "Claude Code project aliases" block with the other aliases
- If an alias with that name already exists, STOP and ask.
- Run `source ~/.zshrc` so it works immediately in new shells.

### 3. Project scaffolding

Only create files that don't already exist in the repo:

- **CLAUDE.md** — Create a **thorough** project-level CLAUDE.md. This is the most important file — it's what Claude reads every session. Don't leave it as a skeleton.
  - Read every file in the repo to understand the project before writing it
  - Include: what the project does, tech stack table, project structure tree, key conventions/business rules, architecture/data flow, and any environment/credential notes
  - Model it after well-structured examples (tech stack table, project tree with descriptions, business rules table, flow diagrams)
  - If the repo is empty/new, write what you know from the user's description and mark unknowns with `[TBD]` — but still create the full structure so it's easy to fill in
  - Never leave CLAUDE.md as a thin placeholder — a future session should be able to understand the project from this file alone

- **WORK_LOG.md** — Create with:
  ```
  # <Project Name> Work Log

  ## Last updated: <today's date>

  ## Overall State: Project initialized

  ## Recent Changes (<today's date>)

  1. **Project setup** — repo cloned/created, local config wired, ready for `/start`.

  ## Known Issues / Next Steps
  - Run `/start` to begin first working session
  ```

- **inbox/** — Create the directory with a `.gitkeep` inside so git tracks the empty folder: `mkdir -p inbox && touch inbox/.gitkeep`

- **.gitignore** — Only create if one doesn't exist. Use a sensible default based on what's in the repo (Node, Python, etc.), or a minimal one if unclear. **Always include `inbox/*` and `!inbox/.gitkeep`** so the folder exists in the repo but its contents are never committed.

### 4. PM integration (optional)

If a PM MCP is connected and the user wants it:
- Create a project/list in the PM tool
- Note the project ID in WORK_LOG.md for reference

### 5. Initial commit

If new files were created:
- Stage the new files (CLAUDE.md, WORK_LOG.md, .gitignore)
- Commit: `feat: initialize project for Claude Code`
- Push to remote if a remote exists

### 6. Confirm

Present a summary:
- **Repo:** cloned/created at `~/Documents/GitHub/<name>/`
- **Alias:** `<name>` → opens folder + launches Claude
- **Files created:** list what was scaffolded
- **PM:** project created (or skipped)
- **Ready:** type `<name>` in a new terminal to start working, or run `/start` now
