# Changelog

All notable updates to Playbook are documented here. Only impactful changes are listed — new commands, upgraded behavior, and things that make your workflow better. Cosmetic fixes and internal housekeeping are omitted.

## [1.6.4] — 2026-06-08

### Config
- **Token Safety section** — new top-level rule block in CLAUDE.md covering five failure modes that cause silent token burns: ambiguous path exploration, unconstrained filesystem searches, reading build artifacts, tool call chains with no visible output, and multi-target implementation without staged approval. Derived from a real incident where a 1M-token silent burn produced zero user-visible output. Applies globally to all projects.

## [1.6.3] — 2026-06-07

### Commands
- **Spec gate in `/plan`** — before assessing approaches, `/plan` now clarifies the task first. If the desired outcome, scope, or constraints are unclear, Claude asks 1–3 targeted questions and states a one-sentence spec before proceeding. Derived from Karpathy's "ask, don't assume" principle. The spec anchors the rest of the plan.
- **Clarification check in `/quick`** — if the task is ambiguous, Claude asks one targeted question before proceeding. No ceremony, no delay when the task is already clear.

### Config
- **Ask before assuming** — new Development Rule in CLAUDE.md: if a task is ambiguous, ask before implementing. State assumptions explicitly. If multiple interpretations exist, present them — don't pick silently.
- **Surgical changes** — new Development Rule in CLAUDE.md: touch only what was asked for. Don't improve adjacent code, comments, or formatting. Every changed line should trace directly to the request.

Both rules derived from Andrej Karpathy's documented LLM coding failure modes (multica-ai/andrej-karpathy-skills, 132k+ stars).

## [1.6.2] — 2026-06-07

### Config
- **Worktree isolation rule** — added to Agent Team rules in CLAUDE.md: when teammates write to different files in parallel, use `isolation: "worktree"` on each agent call. Each agent gets its own branch, file conflicts are impossible, and worktrees clean up automatically if unchanged.

## [1.6.1] — 2026-06-07

