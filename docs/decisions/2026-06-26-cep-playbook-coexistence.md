# CEP + Playbook Coexistence on Coding Projects

**Date:** 2026-06-26
**Status:** Adopted (dogfooding window)
**Scope:** clenta, emd-platform (dev projects). Playbook repo gets a generic cross-grounding edit.

## Context

Playbook deliberately keeps its coding layer thin (founder-ops focus). Every's **compound-engineering-plugin (CEP)** is a code-pipeline engine: 27 `/ce-*` skills enforcing brainstorm→plan→work→simplify→review→compound, a 16-persona parallel code review, 16-agent planning research, `/lfg` autopilot to an open green PR, and a knowledge-compounding loop (`docs/solutions/` + `CONCEPTS.md`). Max runs two real coding projects (clenta, emd-platform) on Playbook and wants the strongest coding upgrade with near-zero build cost.

## Options considered

- **A — Fork "Playbook-Dev"** that re-implements CEP in Playbook's idiom. Rejected: reinvents 27 skills + 16 personas + converter + CI that Every maintains for free; permanent maintenance lag. Worst ROI.
- **B — Replace Playbook with CEP on dev projects.** Collapses into C, since Max does ops/strategy on clenta too (`/start`, `/end`, `/chess`, `/future` stay useful there).
- **C — Coexist (chosen).** CEP namespaced (`/ce-*`) installs alongside Playbook without literal command collision and without overriding global CLAUDE.md. Playbook = operating shell (session lifecycle, strategy, ops, decision memory); CEP = code pipeline. Bridged by per-project routing + memory-ownership rules.

## Decision

Adopt Option C. Validated via `/chess` System Mode (no plan-breakers; corrected the "near-zero build" framing to "low build" and surfaced cross-grounding as the make-or-break edit). The 5 fixes implemented:

1. **Routing + auto-invocation rules** in each dev project's CLAUDE.md (`## Working with CEP`). Namespacing stops literal clashes, not semantic auto-invocation — the table resolves `review`/`debug`/`compound`/session-close overlaps.
2. **Cross-grounding** in Playbook `/start` (+ `/plan`, `/chess`): surface/skim `docs/solutions/` when it exists, so the two knowledge loops feed each other instead of running parallel. Generic + conditional — no-op for users without `docs/solutions/`. Shipped in Playbook v1.6.11.
3. **Memory-ownership map** (one owner per fact): decisions→`docs/decisions/`; code-pattern learnings→`docs/solutions/` (CEP); vocab→`CONCEPTS.md` (CEP); dated feature plans→`docs/plans/` (CEP `/ce-plan`); session state→`WORK_LOG.md`; durable ops/user facts→Playbook memory. The `docs/plans/` path is shared but non-colliding (CEP uses dated names; ops planning stays in `/plan`/`docs/decisions/`).
4. **`/lfg` guardrail:** low/medium-risk features only; high-risk surfaces (auth, payments, Supabase migrations, edge functions) get a separate independent `/code-review` pass — CEP's in-pipeline review never satisfies the independent-reviewer rule there.
5. **Escape hatch** for stalled worktrees / `/lfg` CI-repair loops (non-technical operator).

**Token-cost scoping:** CEP installs globally but is **enabled only on clenta + emd-platform**, disabled elsewhere. Skill *descriptions* (~1–2k tokens) load only where enabled; heavy 16-agent fan-outs are opt-in per invocation. Net token impact on ops/playbook sessions: zero.

## Public-docs gate (decide later)

Do **not** add CEP to Playbook's public README/GUIDE yet. Dogfood the coexistence on clenta + emd-platform. If it proves out after a few weeks, add a single **optional, caveated** pointer (non-technical caveat, never in the install flow) — never a core dependency. Revisit ~mid-July 2026.

## Reasoning

C beats A on build cost (near-zero vs months) and beats B on honesty (Playbook stays valuable for ops on dev projects). The chess session confirmed C is sound but only delivers compounding *with* the cross-grounding edit — coexistence alone leaves two flywheels spinning independently. The public-docs gate keeps a third-party dependency out of Playbook's brand until it's proven on Max's own projects.
