# Playbook

An operating playbook for non-technical founders working with Claude Code.

Most Claude Code configs are built for developers. This one is built for operators — people who use Claude as their technical co-founder to build and run products without writing code themselves.

## What's included

| File | What it does |
|------|-------------|
| `CLAUDE.md` | Core rules: quarterback model, session discipline, verification, context management |
| `commands/start.md` | `/start` — session kickoff with project briefing |
| `commands/end.md` | `/end` — session closeout with handoff documentation |
| `commands/plan.md` | `/plan` — brainstorm + plan in one command (auto-detects complexity) |
| `commands/debug.md` | `/debug` — 4-step systematic debugging |
| `commands/quick.md` | `/quick` — lightweight mode for small fixes |
| `commands/new-project.md` | `/new-project` — full project setup with guided interview |
| `commands/handoff.md` | `/handoff` — generates parallel session prompts (Claude invokes this, not you) |
| `settings.json` | Permission allowlist for common tools |
| `update.sh` | Handles updates when a new Playbook version is available |
| `VERSION` | Current Playbook version number |
| `CHANGELOG.md` | What changed in each version (only impactful updates) |

## Prerequisites

Before installing Playbook, you need Claude Code — Anthropic's command-line tool that lets Claude work directly on your computer.

**How is this different from the Claude app?** The Claude chat app (claude.ai) only sees what you paste into it and forgets everything between conversations. Claude Code can see your entire project, run commands, make changes to files, and — with Playbook — pick up exactly where you left off between sessions. It's the difference between texting a contractor photos vs. handing them the keys to the building.

### Mac

1. **Open Terminal** — it's already on your Mac. Press `Cmd + Space`, type "Terminal", and hit Enter.
2. **Install Claude Code** — paste this into Terminal and press Enter:
   ```
   curl -fsSL https://claude.ai/install.sh | bash
   ```
   That's it. No other software needed.

### Windows

