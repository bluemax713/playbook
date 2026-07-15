# Playbook Work Log

## Last updated: 2026-07-15

## Overall State: **v1.7.1 LIVE on npm** (published 2026-07-15, PR #12 merged to main same day). Two `/autopilot` fixes from live-run feedback: the run now reads the real system clock instead of estimating elapsed time (it was landing early), and it lands the moment the manifest is done rather than idling until the hard stop. All version markers aligned at 1.7.1 across npm, main, and `~/.claude/`; plugin marketplace version unchanged at 1.3.0 (no command added or removed). Auto-resume after usage limits: investigated and **parked, decided against** — see [`docs/decisions/2026-07-15-autopilot-usage-limit-auto-resume.md`](docs/decisions/2026-07-15-autopilot-usage-limit-auto-resume.md).

---

## Session: 2026-07-15 — `/autopilot` clock + early-landing fixes (v1.7.1)

Max reported two problems from live autopilot runs: runs kept getting confused about local time and landing early, and a run that finished its work in the middle of the night had no clear instruction to stand down.

**Root cause of the time bug:** a Claude session is given `Today's date is YYYY-MM-DD` and nothing else. No hour, no timezone, no elapsed-time counter. The command never told the run to check the clock, so it estimated elapsed time from work done. That estimate drifts long, so the run believed it was later than it was and wound down early. Phase 5's "time remaining to hard stop?" checkpoint was asking a question the run had no way to answer.