### Commands
- **`/future` agency filter** — the primary output now distinguishes between what's already in motion and what needs a new action. During intake, the constraints beat explicitly asks what's actively underway (critical, must not slip) and what's blocked on a third party. Both land in a new `## What's already in motion` section of the brief. Before writing the primary output, Opus cross-references every output item against this list: third-party waits become "Watching:" notes (not actions); critical in-progress work gets a one-line "Keep going on:" acknowledgment so it isn't forgotten; "Your move this week" is reserved for things the user hasn't started yet and can act on now.

## [1.6.0] — 2026-05-31

### Strategy
- **The council** — `/plan`, `/chess`, and `/future` now convene a contextual council of real-world advisors before committing to a direction. Claude picks 4 relevant figures based on the specific topic — negotiation experts for a deal, product thinkers for a build decision, operators for a scaling question. Each gives their honest take; they disagree where they would. `/chess` runs it before intake (frames the strategic posture going into the move tree). `/plan` runs it when there are meaningful tradeoffs between approaches (before recommending a direction). `/future` runs it after the Opus subagent returns (council reacts to the 3 load-bearing decisions).
- **Command routing** — all three strategic commands now open with a routing check so you land in the right one. Each points to the other two. Simple rule: `/plan` fights bad execution, `/chess` fights an opponent, `/future` fights uncertainty.
- **Progress tracking** — complex `/plan` runs (multi-file, subagent path) now write the implementation steps as a markdown checkbox list to WORK_LOG.md when execution begins. Steps tick off as they complete — progress survives context compression.

### Docs
- **README** — `/chess` and `/future` now appear in the What's Included table and the Commands section. Added the primary enemy framing: each strategic command has a distinct enemy it's designed to defeat.

## [1.5.3] — 2026-05-29

### Commands
- **Model routing documented** — `/debug`, `/end`, `/quick`, and `/new-project` now explicitly state they run inline on Sonnet with no subagents. Prevents future drift when commands are extended.

## [1.5.2] — 2026-05-28

### Architecture
- **Subagent model replaces manual handoffs** — `/chess`, `/future`, and `/plan` no longer generate copy-paste prompt blocks for new terminals. All three now spawn Agent subagents directly, with the appropriate model (Opus 4.6 for `/chess` Human Mode and `/future` narratives; Sonnet for `/plan` and `/chess` System Mode). Fresh context window, results return automatically to the main session. No terminal switching, no copy-pasting.
- **Brief file pattern** — all commands write a structured `.md` brief before spawning. The subagent reads the file (intake data + execution framework); the user reviews a short intake summary in chat (~150-250 words), not the full brief. Output is appended to the same file — brief and results live together as one artifact. Full brief available at `docs/chess/`, `docs/futures/`, or `docs/plans/` for review or editing before running.
- **`/handoff` rewritten** — now defines the canonical subagent pattern: write brief → show summary → cost warning (Opus only) → spawn Agent → receive results → continue in main session. Used as the reference by `/chess`, `/future`, and `/plan`.

### Commands
- **`/plan`** — Phase 1 stays inline (conversational direction-setting). Phases 2+3 (hardening + implementation steps) now spawn a Sonnet subagent for complex plans, keeping the main session lean. Simple plans continue inline. Self-contained — no `/start` required.
- **`/chess`** — Self-contained. Intake summary shown in chat for approval; cost warning before Opus spawn. Chess brief written to `docs/chess/YYYY-MM-DD-[slug].md`; full debrief appended to same file. System Mode: inline Sonnet for simple systems, Sonnet subagent for complex, Opus subagent only when system complexity genuinely warrants it.
- **`/future`** — `/chess` bridge updated: each swing-state adversarial decision gets a 3-sentence context block (what it is, why it's adversarial, what's at stake) plus an explicit recommendation (run / skip) and a direct *"Run /chess on this?"* confirmation. High threshold for recommending run — both material AND genuinely adversarial. Conservative by default: most runs surface zero chess candidates.

## [1.5.1] — 2026-05-28

### Strategy
- **`/future` upgraded to handoff model** — now runs the same way as `/chess`: intake and assumption check in the main session (Sonnet), three narratives and synthesis in a fresh Opus 4.6 parallel session. Keeps main session clean; returns the one-screen primary output via return prompt so the user can discuss it immediately. Self-contained — does not require `/start` to have been run first.
- **Retrospective mode** — on startup, `/future` checks `docs/futures/` for prior runs. If found, offers to run an update that reads what's changed since the prior session and revises the scenarios with actual data. Turns a one-time exercise into a navigation system.
- **Assumption check** — brief pre-scenario check (borrowed from `/plan`): surfaces the 2–3 assumptions baked into the user's success scenario and asks which feel shaky. Shaky assumptions seed The Unraveling, making it specific rather than generic.
- **Synthesis verdicts** — quadrant output now uses ✅ / ⚠️ / ❌ format (borrowed from `/chess` System Mode) for scannability.
- **`/chess` bridge** — swing-state decisions with a real counterparty are flagged `[/chess candidate]` in the output. Creates a natural hand-off between strategic planning and adversarial analysis.
- **Saves to `docs/futures/`** — full output (all three narratives + synthesis + primary output) persisted as a dated file. Primary output returned verbatim to main session for discussion.

## [1.5.0] — 2026-05-27

### Strategy
- **New `/future` command** — scenario planning via three futures (The Win, The Unraveling, The Headwind). Reads project context silently, runs a short intake, then writes three past-tense narratives rewound month by month to today. Synthesizes them via quadrant analysis to surface double-confirmed critical actions, swing-state decisions, and failure drivers. Output is one screen: a thesis, 3 load-bearing decisions (ordered by when they must be made), 3 anti-patterns to avoid (with why they're tempting and the early signal you're sliding in), and your move this week. Full narratives available in appendix on request. Ends with an optional 30-day ClickUp or WORK_LOG check-in. The third scenario (The Headwind) is the one most people skip — it surfaces external forces you need to be resilient against, not just what you did right or wrong.

## [1.4.3] — 2026-05-25

### Performance
- **`/start` context reduction** — removed redundant `CLAUDE.md` read (already injected automatically into every session via system context). Added daily throttle on the Playbook update check: after the first check of the day, subsequent `/start` calls skip the git fetch + curl + CHANGELOG read entirely. Timestamp stored in `~/.claude/.playbook-last-update-check`.

## [1.4.2] — 2026-05-17

### Reliability
- **PreCompact hook** — automatically appends a timestamped marker to `WORK_LOG.md` whenever Claude Code hits the context limit and auto-compaction fires. No more silent mid-session state loss. The marker flags that state above the line may be incomplete and prompts starting a new session. Installed via `hooks/precompact-save.sh`; wired into `settings.json` at install time (additive merge for users who already have a settings.json).

## [1.4.1] — 2026-05-03

### Strategy
- **`/chess` System Mode** — `/chess` now has two modes. Human Mode is unchanged (parallel Opus 4.6 session, move-tree analysis, adversary modeling). New System Mode handles the case where there's no human adversary but a technical plan needs rigorous stress-testing. System Mode runs inline on Sonnet, enumerates every assumption in the plan, attacks each one, and produces verdicts (✅ / ⚠️ / ❌) plus a minimal list of required changes. Escalates to Opus 4.6 inline (no parallel session) for genuinely complex systems. Pre-flight now routes to three paths: Human Mode, System Mode, or `/plan`.

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
