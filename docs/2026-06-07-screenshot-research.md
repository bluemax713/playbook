# Screenshots — Extracted & Organized
Generated: 2026-06-07

---

## TOPIC 1: Karpathy's Four Rules + CLAUDE.md Proposal (IMG_3608–3614)
**Series: 8-slide deck, footer says "bluemax713 | Should this be committed?"**
Max appears to have drafted this himself or been building toward committing it.

### What hit #1 on GitHub
- CLAUDE.md by Andrej Karpathy hit #1 on GitHub trending — 82K stars, 7.8K forks
- "Karpathy's Four Rules" were the driver

### Karpathy's Four Rules
1. **Ask, don't assume.** If something is unclear, ask before writing code. Come in with humility.
2. **Simplest solution first.** Implement the simplest solution that solves the problem. Complexity can be added later.
3. **Don't touch unrelated code.** If a file or function is out of scope, don't modify it even if you think it could be improved.
4. **Flag uncertainty explicitly.** If you're not confident in a decision, say so before proceeding. Confidence without certainty causes damage.
5. **Re-read CLAUDE.md at session start.** Read this every time.

### 3 CLAUDE.md behavior patterns
- **1/3 DEFAULTS: Stop re-explaining** — assume CLAUDE.md was read; don't let filler/re-explanation create an error surface
- **2/3 BEHAVIOR: Stay in scope** — confirm before delete/overwrite/migrations; end every task with "file changed, what was touched, follow-up needed"
- **3/3 MEMORY + STACK LOCK** — read WORK_LOG.md at session start; lock tech stack explicitly; flag if a suggestion surfaces something already ruled out

### The math
- ~$75/week per developer in compute across 5 sessions
- Credit: @karpathy, @dannyong, karpathy-skills threads

---

## TOPIC 2: andrej-karpathy-skills Repo (IMG_3604)
**Source: @codingknowledge / Harish Bhatt — "Operator Notes 05.21"**

- Repo: `mittie-ai/andrej-karpathy-skills`
- **142,200 stars**
- "One CLAUDE.md file that fixes the most common coding mistakes LLMs make. Built from a top researcher's notes on agentic failures."
- Language: Markdown
- This is the upstream source for the Karpathy CLAUDE.md behavior rules

---

## TOPIC 3: Operator Notes 05.21 — Developer Tools for Claude Code (IMG_3602–3606)
**Source: @thecorewhittey**

| # | Tool | Stars | What it does |
|---|------|-------|-------------|
| 01 | claude-plugins-official (Anthropic) | 21.1k | Anthropic's official vetted plugin/skills/MCP directory |
| 02 | codegraph (sitepseudeo) | 11.6k | Local code knowledge graph — 70% lower tool calls, 35% cheaper LLM, stays on-machine |
| 03 | andrej-karpathy-skills (mittie-ai) | 142.2k | CLAUDE.md built from Karpathy's agentic failure notes |
| 06 | CLI-Anything (irvus) | 38.6k | Wraps any software in a clean CLI so agents can drive it |
| 07 | chrome-devtools-mcp (chromedevtools) | 48.3k | Official Chrome DevTools MCP — agent gets a real browser to inspect/debug/test live pages |

---

## TOPIC 4: Claude + Obsidian MCP Integration (IMG_3615–3620)
**Source: @techwith.ram — 6-page guide**

**The setup:**
1. Enable the Local REST API community plugin in Obsidian
2. Run `npm install -g @anthropic-ai/claude-code` in terminal
3. Link vault folder path using MCP (Model Context Protocol)

**Once connected:** Claude can read your notes, understand context, and help create.

**Power Workflow 1 — Automated Weekly Review:**
- Claude scans vault for daily notes from past week
- Extracts key insights, decisions, patterns, open loops
- Outputs structured weekly review
- Prompt: "Summarize my notes from this week and highlight key insights, decisions, and open loops."

**Power Workflow 2 — Smart Vault Cleaning:**
- Run `/lint` — Claude scans vault using Obsidian's built-in linter
- Detects broken links, missing files, empty notes
- Auto-fixes what it can, reports the rest

---

## TOPIC 5: Claude Prompt Engineering Role-Play Templates (IMG_3565–3569)
**Source: Unbranded prompt library app (swipe UI)**

Templates for turning Claude into specialized engineering personas:
1. Senior full-stack engineer building production-ready startup MVP (system arch, file structure, DB schema, API endpoints, UI)
2. Senior engineer auditing unfamiliar codebase (bad arch decisions, duplicate logic, bottlenecks, scalability risks)
4. Performance optimization engineer (speed, memory, rendering, execution)
7. Senior frontend engineer (reusable UI components, loading/empty/edge states, a11y)
9. Production security auditor (auth flaws, API weaknesses, injection risks, data exposure)