### Done
- [x] `commands/autopilot.md`: new **Clock discipline** standing section — never estimate time, run `date`. Wired into the four places that make time calls: Phase 0 pre-flight (new check #1, records wall clock + timezone), Phase 3 interview (converts "away until 7" to an absolute stamp, reads it back), Phase 4 manifest (takeoff + hard stop as absolute stamps, never durations), Phase 5 wave checkpoints (compute real remaining time)
- [x] `commands/autopilot.md`: Phase 6 rewritten — **"the hard stop is a ceiling, not a schedule."** Land when the manifest is done OR at the hard stop, whichever comes first. Explicit ban on padding remaining hours (no unapproved work, no re-reviewing finished tasks, no polling). New **"Then go dormant"** section: write the report to the run log on disk, then zero token spend until Max returns; cancel anything scheduled earlier. Landing early is framed as a good outcome to report plainly, not a failure.
- [x] `skills/autopilot/SKILL.md` regenerated via `scripts/build-skills.js` (10/10 build)
- [x] Synced to `~/.claude/commands/autopilot.md` (verified byte-identical to source)
- [x] Version bump 1.7.1: VERSION, package.json, CHANGELOG, `~/.claude/.playbook-version`
- [x] Verified: package.json valid JSON, all four version markers read 1.7.1, generated skill contains the new rules, installed copy identical. Prompt-copy change — mechanical checks only per the review rules, no code reviewer needed.

### Closed out same session
- [x] Published `playbook-ai@1.7.1` to npm (verified: `npm view playbook-ai version` → 1.7.1, dist-tag `latest`)
- [x] PR #12 merged to main, branch deleted. Verified main VERSION reads 1.7.1 and all three new rule sections are present on `origin/main`
- [x] Note: published from the feature branch before merging, so npm was briefly ahead of main. Harmless here (identical content) but worth merging first next time — a branch cut from main during that window would start from an already-published version.

---

## PARKED (decided against): `/autopilot` auto-resume after usage limits

**Status: closed 2026-07-15. Full decision record: [`docs/decisions/2026-07-15-autopilot-usage-limit-auto-resume.md`](docs/decisions/2026-07-15-autopilot-usage-limit-auto-resume.md).**

Max asked whether autopilot has built-in cron to restart itself after usage limits expire. Short answer: no cron, and we are not building one. But an undocumented CLI mechanism does exist, which is why this needed a decision doc rather than a log line.

The one-paragraph version: `CLAUDE_CODE_RETRY_WATCHDOG` (undocumented env var, off by default) gates a path in the shipped binary that reads the `anthropic-ratelimit-unified-reset` header and sleeps up to 6h in 30s chunks to resume across a real usage-limit reset. By default the CLI gives up once the wait exceeds 60s, which is why GitHub feature requests describe resume as manual — they describe the default, not the gated path. **Decision: don't build, don't depend on it, and above all don't enable it globally** (it would make interactive sessions silently sleep for up to six hours instead of telling Max the limit was hit). Try it scoped to one terminal if wanted: `CLAUDE_CODE_RETRY_WATCHDOG=1 claude`. Re-open only if a real stall ever occurs.

Two process lessons worth carrying to other projects, both recorded in the decision doc: **read the artifact, not the discussion about it** (GitHub research produced a confident wrong answer twice in this session; the binary corrected it both times), and **control-test a verification method before trusting a negative** (the first check "disproved" the correct agent because `grep -c` chokes on a 241MB single-line bundle — use `rg -a -o -c`).

---

## Session: 2026-07-12 — Built `/autopilot` (v1.7.0)

New command for when Max is away for hours: pre-flight → harvest (parallel Haiku subagents) → GREEN/YELLOW/RED triage → one batched interview (context + recommendation per question) → manifest approval gate (doubles as the dry run — no separate dry mode) → flight (handoff-pattern Sonnet subagents, worktree isolation, waves, reviewer ≠ author, two-strikes parking, run log at `docs/autopilot/`) → landing report with merge queue. Hard rails: never merge/publish/deploy/send/delete; never guess (park + queue question). Scope: ONE project per run (Max corrected from multi-project mid-design); PM writes allowed anytime; `/autopilot resume` continues from the run log.

### Done
- [x] `commands/autopilot.md` written (196 lines)
- [x] `update.sh` curl fallback: added autopilot + fixed stale list (chess.md, future.md were missing — gitless users never got them)
- [x] `scripts/build-skills.js`: added SKILL_META for autopilot + missing chess/future/new-project (plugin build was failing on 4 commands); regenerated `skills/` — 10/10 now build
- [x] `.claude-plugin/marketplace.json` description updated
- [x] README: table row + Commands section entry
- [x] Version bump 1.7.0: VERSION, package.json, CHANGELOG, `~/.claude/.playbook-version`
- [x] Synced to `~/.claude/commands/autopilot.md` (global) + copied to `emd-secure/emd-platform/.claude/commands/` (dir created; left uncommitted in that repo)
- [x] Verified: bash -n both scripts, JSON valid, versions consistent, curl list == commands dir

### Closed out same session
- [x] Independent review (code-reviewer agent): 2 findings in the command's safety language — hard rails said "no exceptions" while Phase 6 merges greenlit PRs; interview whitelist readable as overriding the never-list. Both fixed (rails scoped to unattended phases, explicit Phase 6 interactive carve-out, whitelist barred from the never-list); same reviewer confirmed resolved, nothing new introduced
- [x] Plugin marketplace version bumped 1.2.0 → 1.3.0 (plugin gains a command)
- [x] PR #9 merged by Max; branch deleted
- [x] `npm publish` — **playbook-ai@1.7.0 live** (2026-07-12)

### Remains
- [x] EMD copy committed same session after all — via isolated worktree (no contact with the active EMD session's tree), PR #35 merged to emd-platform main (`c2fa8fb`). Nothing remains.

---

## Session: 2026-07-10 — Evaluated fable-108010 skills (from Lee); harvested 3 ideas → v1.6.12

Lee sent two community skills (`fable-108010` + `-codex` variant): Fable plans 10%, Codex codes 80%, Fable reviews 10%, with an adversarial plan-review gate in the variant.

**Evaluation verdict: don't adopt as-is; harvest the best parts.** The skill's economics are inverted for Max (built for abundant Codex quota + scarce Claude quota; Max is the reverse). Adopting would also reverse the 2026-06-26 Codex decision (dispatch target, no pre-provisioning). Perplexity pricing pull (July 2026): Codex is ~3–7x cheaper **per task** (token efficiency, ~4x fewer tokens), but Claude is cheaper per token (Sonnet 5 intro $2/$10 vs GPT-5.5 $5/$30) and leads quality on hard work (SWE-bench Pro 69.2 vs high-50s/low-60s). Deciding variable for ever adding Codex: whether Max regularly hits Claude subscription caps.

### Done (v1.6.12)
- [x] `/plan`: optional red-team gate at end of Phase 2 — fresh Sonnet subagent attacks risky plans; findings triaged as inputs; same-reviewer confirm loop; skip for simple plans or `/chess`-tested ones
- [x] `/handoff`: spec quality bar in Step 2 — one task + end state / verification loop / scope boundary with pre-authorized touches / compact output contract; zero-questions-back bar
- [x] `templates/CLAUDE.md` + personal `~/.claude/CLAUDE.md` Verification: never accept self-reported success; green suite ≠ end-to-end (drive one live call across seams). Personal copy synced + pushed to claude-personal
- [x] Source SKILL.md files archived to **claude-personal (private)** `reference/codex-orchestration/` as the future Codex setup map — deliberately NOT in this public repo (third-party authorship)
- [x] Synced plan.md + handoff.md to `~/.claude/commands/`; bumped VERSION, package.json, CHANGELOG, `.playbook-version` → 1.6.12
- [x] Stack-catalog tee-up line appended (consulting inbox)

### Shipped
- [x] PR #7 merged to main (docs-only; mechanical checks: package.json valid, version markers aligned, command-sync diff-verified). npm publish confirmed live: `npm view playbook-ai version` → 1.6.12
- Note: the merge pull also brought in Max's 2026-07-02 `end.md` fix (step 9, background-agent shutdown) that this machine's local main lacked; installed copy verified in sync
- Message to Lee drafted + clipboard'd (evaluation verdict in one line); Downloads cleaned (2 folders + 2 zips removed, content archived in claude-personal)

---

## Session: 2026-06-26 (2) — Codex handoff setup: decided to NOT pre-provision

Discussion only, no code. Question: set up Playbook or CEP *inside* Codex for the `/goal` handoffs?

**Decision: No — keep handoffs stateless, gate any setup on the first real Codex job.**
- **Playbook in Codex → no (category error):** its value is Claude-Code session ceremony (`/start`, `/plan`, WORK_LOG, model routing). Those are Claude-harness slash commands; they don't execute in Codex's runtime. Codex is a dispatch target, not a quarterback.
- **CEP in Codex → no (redundant):** CEP ships Codex converters, but the only thing we want from a Codex job is a PR that passes our bar — and that loop is already closed on the Claude side via `/ce-code-review` before merge. Standing up the full `/ce-*` suite in a tool we don't daily-drive = the speculative setup the gate already forbids.
- **The one real gap + the right fix:** Codex reads `AGENTS.md` at repo root (its native instructions convention, the way Claude reads CLAUDE.md). So when the first Codex job lands, the lightweight move is a thin `AGENTS.md` in the target dev repo mirroring the must-honor rules (branch/PR discipline, no-push-to-main, commit format). That's a **repo artifact, not a second tool** — context travels with the repo; job-specific context travels in the `/goal` brief; review stays on the Claude side.
- **Optional, declined for now:** a throwaway `/goal` smoke test (junk task → confirm a PR comes back) to de-risk the *mechanics* before a real job depends on them. Max chose to leave it parked.

**Net:** nothing to set up in Codex now. First fitting job triggers it; Claude flags + drives the setup then (write `AGENTS.md`, confirm correct Codex identity per repo — EMD still needs its own isolated login).

---

## Session: 2026-06-26 — CEP + Playbook coexistence (v1.6.11)

Evaluated Every's compound-engineering-plugin (CEP) vs Playbook; decided **Option C: coexist** (CEP owns code pipeline, Playbook stays operating shell) on clenta + emd-platform. Validated via `/chess` System Mode. Decision doc: `docs/decisions/2026-06-26-cep-playbook-coexistence.md`.

### Done
- [x] `## Working with CEP` section added to **clenta/CLAUDE.md** and **emd-platform/CLAUDE.md** (routing map, memory-ownership map, `/lfg` guardrail, escape hatch) — *uncommitted in those repos, commit in their own sessions*
- [x] Playbook cross-grounding (v1.6.11): `/start` surfaces `docs/solutions/` in briefing; `/plan` + `/chess` skim it on technical work — all conditional/no-op without the dir
- [x] Synced 3 commands to `~/.claude/commands/`; bumped VERSION + package.json + .playbook-version → 1.6.11; CHANGELOG entry
- [x] Records: decision doc; `~/.claude/tech_stack.md` (CEP row); consulting stack-catalog candidate line
- [x] Committed playbook on branch `cep-coexistence` (Option 3 — dev repos left uncommitted)

### Rollout status
- [x] CEP installed **local scope (Max-only, per-repo)** in clenta + emd-platform — NOT user scope (avoids ambient token cost on ops/playbook projects). Marketplace add must be re-run per repo (didn't carry across sessions). Plugin healthy v3.14.3.
- [x] `/ce-setup` + machine-local `.compound-engineering/config.local.yaml` (gitignored) in both repos. Codex-delegation section left OFF.
- [x] Routing + memory-ownership + `/lfg` guardrail + **exclusion line** (`/ce-work-beta` + `/ce-proof` off) in both CLAUDE.md files. Committed in-session per repo.

### Also done (2nd half of session)
- [x] **Plain-English comprehension layer** added to both clenta + emd-platform CLAUDE.md (`### Plain-English layer`). Default altitude **plain-first, detail on request** (Max's pick). I translate dense CEP output (plan, review, learnings) into plain terms + decisions; hard rule = simplify language, never drop a risk. *Uncommitted in both dev repos.*
- [x] **Codex (OpenAI) evaluated** via Perplexity (live web, June 2026 data). Findings: Codex = multi-surface agentic platform on GPT-5.5; its `/goal` command (autonomous run to a verifiable finish line) is the standout. Benchmarks: Claude Opus 4.8 LEADS multi-file repo work (SWE-bench Pro 69 vs 59); Codex leads terminal-bench + cost-steadiness on long grinds. Verdict: don't daily-drive Codex — use it as a **dispatch target**.
- [x] **Codex handoff rule** written into both dev projects' CLAUDE.md (`### Codex handoff`). Model: Claude stays quarterback, flags when a job fits Codex, writes the `/goal` brief, Max pastes + walks away, reports back, Claude reviews the PR (`/ce-code-review`) before merge. **Threshold = equal-or-better OUTCOME for same-or-less cost while freeing Max + the main session** (NOT "better code" — Claude leads on quality; the win is fit + offload). 3 gates: fit / quality-floor / leverage. *Uncommitted in both dev repos.*

### Still pending
- [ ] **Commit pending dev-repo edits in their own sessions:** clenta + emd-platform each have uncommitted `### Plain-English layer` + `### Codex handoff` additions to CLAUDE.md (commit on next `/start` in each)
- [ ] First test: `/ce-brainstorm` → `/ce-plan` on a small clenta feature (with Max, to learn the loop) — THE top next-action; everything else is set up
- [ ] **Codex install is gated on a real candidate job** — don't set up speculatively. When the first fitting job appears: clenta uses Max's personal Codex identity; **EMD needs its OWN isolated Codex login** (mirrors `~/.claude-emd` separation, EMD = separate LLC). Verify exact config-dir/env-var switching mechanism at install time.
- [ ] **Decide-later gate (~mid-July):** if coexistence proves out, add optional caveated CEP pointer to README/GUIDE

### Notes
- CEP's other-LLM converters (Kimi/Codex/Cursor/etc.) are Every's distribution plumbing — never load into Claude context, zero token cost. Only `/ce-*` skill descriptions load, and only where the plugin is enabled.
- CEP model-routing (semantic tiers, no hardcoded model names, capability-aware) evaluated for porting into Playbook → **not worth it** (Playbook too small-scale; already has cost-warnings + centralized model guidance). Revisit only if Playbook grows a wide fan-out surface.

---

## Session: 2026-06-24 — Fix /start InputValidationError (v1.6.10)

### Done
- **Diagnosed (in a subagent, per Max's ask)** a recurring `InputValidationError` at session start: the Agent/Task tool's `model` param only accepts short aliases (`sonnet|opus|haiku|fable`), but `commands/start.md:9` spawned the PM-task helper with the full ID `model: 'claude-haiku-4-5'`. Error fired on every start where a PM tool MCP (ClickUp etc.) is connected. Only broken spawn in the repo — chess/plan/handoff already use short aliases.
- **Fixed** `commands/start.md:9` + installed copy `~/.claude/commands/start.md:9` → `model: 'haiku'`.
- **Version bump 1.6.9 → 1.6.10**: VERSION, package.json, `~/.claude/.playbook-version`, CHANGELOG (all four in sync, verified).
- **PR #2 opened and squash-merged to main**, branch deleted. Local back on main, pulled.

### Pending
- **npm publish 1.6.10** — held at Max's request (not at computer). Commands: `npm login` then `cd ~/Documents/GitHub/playbook && npm publish --access public`.

### Note
- Root cause is a rule-application slip, not a bad rule: "always use explicit model IDs" governs the **session** model (settings.json / `--model`), NOT the Agent tool's `model` param. Worth keeping in mind for any future command that spawns Agents.

---

## Session: 2026-06-14 (2) — Optional statusline extra (v1.6.9) + personal backup

### Done
- **Vetted a third-party statusline** Max's brother sent (`~/Downloads/claude-statusline/`): read all 3 files line-by-line. Clean — no injection/exfil/file-writes/obfuscation; reads stdin JSON via jq, read-only git/gh, prints colored text. Zero token cost (local script, not a model call).
- **Installed + customized for Max**: copied to `~/.claude/statusline.sh` (checksum-verified), wired `statusLine` block into `~/.claude/settings.json`. Per Max's preference, stripped ALL faces — the `mascot_for` mood-emoticons on the usage line AND the `($‿$)` money-eyes cost easter egg — and switched reset times to AM/PM (`%I:%M %p`). Verified face-free render at multiple usage states.
- **Part A — personal backup**: committed customized `statusline.sh` to `claude-personal` repo (f33c7f7, pushed). `install.sh` now copies it to `~/.claude/`; README documents the settings.json block (not auto-wired). settings.json itself is not versioned there.
- **Part B — public Playbook (final: DEFAULT-ON, not opt-in)**: source lives at `extras/statusline/` (statusline.sh + preview.sh + README). Max challenged "why optional" — value of a usage dashboard is wasted if buried. Resolved the light-bg blocker (see below), then made it **install by default**:
  - `statusLine` config ships in the repo default `settings.json`. Installers write settings.json ONLY when the user has none → an existing custom statusLine can never be clobbered (non-destructive by construction).
  - `statusline.sh` copied **install-if-missing** in all 3 entry points (install.sh, lib/installer.js, update.sh) — same pattern as CLAUDE.md, so user color tweaks survive updates. installer.js also mirrors `extras/` into `.playbook/`; update.sh fetches it in the curl path.
  - Bumped VERSION/package.json/CHANGELOG → 1.6.9, `extras/` in npm files array, live `.playbook-version` → 1.6.9. **PR #1 open.**
- **Light-background fix**: only ONE element was invisible on white — the pace marker over the empty track (was pure white `\033[97m`). Changed to bright sky-blue (256-color `39`): pops on dark, readable on white. Everything else (colored blocks, reds, gray track) already readable on both. Max's call: optimize for dark (most users), just don't break on light. Synced to all 3 copies (checksums match) + committed to claude-personal.
- **Two independent reviews** (code-reviewer subagent, ≠ author). R1 (script): security clean, no injection/exfil. R2 (install wiring): both paths in sync, non-destructive holds, version discipline consistent; fixed 2 findings (npm `.playbook` extras mirror was missing; stale "optional default" comment). Declined the "marker stuck at cell 0 early in window" flag — inherent to an 8-cell discrete bar, not a bug.
- **Verified**: fresh install via BOTH install.sh and installer.js lands script+config and renders; existing settings.json with custom statusLine preserved; `.playbook/` extras mirror seeded for npm updates; bash -n / node --check / jq gates pass.

### Remaining
- **Merge PR #1** (Max's product call) — then **npm publish 1.6.9** (Max's explicit trigger; not auto-run).
- After merge, delete local `feat/optional-statusline` branch.

### Notes
- Provenance: Max waved off "who wrote it" for personal use (correct — it's safe). For the public republish we kept a neutral "adapted from a community statusline" credit + the original's public-domain license note. Optional confirm-with-brother on origin, low-stakes.
- Branch is still named `feat/optional-statusline` though the feature shipped as default-on — cosmetic, not worth renaming mid-PR.

## Session: 2026-06-14 — Fable cleanup + Iris caching pattern + v1.6.8 npm publish

### Done
- **Fable removal verified clean**: Anthropic removed the Fable model. `~/.claude/settings.json` is `model: opus` with zero Fable refs; grep across all commands, `templates/CLAUDE.md`, and installed `~/.claude/CLAUDE.md` clean. Default policy (Sonnet 4.6 → Opus 4.8) was always the real plan; Fable was only ever a one-session manual pin. Memory `fable-pin-temporary` tombstoned. Only residue: historical mentions in this WORK_LOG (harmless).
- **Iris caching plan preserved** (cross-project, off-Playbook ask): the untracked `prompt-caching-iris-api.md` existed identically in clenta (canonical home) + nanoclaw (at-risk copy). Per Max's choice, extracted the generalizable pattern to `~/Documents/Reference/prompt-library/anthropic-prompt-caching-agentic-loops.md`; full Iris-specific version backed up at `~/Documents/Reference/preserved-plans/prompt-caching-iris-api.2026-06-14.md`. `reference-personal-library` memory updated to surface both.
- **v1.6.8 published to npm**: caught a version-sync bug — the v1.6.8 commit had bumped VERSION + CHANGELOG but missed `package.json` (still 1.6.7), which would have blocked publish. Bumped package.json → 1.6.8, bumped local `.playbook-version` → 1.6.8, verified dry-run pack ships templates/CLAUDE.md, committed + pushed (1bac836). Max ran `npm publish`; confirmed `npm view playbook-ai version` = 1.6.8 (published 14:15Z).

### Notes for next session
- **Process gap to watch**: the v1.6.8 commit missing package.json shows the "bump all four markers in one commit" rule (VERSION, CHANGELOG, package.json, .playbook-version) can slip on cross-session drive-by commits from other projects. Worth a pre-publish checklist or guard.
- `WORK_LOG.md:67` (older session) flags a stale model-policy line in the template — now doubly stale post-Fable. Candidate cleanup for a future release.

## Session: 2026-06-12 — Merge & Review Workflow (v1.6.8, cross-session drive-by from clenta)

### Done
- **New template section `## Merge & Review Workflow`** in `templates/CLAUDE.md` (after Development Rules): user approves product intent, Claude owns technical confidence; review gates scaled to risk (docs = mechanical only; code = independent reviewer agent distinct from the author + type/lint gates; high-risk surfaces = reviewer + behavioral verification/staged rollout); merge calls presented in product terms with risk rating.
- CHANGELOG 1.6.8 entry, VERSION bumped 1.6.7 → 1.6.8.
- Context: born in clenta Session 189 — Max stated he does not technically review PRs ("you will have to run your own checks/validations"). The same section (Max-personalized wording) was added to the live `~/.claude/CLAUDE.md` and synced to claude-personal (commit da1689d) in the same pass.

### Remaining
- npm publish for 1.6.8 not run from this session — do it from a proper playbook session if npm distribution matters for this version.

## Session: 2026-06-11 (3) — Bucket 1: CLAUDE.md template restructure (v1.6.7)

### Done
- **Template moved**: `CLAUDE.md` → `templates/CLAUDE.md` (git mv, history preserved)
- **New thin repo-root CLAUDE.md**: dev rules only (~20 lines) with a guard note telling older /start update flows the template moved. Kills the ~5.7k tokens/session duplication when working in this repo
- **Path updates in both install paths**: install.sh copy source; update.sh curl list (root CLAUDE.md removed, templates/CLAUDE.md added as required fetch); lib/installer.js (copy from templates/, PLAYBOOK_SOURCE_FILES trimmed, templates/ now mirrored into .playbook/templates/)
- **start.md merge comparison** → `~/.claude/.playbook/templates/CLAUDE.md`; synced to ~/.claude/commands/
- package.json files list and README repo table updated
- **skills/ regenerated** via scripts/build-skills.js — caught stale drift in end/handoff/plan/quick/debug SKILL.md from 1.6.5–1.6.6 (build script hadn't been run those releases)
- Verified: bash -n both shell scripts, node --check installer.js, npm pack dry-run ships templates/CLAUDE.md, grep clean for stale paths
- Bumped VERSION, CHANGELOG, package.json, ~/.claude/.playbook-version to 1.6.7. Committed and pushed (da4043b)

### Notes
- build-skills.js warns: no SKILL_META for chess/future/new-project — pre-existing, those commands generate no skill. Possible future fix
- Transition risk accepted: users updating from <1.6.7 via curl fallback get the thin root CLAUDE.md in .playbook/; the guard note in that file steers Claude away from a bad merge

### Also this session
- **npm published**: playbook-ai@1.6.7 live (Max ran publish; npm now current through 1.6.7)
- **Bucket 6 resolved**: created PRIVATE repo bluemax713/claude-personal (~/Documents/GitHub/claude-personal) holding commands/brief.md, commands/stack.md, global CLAUDE.md, tech_stack.md + install.sh (commands always copy; CLAUDE.md/tech_stack.md only if missing). Sync rule added to global ~/.claude/CLAUDE.md as "Personal Files Versioning" section: edit live file in ~/.claude/ → commit to claude-personal same pass. Verified: repo PRIVATE, pushed, working tree clean
- Local ~/.claude/.playbook mirror was stuck at v1.2.1 with curl-overwritten files; reset to origin/main (now clean 1.6.7 checkout)

### Next
- Max reverts settings.json "fable" pin manually (flag if still pinned after late June 2026)

## Session: 2026-06-11 (2) — Efficiency/efficacy audit + v1.6.6 cleanup release

### Done
- Full audit via two read-only Sonnet subagents: all 9 commands + installed-command drift; both CLAUDE.md files; settings.json/settings.local.json; ~/.claude.json MCP scoping; tech_stack.md
- **MCP scoping cleanup in ~/.claude.json** (backup at ~/.claude.json.bak-2026-06-11): removed deprecated n8n-workflows/n8n-knowledge from magnum + palm_beach; removed duplicate project-scope ClickUp from magnum/palm_beach/cockpit; moved metabase + supabase-clenta from user scope to clenta project scope. User scope now: clickup, context7, github, granola, gws, n8n-mcp, perplexity, sentry. Restart open sessions to pick up.
- **v1.6.6 shipped**: chess council moved after intake; chess/future dedup'd against /handoff steps 3–6; /future pre-flight conditional; subagent replies scoped to one screen; /quick no-secrets commit line; /start merge block trimmed + major-version check + explicit claude-haiku-4-5; Opus escalation target → 4.8 in both CLAUDE.md files; agentTeams docs corrected to CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS env var
- Global-only: stack-catalog existence guard added to ~/.claude/CLAUDE.md; Sentry + Metabase scope notes added to tech_stack.md; stale sassonlawpllc.com WebFetch permission removed from settings.local.json
- Verification subagent: 9/9 checks pass; installed ~/.claude/commands/ copies byte-identical to repo
- Decisions: repo stays PUBLIC with enforced layers (public template vs private personal layer); Metabase belongs to clenta; Opus 4.8 is the escalation target

### Deliberately skipped
- end.md WORK_LOG compression stays in /end (moving it to CLAUDE.md costs ~30 tokens every session for a 1-in-100-sessions event)
- supabase plugin (supabase@claude-plugins-official) left enabled: provides skills, not just MCP; flagged as possible future trim
- Max reverts settings.json "fable" pin manually after this session

### Next
- **Bucket 1 (next session)**: CLAUDE.md template restructure — move distributable template to templates/, thin repo-root CLAUDE.md, update install.sh/update.sh paths. Repo stays public.
- **Bucket 6**: brief.md + stack.md in ~/.claude/commands/ are still unversioned (do NOT commit to public repo — they're personal). Needs a private home (dotfiles repo or similar).
- npm publish pending for 1.6.4–1.6.6: `npm login` then `cd ~/Documents/GitHub/playbook && npm publish --access public`

### Audit findings (prioritized)
**High impact**
1. CLAUDE.md duplication: global + playbook CLAUDE.md are ~88% identical, both load in this repo, ~5.7k tokens/session. Fix: move distributable template out of repo root (e.g. templates/CLAUDE.md, update install/update.sh paths), keep a thin project CLAUDE.md
2. MCP scoping in ~/.claude.json: Metabase (~100 tools) user-scoped but single-project; deprecated n8n-workflows + n8n-knowledge still live in magnum/palm_beach; ClickUp duplicated (user scope + magnum/palm_beach/cockpit project scopes); Supabase active in 3 places (supabase-clenta user scope, supabase plugin, project scopes); superhuman-mail scoped to home dir
3. Stale model rules: CLAUDE.md says escalate to Opus 4.6 / "never 4.7" but Opus 4.8 is current; settings.json pins alias "fable" (violates own explicit-ID rule; explicit ID is claude-fable-5); CLAUDE.md says "default Sonnet 4.6" while session actually runs Fable 5. Needs Max decision on new model policy
4. agentTeams docs wrong in both CLAUDE.md files: real toggle is CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS env var, not "agentTeams": true. Misleads playbook users

**Medium**
5. chess.md/future.md duplicate ~250 words of handoff steps each + repeat model IDs in 5 places; routing checks written 3 different ways across chess/future/plan
6. brief.md + stack.md installed in ~/.claude/commands/ but untracked anywhere: silent loss on reinstall
7. start.md: CLAUDE.md merge block can shrink 15 lines to 3; version check hardcodes 2.0.0 threshold with no update path
8. future.md pre-flight does 4 silent reads, conflicts with Token Safety 5-call rule
9. chess.md council runs BEFORE intake (generic output); /plan runs it after (better)

**Low**
10. quick.md missing "never commit .env/credentials" line; end.md WORK_LOG compression only fires on /end; brief templates embed redundant "Run on Opus 4.6" lines; spawn prompts lack output-scoping for Opus subagents; consulting stack-catalog path has no existence guard; stale law-firm domain in settings.local.json; Sentry missing from tech_stack.md

### Next
- Max picks which buckets to execute; suggested order: 2 (MCP scoping, zero playbook changes) then 3+4 (model policy decision) then 1 (template restructure, touches installer) then 5-10
- npm publish still pending for 1.6.4/1.6.5

## Session: 2026-06-11 — Haiku-routed PM task pull in /start (v1.6.5)

### Done
- `/start` PM task check now routes through a Haiku subagent (`model: 'haiku'`) instead of an inline MCP call — keeps verbose PM payloads (ClickUp custom fields, descriptions) out of the main session context, and costs Haiku rates regardless of session model
- Documented in start.md why: a slash command can't change the main session's model, but it can route the heavy pull to a cheap subagent
- Audited all 9 commands: no other command had Haiku-suitable work — `/start`'s remaining steps (partial WORK_LOG read, two bash checks) are cheaper inline than via subagent
- Synced start.md to ~/.claude/commands/. Bumped VERSION, CHANGELOG, package.json, .playbook-version to 1.6.5

### Next
- npm publish: `npm login` then `cd ~/Documents/GitHub/playbook && npm publish --access public`

## Session: 2026-06-08 — Token Safety rules

### Done
- Added `## Token Safety` section to playbook CLAUDE.md and mirrored to ~/.claude/CLAUDE.md — five rules: no ambiguous path exploration, no unconstrained `find`, no build artifacts, pause after 5 tool calls with no visible output, staged multi-target implementation
- Bumped VERSION → 1.6.4, CHANGELOG updated, .playbook-version updated, package.json bumped (was missed initially, fixed before publish)
- Updated feedback memory: package.json must be bumped alongside VERSION on every release
- Drafted paste-ready Clenta session brief covering two-layer guardrail design (CLAUDE.local.md behavioral vs. iris-api programmatic)
- Committed and pushed (a154fde, 93ca39a, c3a3e89)

### Next
- npm publish: `npm login` then `cd ~/Documents/GitHub/playbook && npm publish --access public`
- NanoClaw CLAUDE.md: VPS-specific framing can stay as-is (it's a concrete restatement of the global rules) or be trimmed to a pointer
- Clenta session: paste the brief from this session to design client-facing token burn guardrails

## Session: 2026-06-07 — Screenshot research + Karpathy rules + spec gate (v1.6.3)

### What was done
1. **Processed 57 inbox screenshots** — 8 parallel Haiku subagents extracted content; synthesized into 10 topics. Extracted notes saved to `docs/2026-06-07-screenshot-research.md`. Images deleted from inbox.
2. **Evaluated screenshots for Playbook relevance** — key finding: Karpathy's four LLM failure rules (multica-ai/andrej-karpathy-skills, 132k stars) and Addy Osmani's agent-skills (27k stars). Fetched both repos to verify actual content.
3. **Spec gate added to `/plan`** — before assessing approaches, `/plan` now clarifies the task first. 1–3 questions if ambiguous; one-sentence spec anchors the rest of the plan. No new command — baked into existing flow.
4. **Clarification check added to `/quick`** — one targeted question if ambiguous, immediate proceed if clear.
5. **Two new Development Rules in CLAUDE.md** (both playbook source + installed global):
   - Ask before assuming: state assumptions explicitly, present multiple interpretations, don't pick silently
   - Surgical changes: touch only what was asked for, don't improve adjacent code/comments/formatting
6. Synced plan.md and quick.md to ~/.claude/commands/. Bumped VERSION, CHANGELOG, package.json, .playbook-version to 1.6.3.
7. **Clenta eval prompt built** — evaluates Nango, Open WebUI (Iris), Browser Use, Crawl4AI, Cal.com, Twenty, Stripe vs Polar, chrome-devtools-mcp. Copied to clipboard for Max to paste into Clenta session.
8. **Stack catalog candidates updated** — added 7 new entries to consulting inbox: Twenty, Documenso, Stirling-PDF, Coolify, andrej-karpathy-skills, agent-skills (plus Nango/Open WebUI/Browser Use/Crawl4AI/Cal.com/Polar were already added).

### Key decisions
- Spec step belongs inside `/plan`, not as a separate command — non-technical founders won't remember a two-command sequence.
- Karpathy rules added globally (CLAUDE.md) so they apply everywhere, not just inside `/plan`.
- Full Addy Osmani agent-skills suite not installed — the developer-specific commands (/test, /build, /ship) are wrong fit for Playbook's non-technical audience.
- Nango re-evaluated as relevant to Clenta: different job than Composio (Nango = your users connecting their accounts TO Clenta; Composio = your agents connecting to external services).

### Not yet published to npm — Max runs manually.

## Session: 2026-06-07 — /future agency filter + worktree rule (v1.6.1 → v1.6.2)

### v1.6.2 addition
- **Worktree isolation rule** added to Agent Team rules in both `CLAUDE.md` (Playbook source) and `~/.claude/CLAUDE.md` (installed global): when teammates write to different files in parallel, use `isolation: "worktree"` on each agent call. Covers all projects including Clenta — no project-specific addition needed since the global rule applies. Clenta's CLAUDE.md already has "create branch before spawning subagents"; worktrees handle that automatically.

## Session: 2026-06-07 — /future agency filter (v1.6.1)

### What was done
1. **Modified `/future` constraints intake** — the constraints beat now explicitly asks two additional things: what's actively underway and critical (must not slip), and what's blocked waiting on a third party. Both extracted from WORK_LOG + intake answers.
2. **Added `## What's already in motion` to brief template** — two tagged buckets: `[critical, active]` and `[waiting: third party]`. Omitted entirely if both are empty.
3. **Added agency filter instruction to synthesis** — Opus cross-references every candidate output item against the motion list before writing the primary output. Third-party waits become "Watching:" notes; critical in-progress work gets a "Keep going on:" acknowledgment; "Your move this week" is reserved for things not yet started and actionable now.
4. **Updated `Your move this week` output instructions** — explicit two-tier format: "Keep going" acknowledgment first (if applicable), then new actions only.
5. **Synced to `~/.claude/commands/future.md`**.
6. **Bumped to v1.6.1** — VERSION, CHANGELOG, package.json, .playbook-version all updated.

### Key design decision
Critical in-progress items are NOT filtered out — they get a one-line acknowledgment so they don't get forgotten. Only third-party waits and non-critical in-progress items are excluded from "Your move this week." The filter door stays open for course-correction recommendations on in-progress items.

### Not yet published to npm — Max runs manually.

## Last updated: 2026-06-01

## Session: 2026-06-01 — Batch processing evaluation (discussion only)

### What was done
1. **Researched Anthropic Batch Processing API** — fetched and reviewed full docs. Key facts: 50% cost reduction, async up to 1 hour (usually), no streaming, up to 100k requests or 256MB per batch, supports tool use/vision/extended thinking. Extended output beta (300k tokens) available batch-only.
2. **Evaluated batch for Playbook commands** — conclusion: structurally incompatible. Claude Code is synchronous/streaming by design; batch is fire-and-forget async. Commands like `/future` are multi-step orchestrated workflows with file writes, subagents, and memory updates — not single API calls. Batch has no scaffolding for any of that.
3. **Evaluated "run /future while I sleep" via batch** — correct answer is `/schedule`, not batch. `/schedule` runs the full command with all scaffolding; batch would return raw JSON with none of it.
4. **Evaluated batch for Clenta** — mapped against Clenta's architecture:
   - Iris conversations: can't batch (real-time required)
   - Briefings: if on-demand, latency kills UX; if pre-scheduled overnight, works but users never see the wait anyway — minimal net benefit vs. engineering cost
   - Cron reports (daily/weekly/monthly): technically fits, but volume is too low to matter financially
   - Conclusion: not worth building now. Revisit when non-real-time API spend hits ~$300-500/month.

### No code changes
Discussion-only session. No files edited, no commits, no npm publish.

### Key decision captured
Batch processing is a cost lever for products running high-volume, non-real-time workloads. It is not a "deferred mode" for Claude Code sessions and is not meaningfully relevant to Clenta at current beta scale.

## Last updated: 2026-05-31

## Session: 2026-05-31 — v1.6.0 council integration + routing + todo list

### What was done
1. **Council integration** — added contextual council (4 real-world advisors, chosen per topic) to all three strategic commands:
   - `/chess` Human Mode: council pre-flight runs before intake, frames strategic posture going into the move tree (inline Sonnet)
   - `/plan` Phase 1: council runs when there are meaningful tradeoffs between approaches, before recommending a direction (inline Sonnet)
   - `/future`: council reaction runs after Opus subagent returns, each advisor reacts to the 3 load-bearing decisions (inline Sonnet)
2. **Routing checks** — added routing pre-flight to `/plan` and `/future`; added Route 4 (/future) to `/chess`. All three commands now cross-reference each other with a simple decision tree.
3. **Todo list checkpoint** — complex `/plan` runs (subagent path) now write implementation steps as markdown checkboxes to WORK_LOG.md when execution begins; steps tick off as they complete.
4. **README** — added `/chess` and `/future` to What's Included table and Commands section; added "primary enemy" framing (plan=bad execution, chess=opponent, future=uncertainty).
5. **Synced to `~/.claude/commands/`** (plan.md, chess.md, future.md).
6. **Bumped to v1.6.0** — VERSION, CHANGELOG, package.json, .playbook-version all updated.

### Key design decisions
- Council members are contextually chosen per topic — not a fixed panel. Claude picks whoever's thinking is most relevant to the specific situation.
- Council runs inline on Sonnet in all three commands — no subagent overhead needed for the advisory layer.
- Routing checks are self-contained (no external docs required) — each command names its primary enemy and points to the others.
- Todo list only on complex plans (subagent path) — simple inline plans don't need it; the steps are visible in the same response.

## Last updated: 2026-05-29

## Overall State: v1.5.3 published to npm. All commands now have explicit model routing documentation. Subagent model live across /chess, /future, /plan, /handoff. PreCompact hook live. Sentry MCP wired at user scope (pending first-session OAuth).

## Session: 2026-05-29 — v1.5.3 model routing documentation

### What was done
1. **Model routing audit** — reviewed all 9 commands for Haiku/Sonnet/Opus routing opportunities. Finding: every existing subagent call does genuine reasoning work (architecture planning, adversarial modeling, comparison analysis) — no Haiku candidates in current subagent calls. Haiku wins are already captured by CLAUDE.md guidance on Explore subagents.
2. **Added model routing to 4 undocumented commands** — `/debug`, `/end`, `/quick`, `/new-project` now all say "Runs inline on Sonnet. No subagents." at the top. Matches the style /future and /chess already used. Prevents future drift when commands are extended.
3. **Synced to `~/.claude/commands/`** immediately after edits.
4. **Bumped to v1.5.3** — VERSION, CHANGELOG, package.json, .playbook-version all updated.
5. **Published to npm** (playbook-ai@1.5.3) — Max ran manually.

### Key decisions
- No Haiku routing added to existing subagent calls: all do reasoning work where Sonnet quality matters. The `/future` retrospective subagent (read prior file + write 200-word comparison) was the closest candidate but feeds the Opus run directly, so Sonnet is the right call.
- `/start` pre-flight not restructured for Haiku: saves ~$0.03/session, adds subagent overhead and complexity. Not worth it.

## Session: 2026-05-28 — v1.5.2 subagent architecture

### What was done
1. **Rewrote `commands/handoff.md`** — defines the canonical subagent pattern: write brief to .md file → show intake summary in chat (150-250 words, not full brief) → cost warning for Opus → spawn Agent subagent → output appended to same file → results in main session. Replaces the old copy-paste terminal approach entirely.
2. **Rewrote `commands/chess.md`** — self-contained. Intake stays in main session (Sonnet). Chess brief written to `docs/chess/YYYY-MM-DD-[slug].md` (intake data + full chess framework). Short summary shown in chat for approval. Cost warning before spawning Opus 4.6 subagent. Full debrief appended to brief file. System Mode: inline Sonnet for simple, Sonnet subagent for complex, Opus subagent only when warranted.
3. **Rewrote `commands/future.md`** — subagent model replaces handoff. Added model routing (Haiku/Sonnet for pre-flight + intake + brief; Sonnet subagent for retrospective comparison; Opus 4.6 subagent for narratives + synthesis). /chess bridge upgraded: 3-sentence context block + recommendation (run/skip) + "Run /chess on this?" confirmation. High threshold: both material AND genuinely adversarial before /chess is even mentioned.
4. **Updated `commands/plan.md`** — self-contained. Phase 1 stays inline. Phases 2+3 spawn Sonnet subagent for complex plans; simple plans stay inline.
5. **Synced all four to `~/.claude/commands/`** immediately.
6. **Bumped to v1.5.2** — VERSION, CHANGELOG, package.json, .playbook-version all updated.
7. **Published to npm** (playbook-ai@1.5.2).

### Key design decisions
- Brief file = intake data + execution framework. Subagent reads file, not inline context — keeps main session lean.
- User reviews intake summary (their words reflected back, ~200 words), not the full framework. The framework is fixed; their inputs are what need approval.
- /chess bridge: zero candidates is normal. One is meaningful. Recommendation is explicit, not hedged. Filter: BOTH material AND adversarial required.
- Haiku for pre-flight file reads; Sonnet for retrospective comparison; Opus only for narrative generation + chess analysis where quality is non-negotiable.

## Session: 2026-05-28 — /future v1.5.1 upgrade

### What was done
1. **Rewrote `commands/future.md`** — full redesign based on design review:
   - Self-contained: reads its own context, no /start dependency (same as /chess)
   - Model routing: Sonnet for intake + assumption check, Opus 4.6 for narratives + synthesis via handoff
   - Handoff pattern: intake in main session, parallel Opus session does the heavy lifting, return prompt pastes one-screen output back to main session for discussion
   - Assumption check phase: brief pre-scenario check surfaces shaky assumptions (borrowed from /plan); they seed The Unraveling
   - Synthesis verdicts: ✅ / ⚠️ / ❌ format (borrowed from /chess System Mode)
   - /chess bridge: swing-state decisions with counterparties flagged as [/chess candidate]
   - Retrospective mode: checks docs/futures/ for prior runs; offers update that reads what's changed
   - Saves full output to docs/futures/YYYY-MM-DD-[project-slug].md
2. **Synced to `~/.claude/commands/future.md`** immediately.
3. **Bumped to v1.5.1** — VERSION, CHANGELOG, package.json, .playbook-version all updated.
4. **Published to npm** (playbook-ai@1.5.1).

### Key design decisions
- Handoff pattern chosen over inline because: narratives + synthesis produce 3000-5000 tokens of context; fresh Opus context produces better scenarios; keeps main session clean for discussion after return
- Unlike /chess, /future's parallel session does NOT close — the return prompt brings one-screen output verbatim to main session so discussion continues there
- Retrospective mode is the highest-value unlock: running /future every 3 months and comparing projections to reality turns it from a planning tool into a navigation system

## Session: 2026-05-27 — /future command

### What was done
1. **Designed `/future` command** — extended conversation to flesh out the concept before building: three-scenario structure (The Win, The Unraveling, The Headwind), quadrant synthesis approach, leading indicators extracted from narratives (not asked of user), one-screen output constraint, tiered decision taxonomy.
2. **Built `commands/future.md`** — full command: silent pre-read, conversational intake (north star, fear, constraints, timeframe), three narratives in past tense, internal synthesis (quadrant analysis + leading indicators + irreversibility tagging), one-screen primary output (thesis + 3 load-bearing decisions + 3 anti-patterns + move this week), appendix on request, 30-day follow-up hook.
3. **Synced to `~/.claude/commands/future.md`** immediately.
4. **Bumped to v1.5.0** — VERSION, CHANGELOG, package.json, .playbook-version all updated.

### Key design decisions
- Three scenarios, not two: The Headwind (did everything right, world didn't cooperate) surfaces resilience gaps that success/failure scenarios miss
- Leading indicators derived FROM narratives by Claude, not asked of user — bypasses confirmation bias
- Output ordered by *when* decisions need to be made, not importance — timing drives action
- One-screen primary output; full narratives in appendix — avoids the "so thorough you do nothing" failure mode
- Narrator voice: "telling someone who loves you and won't let you bullshit them" — honest + specific, no case-study spin
- Decision saved to `docs/decisions/` not warranted here — design rationale lives in WORK_LOG

### Next
- Publish to npm when ready (npm login && cd ~/Documents/GitHub/playbook && npm publish --access public)
- Consider a `/future` reference doc in `docs/` similar to chess-command-reference.md if the command proves complex in practice

## Session: 2026-05-26 — Sentry MCP wired into Claude Code

### What was done
1. **Researched Sentry MCP setup** — official server is `@sentry/mcp-server` at `https://mcp.sentry.dev/mcp`, uses HTTP transport with browser-based OAuth (no static API token needed in config).
2. **Added to `~/.claude.json` at user scope** via: `claude mcp add --transport http --scope user sentry https://mcp.sentry.dev/mcp`. Available across all Claude Code projects on this machine.
3. **Auth pending**: server shows "Needs authentication" — one-time browser OAuth completes on first `/mcp` invocation in any Claude Code session.
4. **Saved memory** to `projects/-Users-maxassoulin-Documents-GitHub-playbook/memory/sentry-mcp.md` — setup command, auth flow, capabilities, Clenta usage notes.
5. **Updated `MEMORY.md`** — added "MCP Servers (User Scope)" section with Sentry entry.

### No Playbook repo changes
This session was pure machine config — no commands, scripts, or versioned files changed. No commit needed.

### Next
- Complete Sentry OAuth: open any Claude Code session, type `/mcp`, authenticate in browser
- Option 3 (Stop hook + statusline monitoring for proactive context warnings) remains deferred

## Session: 2026-05-25 — /start context reduction + npm publish

### What was done
1. **`commands/start.md`**: removed redundant CLAUDE.md read (already in system context automatically). Added daily throttle on update check — timestamp written to `~/.claude/.playbook-last-update-check`, skips git fetch + curl on subsequent /start calls same day.
2. **Synced to `~/.claude/commands/start.md`** immediately.
3. **Bumped to v1.4.3** — VERSION, CHANGELOG, `.playbook-version` all updated.
4. **Published to npm** (`playbook-ai@1.4.3`) — ships both v1.4.2 (PreCompact hook) and v1.4.3 (/start optimization).

### Next
- Option 3 (Stop hook + statusline monitoring for proactive context warnings) remains deferred

## Session: 2026-05-24 — WORK_LOG compression logic

### What was done
1. **`commands/end.md` — step 3 rewritten**: replaced delete-oldest logic with compress-oldest-10 logic. When session count exceeds 100, the 10 oldest entries (raw sessions or prior compressed blocks) are summarized to 2-3 bullets each and folded into a single `## Compressed: [date range]` block. History is preserved, nothing is deleted. Fires ~once every 9-10 sessions after the threshold.
2. **Synced to `~/.claude/commands/end.md`** in the same pass.
3. **npm publish and version bump deferred** — batching with next meaningful feature.

### Next
- npm publish when next meaningful Playbook change ships alongside v1.4.2
- Option 3 (Stop hook + statusline monitoring for proactive context warnings) remains deferred

## Session: 2026-05-23 — Security advisory (TeamPCP supply chain attack)

### What was done
1. **Researched TeamPCP attack via Perplexity** — confirmed: LiteLLM `1.82.7`/`1.82.8`, 42 `@tanstack/*` packages (May 11 UTC), 323 `@antv/*` packages, and Nx Console (`nrwl.angular-console`) v18.95.0 were the primary compromised artifacts.
2. **Scanned all local repos** (playbook, cockpit, clenta, shopify-analytics-mcp, rosie-import, wildflower, magnum) — zero flagged packages in any dependency file or lockfile.
3. **Confirmed litellm not installed** in default Python environment; no `litellm_init.pth` backdoor file found.
4. **Checked magnum GitHub Actions** — no OIDC trusted publisher usage, not exposed to that CI vector.
5. **Max confirmed VS Code extensions** — only Pylance, Python, Python Debugger, Python Environments. No Nx Console. All vectors closed.
6. **PAT rotation clarified** — advisor-max-agent token is in Joseph's GitHub, not Max's. Max asked Joseph to rotate it.
7. **Wrote sibling warning message** and copied to clipboard.

### Result
Max's code, repos, and local environment are clean. No remediation required beyond PAT rotation (delegated to Joseph).

### Next
- npm publish when next meaningful Playbook change ships alongside v1.4.2
- Option 3 (Stop hook + statusline monitoring for proactive context warnings) remains deferred

## Session: 2026-05-17 — PreCompact hook (v1.4.1 → v1.4.2)

### What was done
1. **Diagnosed context health gap** — Playbook CLAUDE.md promised Claude would warn before context fills, but Claude has no signal to read its own context meter. Behavior was aspirational, not enforceable.
2. **Researched Claude Code hooks via Perplexity** — confirmed `PreCompact` and `PostCompact` hooks exist (as of May 2026 docs). PreCompact fires at ~78% context used but cannot block compaction. No native "warn at X%" hook exists.
3. **Built `hooks/precompact-save.sh`** — shell script that reads `cwd` from the JSON Claude Code passes on stdin, checks if `WORK_LOG.md` exists there, and appends a timestamped AUTO-COMPACT marker if so. Silent on non-Playbook projects.
4. **Wired hook into `~/.claude/settings.json`** (Max's personal config, active immediately) — `PreCompact` event, command type, calls `bash ~/.claude/hooks/precompact-save.sh`.
5. **Updated Playbook repo** — `hooks/precompact-save.sh` added, `hooks/hooks.json` updated, `settings.json` template updated with hooks block, `install.sh` updated to create `~/.claude/hooks/`, copy the script, and do an additive Python-based merge of the hooks block for users who already have a settings.json.
6. **Version bumped to v1.4.2** — VERSION, CHANGELOG.md, package.json, `~/.claude/.playbook-version` all updated in same pass.
7. **Committed and pushed** — `4d93e12` to origin/main.

### Known limitation
PreCompact saves state but cannot trigger a graceful `/end`. By the time it fires, Claude has no response window. The full fix (Stop hook + statusline context % monitoring) would give proactive warnings before the compaction threshold — deferred to a future session.

### Next
- npm publish when next meaningful change ships alongside this one
- Option 3 (Stop hook + statusline monitoring for proactive context warnings) is the real long-term fix if Max wants it

### Closeout
- 1 commit pushed to origin (`4d93e12`)
- npm publish skipped — behavior change, but deferred intentionally

## Session: 2026-05-04 — Writing style standards

### What was done
1. **`CLAUDE.md` (playbook) — Writing Style section added**
   - No em dashes; no AI tells (delve, leverage, utilize, comprehensive, etc.); no filler openers
   - Committed `fd46518`
2. **`~/.claude/CLAUDE.md` — same Writing Style section added** (not in git, personal config)
3. **Memory saved** — `feedback-writing-style.md` + MEMORY.md pointer added

### Next
- No pending Playbook code work.
- First real System Mode /chess run will validate the framework in practice.

### Closeout
- 1 commit pushed to origin
- No npm publish needed (no behavior change, version unchanged)

## Session: 2026-05-03 — /chess System Mode (v1.4.0 → v1.4.1)

### What was done
1. **`commands/chess.md` — System Mode added**
   - Pre-flight updated to 3-way router: Human Mode / System Mode / /plan
   - System Mode section: intake skips if context already established in conversation; stress-test framework runs inline Sonnet by default, escalates to Opus 4.6 inline (no parallel session) for complex systems; Step 1–4 (map assumptions → attack vectors with ✅/⚠️/❌ verdicts → surface changes → ready to build?)
   - Human Mode section renamed but otherwise identical — zero behavior change
2. **Synced to `~/.claude/commands/chess.md`** in same pass
3. **`docs/chess-command-reference.md` updated** — dual-mode description, updated "What /chess Is", routing table, new System Mode section with session/logging rules, updated failure modes table and summary line
4. **Version bumped to v1.4.1** — VERSION, CHANGELOG, package.json, `~/.claude/.playbook-version` all updated

### Design decisions
- System Mode runs inline (no parallel session) — the parallel session pattern is the Human Mode signature; system stress-testing is sequential, not adversarial modeling of intent
- Opus escalation available inline for complex systems, not via parallel session
- Intake skips if context already in conversation — avoids re-interviewing mid-conversation

### Next
- First real System Mode run will validate the new framework in practice

### Closeout
- v1.4.1 published to npm ✅ (verified `npm view playbook-ai version` → 1.4.1)
- Committed `3236741`, pushed to origin
- `~/.claude/CLAUDE.md` updated — Inbox section added (was missing from personal config)
- Memory updated: npm publish sequence saved, current state updated to v1.4.1

## Session: 2026-05-01 — /chess command + /plan lightening (v1.3.5 → v1.4.0)

### What was done
1. **New `commands/chess.md`** — full adversarial strategy command:
   - Pre-flight check: routes /plan vs /chess before intake begins ("is there a real adversary?")
   - Structured intake in primary session (Sonnet) — adversaries, motivations, BATNAs, information asymmetry, your position
   - Generates self-contained Opus 4.6 handoff prompt with chess reasoning framework embedded verbatim (no circular command invocation)
   - Parallel session runs autonomously: inhabit adversaries → branch trace 3-4 moves deep → stress assumptions → identify leverage → recommended line + contingencies
   - Debrief written to `docs/chess/YYYY-MM-DD-[topic].md`; return prompt lets Max bring it back to the primary session
   - Closes with `Chess session complete. You can close this window.` — no /end in parallel session
2. **`commands/plan.md` lightened** — branch trace removed. /plan is now assess → harden → steps.
3. **Both synced** to `~/.claude/commands/` in same pass. `/chess` is live and available.
4. **Version bumped to v1.4.0** — VERSION, CHANGELOG, package.json, `~/.claude/.playbook-version` all updated.
5. **`docs/plan-command-reference.md`** — moved from inbox, updated: 3-phase structure, no branch trace, routing table between /plan and /chess, /chess section added.
6. **`docs/chess-command-reference.md`** — new standalone agent reference: pre-flight, intake, embedded reasoning framework step-by-step, handoff pattern, output format, session/logging rules, failure modes.
7. **Published `playbook-ai@1.4.0` to npm** — verified live (`npm view playbook-ai version` → 1.4.0).
8. **Committed and pushed** — `cb8ed07` (feat), `ae28d24` (docs). GitHub and npm in sync.

### Next
- No pending Playbook code work.
- First real /chess run will validate the command in practice — worth noting any gaps after use.

## Session: 2026-04-28 — /plan structural overhaul (v1.3.4 → v1.3.5)

### What was done
1. **`commands/plan.md` rewritten** — three structural changes:
   - **Branch trace (Phase 1)** — for high-stakes decisions, traces each option 2-3 moves forward to a labeled terminal state (`favorable / acceptable / problematic`). Gated: only fires when cost-of-being-wrong is high. Max 3 branches, 3 moves deep. Compares endpoints, not opening positions.
   - **Phase 2/3 swapped** — assumption audit + risk war-game now run *before* writing implementation steps. Eliminates the rework loop of writing steps that turn out to be wrong.
   - **Build blockers folded into Phase 3 per-step notation** — removed as a separate section, now embedded next to each implementation step.
2. **Synced to `~/.claude/commands/plan.md`** — global installed copy updated in same pass.
3. **`package.json` version corrected** — was stuck at 1.2.1 (missed in prior bumps); updated to 1.3.5.
4. **Version bump to v1.3.5** — VERSION, CHANGELOG, `~/.claude/.playbook-version` all updated.
5. **`playbook-ai@1.3.5` published to npm** — verified live (`npm view playbook-ai version` → 1.3.5).
6. **Committed and pushed** — commits `9f2f1ac` (plan + version) and `a0d9c50` (package.json sync).

### Next
- No pending Playbook code work.

## Session: 2026-04-23 — Model cost audit + policy overhaul (v1.3.3 → v1.3.4)

### Problem
Max's Claude Code sessions were defaulting to Opus 4.7 1M context, costing $40-60/day. Root cause: CLAUDE.md Model Selection section said "default to the stronger model, err on the side of more capability, not cost savings."

### What was done
1. **Rewrote Model Selection in `CLAUDE.md`** — flipped polarity: Sonnet 4.6 is now the default, Opus 4.6 is explicit escalation only (with required one-line heads-up to Max), Haiku 4.5 for mechanical subagent work.
2. **Added concrete Haiku routing table** (v1.3.4) — Haiku for Explore subagents and simple Perplexity lookups; Sonnet for Agent team members, research synthesis, and all implementation work. Prevents "parallel = Haiku" misassumption.
3. **Bumped version to v1.3.4**, updated CHANGELOG, pushed to `bluemax713/playbook` main.
4. **Pinned `claude-sonnet-4-6` in `~/.claude/settings.json`** (Max's personal config — not part of the playbook repo).
5. **Updated personal `~/.claude/CLAUDE.md`** with matching policy (same text as playbook, Max-specific pronouns).

### Key decisions
- Opus 4.6 is the escalation target, never 4.7 — no 1M context premium, same capability class.
- Haiku is "transport layer only" — when Claude relays results, not when it reasons.
- Agent team members always use Sonnet minimum — they do real implementation work.
- settings.json update is manual for playbook users (CHANGELOG explains how); update script doesn't touch personal config.

### Next
- No pending Playbook code work. Haiku-for-agents work is in the openclaw session.

---

## Last updated: 2026-04-22

## Overall State: v1.3.2 live on npm + GitHub, plugin marketplace submitted, demo project live. No Playbook code changes this session — work was a GWS daily-digest skills evaluation that pivoted into building a custom `/brief` command in Max's global config + cross-session plumbing with the consulting catalog.

## Recent Changes (2026-04-22, session 14 — GWS digest evaluation)

Session goal: install and test three mcpmarket "daily brief" Google Workspace skills (Daily Briefing, Weekly Digest, The Day AI Daily Planner); pick one, seed its style profile, document for personal stack + consulting. Zero changes to tracked Playbook files (no version bump). All writes landed in `~/.claude/`, the consulting repo `inbox/`, and a scratch dir for test artifacts.

1. **Investigated all three skills before installing** (hard rule: don't install blind):
   - "The Day AI Daily Planner" (durandom/skills) — ARCHIVED upstream on 2026-02-18 (`BREAKING: Remove the-day skill from active set`). Skipped per hard rules.
   - "Google Workspace Weekly Digest" (pleaseai/claude-code-plugins) — 6-line SKILL.md wrapper that calls `gws workflow +weekly-digest`. The helper ships natively in the gws CLI Max already has.
   - "Daily Briefing for Google Workspace" (mcpmarket listing) — `gws-workflow-daily-briefing` identifier does not exist in any source repo or registry. Closest match is `persona-exec-assistant` (~10-line SKILL.md orchestrating native gws helpers). Advertised "style profile" and "stakeholder weighting" are marketing copy, absent from code.

2. **Audible to Max** — scope as written produced a predetermined outcome (hollow wrappers vs. a CLI Max already has). Max approved Path C: honestly document the three for consulting catalog AND build the real thing (custom `/brief` command) for personal use.

3. **Consulting deliverables** (to `~/Documents/GitHub/consulting/inbox/`):
   - `stack-catalog-candidates.md` — appended new "Daily-digest / morning-brief evaluations (Playbook session, 2026-04-22)" block with 4 one-liners: gws CLI workflow helpers (ADOPTED as real engine), Daily Briefing (NOT ADOPTED, marketing claims don't exist in code), Weekly Digest (NOT ADOPTED, trivial wrapper), The Day (NOT ADOPTED, archived).
   - `aggregator-verification-rule.md` — NEW file, 3-line summary of the mcpmarket.com finding for folding into `stack-catalog/cross-cutting/research-rules.md`. Rule: before recommending any aggregator-listed skill/tool, resolve to upstream source, confirm the identifier exists, read SKILL.md to verify advertised features, check for archival.

4. **Personal config — `/brief` command built end-to-end:**
   - `~/.claude/commands/brief.md` — new slash command. Pulls calendar + unread email + chat + tasks via gws in parallel, ranks with P0/P1/P2/Noise tiers using `~/.claude/stakeholders.md`, extracts literal actions (not fuzzy "think about it" ones), drafts replies in Max's voice using `~/.claude/style-profile.md`. Pure markdown output to `~/.claude/briefs/YYYY-MM-DD-brief.md`. The feature set mcpmarket listings advertised but didn't implement.
   - `~/.claude/style-profile.md` — populated from 6 real sent emails via gws. Captured cues: short replies (1–3 sentences), no pleasantries on internal threads, em-dashes for asides, `Thanks,\nMax` close, single-ask discipline, Superhuman auto-signature.
   - `~/.claude/stakeholders.md` — T1 (advisor@assoulin.com, Eric, Joseph, Gusto, JPMorgan, Hilldun), T2 (@rosieassoulin.com catch-all, Stripe, Shopify, ApparelMagic), T3 (industry newsletters), Noise (no-reply, notifications, Google Groups digests, BoF marketing).
   - `~/.claude/briefs/` — output dir, gitignored.
   - `~/.claude/.gitignore` — protects briefs/, style-profile.md, stakeholders.md, .playbook/tmp/.

5. **Live test run (today, 2026-04-22)** — blocked initially on gws OAuth (`invalid_rapt`), unblocked after Max ran `gws auth login`. Then:
   - Native `gws workflow +standup-report` (JSON + table) saved to scratch.
   - Native `gws workflow +weekly-digest` (JSON + table) saved — 12 meetings this week, 201 unread.
   - Pulled 15 unread emails via `mcp__gws__gmail` + 6 sent for style extraction.
   - `/brief` produced real 2026-04-22 output: 4 P0s surfaced (Gusto wire due 11am PDT, Gusto contractor payments blocked, JPMorgan secure message, Tania LA buyer lookbook request). Native helpers surfaced 0 of these by name — they returned counts.
   - All artifacts in `~/.claude/.playbook/tmp/gws-skill-test/2026-04-22/`.

6. **Deployment recommendation** — two-phase rollout documented at `~/.claude/briefs/deployment-plan.md`:
   - **Week 1 (now → 2026-04-29):** manual `/brief` in Claude Code each morning. Tunes stakeholders + style profile against real drafts.
   - **Week 2+ (2026-04-29):** port logic to Joseph/openclaw. openclaw already runs 24/7 with GWS OAuth via Composio; push brief to Max's phone before he opens the laptop. Claude Code `/brief` stays available for afternoon reruns.
   - Kill criteria: drafts consistently wrong voice → keep /brief, disable drafts; ranking buries P0s → rewrite heuristics, don't migrate; Max ignores by day 5 → format is wrong, redesign.

7. **tech_stack.md updates:**
   - New "Daily Operations" section: gws CLI (googleworkspace/cli) + /brief command (with build context noted: "built 2026-04-22 after evaluating three mcpmarket listings").
   - Deprecated section: three mcpmarket listings added with one-line reasons + dates.

8. **Memory updates:** None this session — findings are either codified in tech_stack.md (durable facts) or in the consulting inbox (to be folded into stack-catalog cross-cutting rules). No new auto-memory entries needed.

## Previous Session: 2026-04-21, session 13 (tech-stack hygiene + cross-project plumbing)

This session was a tech-stack audit/cleanup + cross-project plumbing. Zero changes to tracked Playbook files (no version bump). All writes landed in Max's personal config (`~/.claude/`), the consulting repo (parallel session active), and a new personal reference library (`~/Documents/Reference/`).

1. **Tech stack audit/cleanup** (`~/.claude/tech_stack.md`):
   - Added missing entries: `frontend-design` plugin, `code-review` plugin, `Context7` MCP, `feature-dev` plugin (newly installed), `agent-sdk-dev` plugin (newly installed), GitHub MCP, ClickUp MCP (official, OAuth — already installed in a prior session)
   - Moved cockpit-only entries to Deprecated (dated 2026-04-21): React 19 + Vite, Hono, Tailwind v4, shadcn/ui patterns, Bun. Cockpit is in its own repo and tracks them there.

2. **Cockpit paid-services audit** — ran in parallel session via Max. Verdict: zero cockpit-exclusive paid subscriptions, nothing to cancel. Stored API tokens (ClickUp `pk_150234564_...`, n8n JWT) in `~/.cockpit/config.json` flagged as rotation candidates since the project is mothballed — separate hygiene item, not done this session.

3. **Plugin installs** — `feature-dev` and `agent-sdk-dev` (both official Anthropic), no setup required. Researched and ranked 13 marketplace plugins; rejected the rest as off-fit for non-technical-founder audience.

4. **MCP installs / verification**:
   - **GitHub MCP** installed (`@modelcontextprotocol/server-github`). Connected.
   - **ClickUp MCP** discovered as already installed via official HTTP+OAuth endpoint (`mcp.clickup.com/mcp`) — better than the third-party `@chykalophia` package originally researched.
   - Both tools become callable next session (Claude Code only registers MCP tools at session start).

5. **GitHub PAT rotation**:
   - First token leaked into chat transcript (Max pasted it; my prompt invited it). Old token revoked in GitHub settings.
   - New token installed via file-based pattern: `read -s` to prompt + write to `~/.gh-pat-tmp` (chmod 600), then `claude mcp add ... -e "GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ~/.gh-pat-tmp)" ...`, then `rm ~/.gh-pat-tmp`. Token never appeared in transcript.
   - **Lesson learned (saved to feedback memory):** for credential installs, default to file-based passing; don't ask Max to paste tokens directly into chat.

6. **Inbox review + research** (18 files dropped this session):
   - 9 Wize AI Instagram screenshots = a structured 7-subagent codebase cleanup prompt with explicit "what NOT to do" guardrails. Developer-targeted, NOT a fit for Playbook (audience is non-technical founders). Saved as a reusable prompt asset to `~/Documents/Reference/prompt-library/cleanup-7-subagent-pattern.md` for Max's personal use on cockpit/magnum/palm_beach/rosie-import.
   - 8 educational explainer images (Chat-vs-Agent, OBSERVE/THINK/ACT loop, AGENTS.md before/after, MCPs-as-translator before/after, Skills before/after) saved to `~/Documents/Reference/agentic-explainers/` with a README explaining each + IP discipline (don't redistribute, recreate before publishing).
   - 1 RetentionX ad documented in consulting candidates file.

7. **Stack-catalog tee-up workflow** — answered Max's "how do we tee up evaluations for the consulting catalog" question:
   - Created `~/Documents/GitHub/consulting/inbox/stack-catalog-candidates.md` (NOT in `stack-catalog/` — parallel session is writing there). Seeded with 5 candidates: Claude Cowork, MiroFish AI, LangChain/LangSmith, RetentionX, Wize AI 7-subagent prompt pattern. Suggested 3 new categories: Decision-rehearsal/market simulation, Agent observability/eval (enterprise), Process/prompt patterns.
   - Added global rule to `~/.claude/CLAUDE.md` under "Tech Stack Awareness": every future session in any project automatically appends evaluations to the consulting candidates file.
   - Personal config rule, not a Playbook public rule (references Max's specific path).

8. **Auto-memory** — added `reference-personal-library.md` pointer in `MEMORY.md` so future sessions surface `~/Documents/Reference/` when relevant (concept explainers, prompt patterns).

9. **Inbox cleaned** — 18 files deleted at end. All useful information extracted to consulting candidates file, personal reference library, and tech_stack updates.

1. **Inbox folder added** — created `inbox/` directory with `.gitkeep`, added `inbox/` to `.gitignore`. Aligns with all other repos.
2. **Reviewed 19 inbox screenshots** — three sources: Awesome Design MD (@forgoodcode), Second Brain / Karpathy wiki pattern (@thevibefounder), community Claude Code skills (@okaashish). Evaluated each for Playbook fit.
3. **Awesome Design MD — added to README + GUIDE** — new "Design References" subsection under Plugins in README.md. New "Match your UI to a brand you admire" tip in GUIDE.md. 60+ brand design systems (Apple, Stripe, Linear, etc.) via `npx getdesign@latest add <brand>`. Pairs with Frontend Design plugin.
4. **Ops research tip — added to GUIDE** — "Let Claude organize your research" tip under Tips for Ops People. Frames the dump-and-synthesize pattern using inbox/.
5. **Second Brain pattern — evaluated, skipped as feature** — doesn't need a command or folder structure. The pattern (dump raw material, let AI organize) is already embodied by inbox/ + auto-memory. Max confirmed: no wiki command, but the principle is part of the operating philosophy and is now reflected in the guide tips.
6. **Community skills — skipped** — Refactoring UI, UX Heuristics, Hooked UX, iOS HIG Design from @okaashish. Unvetted third-party skills; will revisit when Anthropic marketplace launches.
7. **Auto-memory saved** — reference for Awesome Design MD, surfaces when Max does UI/UX work in any project.
8. **Version bump to v1.3.2** — VERSION, CHANGELOG, ~/.claude/.playbook-version updated. Committed and pushed.
9. **Inbox cleaned** — 19 screenshots deleted after extracting all useful info into README, GUIDE, and auto-memory.

## Previous Session: 2026-04-15, session 11

1. **`/plan` stress test phase** — added Phase 3 to `commands/plan.md`. Automatically pressure-tests plans before presenting for approval: assumption audit, risk war-game, build roadblock scan. Scales depth to plan complexity. Replaces Max's manual "validate your assumptions" prompts.
2. **Version bump to v1.3.1** — VERSION, CHANGELOG updated. Committed and pushed to main.
3. **Synced to personal config** — `~/.claude/commands/plan.md` updated, `~/.claude/.playbook-version` set to 1.3.1.
4. **Feedback memory saved** — always bump VERSION + CHANGELOG + .playbook-version in the same pass as any Playbook change (not as a follow-up).

## Previous Session: 2026-03-30, session 10

1. **Frontend Design plugin — default** — added as default plugin for all Playbook users. `settings.json` has `enabledPlugins` entry, `install.sh` runs `claude plugin install` automatically, documented in CLAUDE.md, README.md, GUIDE.md.
2. **Code Review Agents plugin — recommended** — added to README.md Plugins section as opt-in. Documented install command.
3. **Context7 MCP server — recommended** — added to README.md MCP servers table. Pulls version-specific library docs into Claude's context.
4. **Model routing guidance** — new "Model Selection" subsection in CLAUDE.md under Parallel Work. Replaced rigid "Opus for lead, Sonnet for teammates" with task-complexity principle. Claude picks the model, defaults to stronger, never prompts user.
5. **Max's personal config updated** — `~/.claude/CLAUDE.md` (model routing + plugins), `~/.claude/settings.json` (enabledPlugins), `~/.claude.json` (Context7 MCP added).
6. **Version bump to v1.3.0** — VERSION, CHANGELOG updated. Committed and pushed to main.

## Previous Session: 2026-03-28, session 9

1. **WORK_LOG trim cap raised from 25 to 100** — `commands/end.md` updated + synced to `~/.claude/commands/end.md`. At ~12 lines/session, 100 sessions = ~3-4 months before any trimming. No context cost since `/start` only reads header + latest session.
2. **iMessage plugin evaluated** — researched official Anthropic plugin (`anthropics/claude-plugins-official/external_plugins/imessage`). Full two-way iMessage integration via chat.db + AppleScript. **Deferred** — Max found it hacky (not sandboxed, uses your real number, Full Disk Access to all messages, awkward self-chat UX). Saved to auto-memory for future reference if a cleaner mobile input channel emerges.
3. **Demo project created** — private repo `bluemax713/demo` ("Acme Tees") for teaching friends/family Claude Code + Playbook. Wholesale t-shirt company scenario. Includes:
   - Seed data: 38 SKUs, 8 buyers, 7 orders (21 line items), 1 deliberately messy spreadsheet
   - RUNBOOK.md: modular demo script — 15/30/45/60 min combos (Quick Win, Build Something, The Memory)
   - reset.sh: one-command cleanup between demos
   - Terminal alias `demo` wired in .zshrc

## Previous Session: 2026-03-23, session 8

1. **README overhaul** — 4 major additions to `README.md`:
   - **Prerequisites section** — Claude Code install instructions for Mac (Terminal + curl) and Windows (VS Code extension or PowerShell). Explains Claude Code vs Claude chat app (context/memory differences). Account requirements + link to Anthropic docs.
   - **"What is a project?" section** — defines project as a self-contained hub, shows folder structure example, explains context isolation between projects, clarifies GitHub is not required.
   - **`/new-project` added** to "What's included" table and Commands section — describes the guided interview process (not just scaffolding).
   - **"After installing" updated** — step 3 now uses `/new-project` instead of manual WORK_LOG creation. Link to GUIDE.md for beginners.
2. **GUIDE.md created** — 235-line beginner's guide for non-technical founders/ops people:
   - 6 sections: What Is This, Key Concepts, Your First Session, Example Conversations, Common Patterns, Tips for Ops People
   - 4 fictional examples using "Sunrise Bakery" (simple update, debugging, complex planning with 3 rounds of back-and-forth, quick fix)
   - Heavy emphasis on planning before execution as the single most important habit
   - Zero developer jargon throughout
3. **`/end` sign-off line** — `commands/end.md` now ends with "Session complete. You can close this window." so users can confirm session ended without scrolling. Synced to `~/.claude/commands/end.md`.
4. **Nomenclature decision** — settled on "project" for top-level repos (what `/new-project` creates), no formal term for subdirectories inside. Rejected "hub" (not natural enough for ops audience) and "workstream" (too close to "workflow").
5. **Committed + pushed** — `55d86fd` on main

## Previous Session: 2026-03-15, session 7

1. **Speedtest CLI integration** — added network diagnostics across 4 playbook files:
   - `templates/tech_stack.md`: new "Diagnostics" section with Speedtest CLI entry
   - `commands/debug.md`: conditional Step 0 — connectivity check only when sessions are slow
   - `README.md`: new "Troubleshooting" section with install instructions and thresholds (>500ms latency, >5% packet loss, <1 Mbps upload)
   - `~/.claude/tech_stack.md` (global): added Speedtest under Diagnostics
2. **Version bump to v1.2.1** — VERSION, CHANGELOG, package.json updated. Published `playbook-ai@1.2.1` to npm.
3. **Committed + pushed** — `bab4a38` on main

## Previous Session: 2026-03-12, session 6

1. **Inbox drop zone convention** — new feature across 4 files:
   - `CLAUDE.md`: new `## Inbox` section — gitignored drop zone, large file warning, implicit intent detection ("check my files" → inbox/), cleanup at /end
   - `commands/start.md`: Step 2 lists inbox files in briefing (name + size), no auto-read
   - `commands/end.md`: inbox cleanup step — extract useful info, move keepers, delete the rest, report
   - `commands/new-project.md`: creates `inbox/` with `.gitkeep`, adds `inbox/*` + `!inbox/.gitkeep` to `.gitignore`
2. **Commands synced** — updated start.md, end.md, new-project.md copied to `~/.claude/commands/`
3. **Committed + pushed** — `6ce6038` on main

## Previous Session: 2026-03-12, session 5

1. **Context bloat fix in `/start`** — `commands/start.md` reads WORK_LOG.md efficiently: first 30 lines + most recent session only (full read if <80 lines). Prevents unbounded context growth across projects.
2. **WORK_LOG auto-trim in `/end`** — `commands/end.md` step 3 trims to 25 sessions max on closeout.
3. **Claude Code version check in `/start`** — nudges users if 2+ minor versions behind v2.0.0.
4. **tech_stack.md template install** — added to both `install.sh` and `update.sh`. Copies template to `~/.claude/tech_stack.md` if missing. Created `templates/tech_stack.md`.
5. **Version bump to v1.2.0** — VERSION, CHANGELOG, package.json, plugin.json, marketplace.json all updated. Published `playbook-ai@1.2.0` to npm.
6. **update.sh improvements** — added `new-project.md` to curl fallback list, added `templates/` directory fetch.
7. **Self-hosted plugin marketplace** — created `.claude-plugin/marketplace.json` + updated `.claude-plugin/plugin.json`. Users can install via `/plugin marketplace add bluemax713/playbook`.
8. **Official Anthropic marketplace** — submitted via form at `claude.ai/settings/plugins/submit`. Awaiting review.
9. **SessionStart hook attempted + reverted** — `SessionStart` is NOT a supported hook type in Claude Code v2.1.x. Available hooks: PreToolUse, PostToolUse, PostToolUseFailure, Notification, UserPromptSubmit. Hook removed from both playbook and Max's settings.json.
10. **Comprehensive CLAUDE.md for magnum** — 94-line file covering tech stack, data pipeline, MCP servers, database/n8n/Metabase rules, session discipline.
11. **Comprehensive CLAUDE.md for rosie-import** — expanded from 32 to ~80 lines. Architecture, vendor conventions, markup types, MCP servers.
12. **Comprehensive CLAUDE.md for palm_beach** — expanded from 87 to ~155 lines. Context log system, audience isolation, all 7 workflows + orchestrators, ApparelMagic rules.
13. **Feedback memory saved** — always sync `commands/*.md` to `~/.claude/commands/` after editing.
14. **Release checklist saved to memory** — 9-step process for version bumps, all files that must stay in sync.

## Decisions (session 5)

- SessionStart hook: NOT supported in Claude Code v2.1.x — will revisit when Anthropic adds session lifecycle hooks
- WORK_LOG trim threshold: 25 sessions (not 3) — months of history before kicking in
- /start reads WORK_LOG efficiently: header + latest session only (not full file)
- Hook trigger: WORK_LOG.md only (not WORK_LOG + CLAUDE.md) — older projects may lack CLAUDE.md
- Version bump 1.2.1 not needed — post-1.2.0 changes are internal packaging only
- Official marketplace: submit once, only re-submit for major versions

## Known Issues / Next Steps
- **Anthropic marketplace review pending** — submitted, awaiting approval. No action needed.
- **SessionStart hook** — blocked on Claude Code adding session lifecycle hooks. Monitor future releases.
- **37 early cloners** from March 7 have old version without auto-update — no action needed
- **CHANGELOG discipline** — see auto-memory `playbook-maintenance.md` for rules on when to bump version
- **Cockpit** — separate project at `bluemax713/cockpit`. Not a playbook task.
- **/brief week-1 tuning (2026-04-22 → 2026-04-29)** — run `/brief` each morning, tune `~/.claude/stakeholders.md` and `~/.claude/style-profile.md` against real drafts. Kill criteria documented in `~/.claude/briefs/deployment-plan.md`. Not a Playbook repo task but worth surfacing here so /start prompts the next session.
- **/brief → Joseph migration (2026-04-29+)** — after tuning, open a Claude Code session in the openclaw project and port /brief logic into Joseph's morning workflow. Directive in deployment-plan.md. Do NOT tell Joseph directly in chat — changes won't stick.
- **gws OAuth expiry** — token refresh failed mid-session today (`invalid_rapt`). Re-auth via `gws auth login`. Expect this to recur every few weeks; factor into any automation that runs /brief unattended.

## Previous Sessions

### 2026-03-11 (session 4)
- Context bloat fix, WORK_LOG trim, Claude Code version check (merged into session 5 above — same day)

### 2026-03-10 (session 3)
- Added `/new-project` command, set up Wildflower project

### 2026-03-09 (session 2)
- Fixed /start flow, Agent Teams + Ralph Loop, tech_stack.md, Cockpit project created, v1.1.0

### 2026-03-09 (session 1)
- Session naming, plugin structure, npm package, published v1.0.0

### 2026-03-08 (session 2)
- npm package structure (package.json, bin/cli.js, lib/installer.js)

### 2026-03-08 (session 1)
- Auto-update mechanism, VERSION, CHANGELOG, update.sh, settings.json
