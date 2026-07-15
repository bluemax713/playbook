# Autopilot auto-resume after usage limits: not built

**Date:** 2026-07-15
**Status:** Decided — do not build. Revisit only per the trigger at the bottom.
**Context:** `/autopilot` (v1.7.1), overnight unattended runs.

## Context

`/autopilot` runs unattended for hours. If it stalls on a usage limit at 2am, nothing restarts it: `/autopilot resume` is manual, and the on-disk run log survives the stall but nothing acts on it. Max asked whether built-in cron existed to kick the run back off when the limit resets, and if so, what the logic was.

## Options considered

1. **Do nothing.** Stall costs "resumes when Max wakes up" instead of "resumes at 3am."
2. **Build cron-based auto-resume.** At a stall, parse the announced reset time, schedule `/autopilot resume` via `CronCreate` for shortly after.
3. **Use the CLI's own retry watchdog.** An undocumented env var, discovered late in the research (see below).

## What the research found

Two subagents, then direct verification. The two disagreed, and **the disagreement is the most useful part of this document.**

**Agent A researched GitHub and the changelog.** Concluded: no auto-resume exists; three feature requests (#38263, #36320, #47276) describe manual resume as current behavior; the v2.1.198 auto-retry covers transient 429/5xx and "explicitly excludes usage-limit stalls."

**Agent B read the shipped binary** (`~/.local/share/claude/versions/2.1.210`, Mach-O with a readable JS string table). Concluded the opposite, and **the binary won.** Verified independently by direct inspection:

```js
function j1e(){ return ut(process.env.CLAUDE_CODE_RETRY_WATCHDOG) }
function LOd(e){ return U1e(e) || e instanceof ui && e.status===429 }

// default path — give up when the wait is too long:
else if (P = q1e(_,I), !j1e() && P > K3y)          // K3y = 60000 (60s)
  throw ... "api_request_retry_after_too_long"

// watchdog path — wait for the real reset:
P = (b instanceof ui && b.status===429 ? d9y(b) : null) ?? Math.min(q1e(l,I,Y3y), OOd)
// d9y reads header `anthropic-ratelimit-unified-reset` (unix ts), computes resetTime*1000 - now()
let n = r*1000 - Date.now(); if (n<=0) return null; return Math.min(n, OOd)   // OOd = 21600000 (6h)
// sleeps in J3y = 30000 (30s) chunks, checking abort + `subscribeRetryWake` each chunk
```

**Both agents were right about different things.** By default, Claude Code gives up when the required wait exceeds 60 seconds — that is the behavior the feature requests describe. When `CLAUDE_CODE_RETRY_WATCHDOG` is set, that branch is skipped and the session sleeps until the actual announced reset, capped at 6 hours, then resumes the same request. There was never a contradiction; Agent A described the default, Agent B found the gate.

**Other findings:**

- **Local install is 2.1.210**, so the v2.1.199 fixes apply: a subagent cut off mid-task by a rate limit returns its **partial work** to the parent rather than failing silently or returning empty. Autopilot's worst structural risk (subagents dying invisibly overnight) is handled upstream.
- **The reset-time field is unreliable in the user-facing message** — inconsistent format, sometimes missing or wrong timezone (open issues #32550, #1450). This killed option 2 on its own: our own cron would have to parse that field. The watchdog does not have this problem — it reads the `anthropic-ratelimit-unified-reset` **header**, not the rendered message.
- **No real usage-limit stall exists in any transcript on this machine.** Every grep hit was a false positive: Clenta product copy about *its own* rate limiting ("Iris is at capacity, resets at midnight"), and `AUTO-COMPACT ... Context limit reached` markers, which are context compaction — a different mechanism. Caveat: the limit message is likely CLI-rendered and may never reach the JSONL, so absence is not proof.
- **`CLAUDE_MOCK_HEADERLESS_429` exists** in the same env-var table. It may allow testing this path without burning quota. Only its registry declaration was found, not its usage site. **Unproven lead.**

## Decision

**Do not build auto-resume into `/autopilot`. Do not depend on the watchdog. Do not enable it globally.**

**Why not build our own (option 2):** it would rest on an unverified assumption (whether a stalled REPL is idle enough for a scheduled prompt to fire — still UNKNOWN, no code found either way), parse a documented-broken field, and run on `CronCreate` jobs that are in-memory and session-only (`durable` is documented as having no effect), so they die when the laptop sleeps — which is the exact overnight scenario they target. For a failure mode never once observed here.

**Why not depend on the watchdog (option 3):** it is undocumented, therefore unsupported and removable without notice. It sits in a table alongside `CLAUDE_MOCK_HEADERLESS_429`, `CLAUDE_ENABLE_BYTE_WATCHDOG`, and `CLAUDE_ENABLE_STREAM_WATCHDOG` — this smells like internal test infrastructure, not a user-facing feature. And we have read the code, not observed it run: runtime behavior is unproven.

**Why not enable it globally:** putting it in the settings.json `env` block would change **every** session, including interactive ones. Today a limit tells you it was hit. With the watchdog on, an interactive session would instead **silently sleep for up to six hours** at a dead terminal. Bad trade when Max is sitting right there.

**The existing fallback is adequate:** the run log is on disk, so a stall costs "resumes when Max wakes" rather than "resumes at 3am." If he is asleep anyway, that delta is small.

## If you want to try it

Scope it to a single autopilot terminal, never to settings.json:

```
CLAUDE_CODE_RETRY_WATCHDOG=1 claude
```

Failure is graceful: if the var is ignored or removed upstream, behavior reverts to today's (give up past 60s). Nothing in the command depends on it.

**Prerequisite already shipped:** v1.7.1's clock discipline is what makes a 6-hour sleep survivable. Under the old command, a run waking from a long sleep had no idea time had passed and would keep working against a hard stop that expired hours ago. With clock discipline it runs `date` at the next wave checkpoint, sees the real time, and winds down correctly. The prerequisite got built first by accident.

## Revisit trigger

Re-open **only** when a real usage-limit stall actually happens during a run. That hands over the artifact for free instead of paying to manufacture it. Absent that, this stays closed.

## The better question this surfaced (not pursued)

The interesting problem is not *recovering* from usage limits but *not hitting them*. Phase 5's wave checkpoints already ask "anything degrading (usage limits)?" and then do nothing concrete with the answer — no shed-work-on-approach behavior. Unlike auto-resume, this needs no unverified assumptions and no undocumented surface. Available if autopilot ever runs hot.

## Process lesson (the durable one)

**Read the artifact, not the discussion about the artifact.** GitHub issues and changelogs describe intent and defaults; the shipped binary describes behavior. The doc-research path produced a confident wrong answer twice in one session, and the binary corrected it both times.

**Control-test your verification before trusting a negative.** The first attempt to verify Agent B returned "not found" for every claimed string — and nearly got a correct agent dismissed as a fabricator. The strings were real; `grep -c` was choking on a 241MB single-line bundle. Only a control search for strings that *must* exist (`ANTHROPIC_API_KEY` → returned 0, which is impossible) exposed the broken method. **A negative result from an unvalidated method is not evidence.** Use `rg -a -o -c` on bundled binaries.
