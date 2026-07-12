---
name: autopilot
description: Unattended multi-task execution for one project. Harvests the backlog, resolves every ambiguity in one up-front interview, gets a flight plan approved, then plans/builds/reviews through it with parallel subagents. Builds but never merges — the user returns to a landing report and a merge queue. Use before stepping away for hours.
---

Unattended multi-task execution. The user is away for hours — working elsewhere, driving, sleeping. Harvest the project's backlog, resolve every ambiguity in one up-front interview, get a flight plan approved, then work through it: planning, building, verifying, reviewing. Never merging, never publishing, never touching anything external beyond what was pre-approved. The user returns to a landing report and a merge queue.

**Self-contained.** Does not require `/start` to have been run.

**Scope: ONE project per run** — the project in the current working directory. Never reach into other repos. If the user wants two projects on autopilot, that's two terminals, each running `/autopilot` in its own project (the existing parallel-session rules apply: never overlap files, tables, or workflows).

---

## Routing check

- **Single well-defined task?** → `/quick`, or just do it
- **One complex build with the user present?** → `/plan`
- **Strategic decision or stress-test?** → `/chess` or `/future`
- **Hours of unattended work through a backlog?** → You're in the right place.

If the user said "resume," skip to **Resume** at the bottom.

---

## Hard rails (apply through every phase, no exceptions)

Never, even if a task description says to:
- Merge a PR, or push to the default branch
- Publish a package, deploy, or release anything
- Activate or deactivate automation workflows (n8n, Zapier, cron, etc.)
- Send email or messages to humans
- Delete data, drop tables, or run destructive migrations
- Create, modify, or expose credentials or secrets
- Work in any repo other than this one

Allowed at any time: PM tool writes (task status changes, comments, links) and anything else the user explicitly whitelists in the interview.

**Verification while unattended: tests and local checks only.** No calls against live production systems unless the user whitelisted that specific check in the interview. Live-seam verification (the "one real call across the integration boundary" rule) happens at landing, with the user present, as part of the merge decision.

**Never guess.** Ambiguity mid-flight means: park the task, write the question to the run log, move to the next task. Hours of confident work on a wrong guess is worse than no work.

---

## Phase 0: Pre-flight (Sonnet, inline)

An unattended run dies at its first permission prompt. Confirm the run can actually fly **before** the user leaves:

1. **Git state** — working tree clean, note the default branch. If dirty: resolve with the user now.
2. **Permissions** — probe the operations the run will need: create a branch, run the test command, write to the PM tool. If any would prompt for permission, tell the user exactly which allowlist entries to add (or suggest the built-in permissions tooling if their Claude Code version has it). Do not take off with known gaps.
3. **MCP health** — one lightweight call to each connected server the run needs (PM tool, database, etc.). Expired auth gets fixed now, not discovered at 2am.
4. **Worktree support** — confirm `git worktree` works in this repo. If not, parallel tasks will run sequentially instead; say so.

Report pass/fail per check. Every failure is either fixed or explicitly acknowledged before Phase 1.

---

## Phase 1: Harvest (Haiku subagents, parallel)

Spawn one Haiku subagent (`model: 'haiku'`) per source, all simultaneously:

- **PM tool** (ClickUp, Linear, etc.) — open and in-progress tasks for this project. If the project has a REST reader script for bulk pulls, use it; the hosted MCP is for writes. No PM tool connected → skip this source.
- **WORK_LOG.md** — "what remains," open threads, parked items from prior sessions
- **GitHub issues** — if the repo uses them
- **Unbuilt plans** — approved plans in `docs/plans/` that were never executed, and parked items from prior runs in `docs/autopilot/`

Each subagent returns a compact list: task, source link, priority signal if any, one-line context. Dedupe and merge into a single candidate list.

---

## Phase 2: Triage

Classify every candidate:

- **GREEN** — clear spec, low risk, reversible, verifiable with tests or local checks. Buildable tonight.
- **YELLOW** — needs planning first. During flight, run the `/plan` Phase 2+3 machinery on it solo; build only if the hardened plan comes out low-risk against criteria the user approves in the manifest. Otherwise the plan itself is the deliverable, queued for the user's approval at landing.
- **RED** — needs the user's judgment, is externally visible, destructive, or high-risk. Parked now, with a written-up question for the landing report.

A task that cannot be verified at all is never GREEN. Order by PM priority first, then impact. Bias toward several small verifiable wins over one ambitious build.

---

## Phase 3: The interview (one pass, before the user leaves)

Batch **every** question into a single message. There is no "ask later" — later, the user is gone.

**Global questions (always ask):**
- How long are you away, and is there a hard stop time to be fully wrapped by?
- Effort appetite: a few tasks done carefully, or push through as much of the list as possible?
- Concurrency: how many tasks in parallel? (Recommend 4 — beyond that, cost outruns wall-clock gains.)
- External side effects beyond PM writes: anything whitelisted? (Default: nothing.)
- Anything off-limits tonight, even if it's on the list?