---

## TOPIC 6: Open-Source vs. SaaS "X kills Y" Series (IMG_3570–3575)
**Source: @hasantoxr**

| Open-Source | Kills | SaaS | Stars | Key stat |
|-------------|-------|------|-------|---------|
| Documenso | DocuSign | e-signature | 9k+ | MIT, self-hostable |
| Cal.com | Calendly | scheduling | 32k+ | $15/seat → source code |
| NocoDB | Airtable | spreadsheet DB | 50k+ | $0 vs $20–45/seat |
| Open WebUI | ChatGPT Plus | chat UI | 70k+ | Pay for model, get UI free |
| Twenty | Salesforce | CRM | 25k+ | $0 vs $150/user/month |
| AnythingLLM | Glean | enterprise RAG | 35k+ | $4.5B valuation for a RAG wrapper |

---

## TOPIC 7: Top GitHub AI Tools — Multiple Lists (IMG_3579–3590)
**Combined from two overlapping list series**

| Tool | Stars | What it does |
|------|-------|-------------|
| Browser Use | 83.5k | Agent browser control — fill forms, shop, scrape |
| OpenHands | 75.8k | Autonomous dev agent — writes code, runs commands, browses |
| Crawl4AI | 67.8k | Turn any website into clean LLM-ready data |
| Dify | ~40k | AI app builder — workflows, prompts, RAG, evaluation, deployment |
| Open WebUI | 70k+ | Self-hosted ChatGPT-style UI for any LLM |
| Maxun | 15.7k | No-code website scraping → APIs and spreadsheets |
| Coolify | — | Self-hosted Vercel/Heroku/Netlify |
| Stirling-PDF | — | Merge, split, OCR, convert, sign, compress PDFs |
| Langflow | — | Visual AI workflow builder with MCP support |

---

## TOPIC 8: Payment Processing — Stripe vs. Polar (IMG_3591)
**Source: @tobi.the.og**

| | Rate | Notes |
|--|------|-------|
| **Stripe** | 2.9% + $0.30 | You handle tax + compliance |
| **Polar.sh** | 4.0% + $0.40 | Merchant of record — they handle tax + compliance |

Key note: "You only pay when you get paid."

---

## TOPIC 9: More Open-Source Tool Showcases (IMG_3577–3578, IMG_3592–3593)
**Source: @codingknowledge / Harish Bhatt**

- **#6 Medusa** — open-source Shopify (MIT, self-hostable, zero rev share). Composable ecommerce framework.
- **#7 Crawl4AI** (67.8k stars) — JavaScript-heavy page handling, outputs LLM-ready data
- **#9 agent-skills** (Addy Osmani / Google engineer) — production-tested Claude Code skills: Spec → Plan → Build → Test → Review → Simplify → Ship
- **#10 Nango** — 800+ pre-built API integrations, hosted OAuth, AI-generated integration code. "What enterprises pay thousands for yearly."

---

## TOPIC 10: Social Media / Low-Signal Content

### "Better Humans Lab" exploit prompts (IMG_3563–3564) — DISCARD
- Fabricated "jailbreak" posts from @2045xai
- "Anti-epistemic cowardice directive" — not real
- "Zero-retention enterprise API protocols" — not real
- Social media snake oil

### "Claude Secret Codes" cheat sheet (IMG_3576) — DISCARD
- /godmode, /devil, /pitch, /shred, etc.
- "command --all to see 150+ detailed commands"
- These are NOT real Claude Code commands — invented social media content

### @rubenhassid AI team structure (IMG_3607)
- Instagram influencer (867K followers) using AI agents as team roles: Chief of Staff, Head of Community, Head of Design, Head of Knowledge, Head of Schedule, etc.
- Interesting as a model for how a one-person business organizes with AI

### Onboarding best practices (IMG_3595) — @thinkentrepreneurs
- 90% of users never see past onboarding
- Spend as much time on onboarding as on the app itself
- 4 goals: invoke emotion, show strongest benefits, feel personalized, include charts/graphs

### One-person business guide (IMG_3601)
- "How To Build A One-Person Business In 2026: (Without Selling Your Sole)"
- Cover page only — no content captured

### UI component libraries (IMG_3599–3600)
- **Watermelon UI** — 260+ open-source components (forms, dashboards, buttons, charts)
- **Cult UI** — 70+ animated components and effects

### AI tools showcase (IMG_3596–3598)
- **Claude Ads** (github.com/AgricDaniel/claude-ads) — free ad auditor, 190 checks, all major platforms
- **Agentic Inbox** — AI email agent built by Cloudflare
- **Camofox Browser** (github.com/jo-inc/camofox-browser) — stealth browser for AI bots, bypasses bot detection, claims 70% lower AI costs