1. **Install VS Code** — download it free from [code.visualstudio.com](https://code.visualstudio.com)
2. **Install the Claude Code extension** — open VS Code, click the Extensions icon in the left sidebar, search "Claude Code", and install the official Anthropic extension.

Alternatively, open PowerShell and run:
```
irm https://claude.ai/install.ps1 | iex
```

### Account

You need an Anthropic account with a Claude Pro ($20/month), Max, Teams, or Enterprise subscription. Sign up at [claude.ai](https://claude.ai) if you don't have one.

When you first launch Claude Code, it will open your browser to log in. After that, you're authenticated automatically.

For full details, see [Anthropic's Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code).

---

## Install Playbook

### Option 1: npm (recommended)

```bash
npx playbook-ai install
```

That's it. Works without installing anything globally.

### Option 2: Plugin

```bash
/plugin install playbook
```

Run this inside Claude Code. The plugin gives you the same commands as skills (`/playbook:start`, `/playbook:end`, etc.) and includes a SessionStart hook that kicks off your session automatically.

### Option 3: Manual (git clone)

```bash
git clone https://github.com/bluemax713/playbook.git
cd playbook
chmod +x install.sh
./install.sh
```

> **Don't have git?** Download the [latest release](https://github.com/bluemax713/playbook/archive/refs/heads/main.zip), unzip it, and run `./install.sh` from the folder. Updates will still work — they'll use direct downloads instead of git.

## After installing

1. **Edit `~/.claude/CLAUDE.md`** — Replace generic references with your name and preferences
2. **Set up MCP servers** — Connect your project management tool (ClickUp, Linear, etc.), database, and any other services in `~/.claude.json`
3. **Run `/new-project`** to set up your first project — Claude will interview you and create everything you need
4. **Run `/start`** in Claude Code to verify everything works

**New to all of this?** Read the [Beginner's Guide](GUIDE.md) — a plain-English walkthrough of how to use Claude Code and Playbook, with examples.

## Updates

Playbook checks for updates automatically every time you run `/start`. If a new version is available, you'll see a summary of what's new and can choose to update or skip. No surprises — you're always in control.

**Your customizations are always safe.** Updates will never delete or overwrite anything you've personalized:

- **Commands** update automatically (they're standard across all users)
- **`CLAUDE.md`** is never touched without your explicit permission — if the new version has changes, you choose: keep yours, use the new Playbook version, or let Claude merge both together while preserving your customizations
- **`settings.json`** keeps your existing permissions intact — new ones are suggested for your approval, never forced

Everything is transparent. Check `settings.json` to see exactly what's auto-approved. The Playbook source is [open on GitHub](https://github.com/bluemax713/playbook) — every command, every permission, and every update mechanism is visible.

## How it works

### The quarterback model
Claude proposes plays, you call the shots. Claude will always present options and wait for your approval before making changes. You set priorities, Claude executes.

### Session lifecycle
Every session follows a consistent pattern:
- `/start` — Claude reads context, checks your PM tool, presents a briefing
- Work happens — one feature/task per session to prevent sprawl
- `/end` — Claude updates documentation, cleans up, commits, and presents a summary

### Commands
- **`/plan`** — Before complex work. Claude assesses whether brainstorming is needed (multiple approaches? tradeoffs?) and either explores options first or jumps straight to an implementation plan. Always waits for your approval.
- **`/debug`** — When something is broken. Follows: reproduce, isolate root cause, fix, verify. No guessing.
- **`/quick`** — For small fixes that don't need the full session ceremony.
- **`/new-project`** — Sets up a new project from scratch. Claude interviews you — what's the project about, do you have an existing repo or need a new one, do you want to connect a PM tool? Then it creates the repo, wires your terminal shortcut, and generates a comprehensive CLAUDE.md (the rules file) based on what it learned about your project and how you want to work. One command, everything ready.
- **`/handoff`** — Claude uses this (not you) when a task should run in a separate terminal with fresh context.

### Context management
Claude proactively manages session quality:
- Saves state incrementally during long sessions (not just at the end)
- Warns you when context is getting heavy and suggests strategies
- Uses subagents for parallel work automatically
- Generates parallel session prompts when a fresh context would produce better results

### What is a project?

A **project** is a folder on your computer where Playbook keeps everything organized. Each project is a self-contained hub — it has its own rules (CLAUDE.md), session history (WORK_LOG.md), and file drop zone (inbox/).

A project can hold multiple areas of work. For example, a small business might have one project with separate folders inside it for store setup, inventory management, and marketing automations. A corporate team might use one project per department. It's up to you — whatever makes sense for how you organize your work.

Inside a project, Claude organizes work into folders as the scope grows:

```
my-business/
├── store-setup/         — e-commerce configuration
├── inventory/           — stock tracking and reconciliation
├── automations/         — email workflows, notifications
├── docs/decisions/      — architectural and business decisions
├── CLAUDE.md            — project rules (Claude reads this every session)
└── WORK_LOG.md          — session history and handoff notes
```

**Important:** context and connected data sources (databases, PM tools, etc.) are shared within a project but **isolated between projects**. Claude won't accidentally mix up information from different projects unless you explicitly tell it to. This is by design — it keeps your work clean and separated.

**You don't need GitHub.** Projects can live entirely on your computer as local folders. GitHub is optional — useful for backup and collaboration, but not required to get started. The `/new-project` command gives you the choice.

## Recommended MCP Servers

MCP (Model Context Protocol) servers give Claude direct access to your tools — no copy-pasting between apps. Install the ones that match your stack:

| Category | MCP Server | What it does |
|----------|-----------|-------------|
| **Google Workspace** | [Google Workspace CLI](https://github.com/googleworkspace/cli) | Gmail, Drive, Calendar, Docs, Sheets, Chat, Admin — one MCP for all Google services |
| **Project Management** | [ClickUp](https://mcp.clickup.com), [Linear](https://github.com/linear/linear-mcp), Notion | Read/update tasks, check priorities, create issues |
| **Database** | [Supabase](https://mcp.supabase.com), Neon, PlanetScale | Run queries, apply migrations, inspect schema |
| **Analytics** | [Metabase](https://github.com/easecloudio/mcp-metabase-server), Posthog | Query dashboards, pull metrics |
| **Automation** | [n8n](https://github.com/leonardsellem/n8n-mcp-server), Make, Zapier | Read/update workflows, check execution logs |
| **Code Hosting** | [GitHub](https://github.com/github/github-mcp-server) | PRs, issues, code review |
| **Communication** | [Slack](https://github.com/modelcontextprotocol/servers/tree/main/src/slack), Discord | Read/send messages, monitor channels |
| **Research** | [Perplexity](https://github.com/ppl-ai/modelcontextprotocol) | Real-time web search, deep research, current best practices |
| **Library Docs** | [Context7](https://github.com/upstash/context7) | Pulls version-specific, up-to-date documentation for any library directly into Claude's context |

**Authorize broadly, expose everything.** When setting up an MCP server that uses OAuth (like Google Workspace), grant all the scopes/permissions upfront — even for services you don't plan to use immediately. Re-authorizing mid-session requires a browser flow and breaks your workflow. For the Google Workspace CLI specifically, use `-s all --tool-mode compact` to expose every service while keeping the tool list manageable. You can always ask Claude which services are available if you're not sure what's possible.

**The rule of thumb:** If you find yourself repeatedly switching to another app to copy data, check status, or trigger an action — that's a sign you should connect it as an MCP server. Tell Claude "I keep having to manually check X in Y tool" and it will help you evaluate whether an MCP connection would save time.

MCP servers are configured in `~/.claude.json` (global) or in project-level settings. See [Anthropic's MCP docs](https://docs.anthropic.com/en/docs/claude-code/mcp) for setup instructions.

## Plugins

Claude Code plugins add specialized capabilities on top of Playbook. Playbook includes one default plugin and recommends others you can add based on your workflow.

### Default (installed automatically)

| Plugin | What it does |
|--------|-------------|
| **Frontend Design** | Generates distinctive, production-grade frontend interfaces with bold typography, unique color palettes, and creative layouts. You don't need to know you need better UI — this plugin ensures Claude produces polished interfaces by default. |

The Frontend Design plugin is installed automatically by `install.sh`. If you installed via npm or plugin, run this inside Claude Code to add it manually:
```
/plugin install frontend-design@claude-plugins-official
```

### Recommended (opt-in)

| Plugin | What it does | Install |
|--------|-------------|---------|
| **Code Review Agents** | Automated PR code review using multiple specialized agents in parallel. Analyzes comments, test coverage, silent failures, type design, code quality, and simplification with confidence-based scoring. Great if your workflow involves PRs (which Playbook encourages). | `/plugin install code-review@claude-plugins-official` |

## Troubleshooting

**Sessions are slow or timing out?** It might be your connection, not Claude. Install the [Speedtest CLI](https://www.speedtest.net/apps/cli) to rule out network issues:

```bash
brew install teamookla/speedtest/speedtest
speedtest
```

If you see high latency (>500ms), significant packet loss (>5%), or very low upload speeds (<1 Mbps), your connection is the bottleneck. This is common on in-flight Wi-Fi, tethered connections, or congested networks. Claude's `/debug` command will automatically suggest checking connectivity when sessions are sluggish.

## Customizing

This playbook is a starting point. Customize `CLAUDE.md` to fit your workflow:
- Add tool-specific sections (database, CI/CD, deployment platforms)
- Add project-specific rules in project-level `CLAUDE.md` files
- Add new commands in `~/.claude/commands/` for your recurring workflows

**Tip:** You don't need to do any of this manually. Just tell Claude what you want — "set up the Slack MCP server," "add a rule about always running tests," "create a new command for deployments" — and Claude will handle the file edits and configuration for you. Or even just ask Claude, after installing this Playbook, to "/plan review README.md and walk me through everything."

## License

MIT