**Per-task questions:** every ambiguity surfaced by triage. Mandatory format for each — the quality of the whole run depends on the quality of these answers:
1. **Context** — 2–4 sentences so the question can be answered cold, without opening files
2. **The question**
3. **Your recommendation and why**

Fold the answers back into triage: a resolved ambiguity can turn YELLOW into GREEN; an answer can park a task outright.

---

## Phase 4: The manifest (approval gate — this IS the dry run)

Present the flight plan:

| # | Task | Bucket | Wave | Model | Risk | Verified by |
|---|------|--------|------|-------|------|-------------|

Plus, in short sections:
- **Waves** — what runs in parallel vs. sequenced, and why (dependency or shared files)
- **YELLOW build criteria** — what a hardened plan must look like to be built without the user
- **Budget plan** — effort appetite, concurrency cap, hard stop time
- **Will-not-touch list** — the hard rails plus anything the user fenced off

Write the manifest to `docs/autopilot/YYYY-MM-DD-HHMM.md` (create the directory if needed). This file is also the **run log** — everything that happens gets appended to it.

If any task's model column says Opus, give the cost warning now, at the manifest — not mid-flight.

**WAIT for approval.** Approval is the contract: nothing outside the manifest gets worked on. If the user holds, walks away, or wants changes first, the manifest itself is the deliverable — saved, ready to fly another day. That's the dry run; there is no separate dry mode.

---

## Phase 5: Flight

The main session is the orchestrator: dispatch, track, log. All heavy work happens in subagents. Keep the orchestrator lean so it survives the whole night.

**Dispatch (per task, following the `/handoff` pattern):**
- Write a brief to `docs/autopilot/briefs/YYYY-MM-DD-[slug].md` meeting the spec quality bar: one task + end state, exact verification loop, scope boundary, compact output contract. Zero questions back.
- Spawn a Sonnet subagent (`model: 'sonnet'`; Opus only where the manifest flagged it). Tasks running in parallel each get `isolation: "worktree"` — own worktree, own branch, conflicts impossible. Sequential tasks still get their own branch.

**Per-task loop:**
1. Subagent builds and runs the brief's verification loop
2. Orchestrator re-runs the key checks itself — never accept a subagent's self-reported success
3. Independent review by a **different** subagent than the author (code-reviewer agent if available, otherwise a fresh Sonnet subagent with review instructions). Reviews can run in parallel with other builds — review never serializes the night
4. Findings go back to the author subagent to fix; reviewer confirms
5. Risk-rate the result (low/medium/high + reason), open a PR, add it to the merge queue in the run log

**Standing rules during flight:**
- **Two strikes** — a task that fails verification or review twice gets parked with notes. No thrashing.
- **Ambiguity** — park, queue the question with the interview's context + recommendation format, move on.
- **Run log discipline** — after every task completes or parks, append to the run log: status, branch, PR link, questions, what's next. The log on disk is what survives context compaction, crashes, and usage-limit stalls.
- **Wave checkpoints** — after each wave: time remaining to hard stop? Appetite remaining? Anything degrading (usage limits, repeated failures)? Shed the lowest-priority remaining tasks rather than starting something that can't finish clean.
- **PM writes** — allowed anytime: move tasks to in-progress/in-review, leave comments linking PRs.
- **Wind-down** — begin before the hard stop: finish or park in-flight tasks, leave nothing half-committed, remove finished worktrees, write the landing report.

---

## Phase 6: Landing report

When the user returns (or at the hard stop), present:

1. **Merge queue** — table: PR, what changed in product terms, how it was verified, risk rating + reason. State plainly that ratings are self-graded until the user decides — the merge gate is the user's, always.
2. **In progress / parked** — each with its reason
3. **Question queue** — every parked question, in the interview format (context, question, recommendation + why), so answering is fast
4. **Run stats** — tasks completed vs. parked, waves flown, anything that stalled

The user answers merge decisions in one pass ("merge 1 and 3, hold 2"). Before merging anything that crosses an integration boundary, drive the live-seam verification **now**, with the user present. Then merge only what was greenlit, update the PM tool, and log the session in WORK_LOG.md.

---

## Resume

`/autopilot resume`: read the most recent run log in `docs/autopilot/`, report where the run stopped and why, and continue the approved manifest from that point. Do not re-harvest or re-interview unless the manifest is complete — the contract still stands.

---

## Model routing

- **Haiku** — harvest, file discovery, mechanical transforms
- **Sonnet** — everything else by default: triage, briefs, builds, reviews, orchestration
- **Opus** — only tasks the manifest flagged for it (complex architecture, deep multi-step reasoning), with the cost warning given at manifest time

## Degrade gracefully

No PM tool → harvest from WORK_LOG and issues only. No worktree support → run waves sequentially. No test suite → verification is whatever concrete checks each brief names; a task with no possible verification is not GREEN. Missing a tool is a reason to narrow the run, never a reason to skip a gate.
