# The Playbook Guide

A beginner's guide for non-technical founders and ops people using Claude Code.

---

## 1. What Is This?

**Claude Code** is a tool that lets Claude (the AI) work directly on your computer. It can read your files, run commands, make changes to your projects, and connect to your tools. It lives in the terminal — that text-based window on your computer that looks like something from a 90s hacker movie. Don't worry, it's friendlier than it looks.

It's different from the regular Claude chat app in a big way: the chat app only sees what you paste into it and forgets everything between conversations. Claude Code can see your entire project, remember your preferences, and pick up exactly where you left off — even days or weeks later.

**Playbook** is a set of rules and commands that turns Claude Code into a structured operating partner. Without Playbook, Claude Code is powerful but unstructured — like hiring a brilliant contractor with no project manager. With Playbook, every session has a clear start, a clear end, and a paper trail. Nothing falls through the cracks.

**The quarterback model:** Claude proposes plays, you call the shots. Claude will present options, explain trade-offs, and wait for your go-ahead before making changes. You don't need to know how to build things — you just need to know what you want and be willing to say "yes," "no," or "try something different."

---

## 2. Key Concepts

**Project** — A folder on your computer that holds everything for one company, product, department, or major initiative. Each project is self-contained: it has its own rules, history, and workspace. You decide where to draw the lines — one project per company, per department, per product, whatever makes sense for how you work. Claude keeps projects separate and won't mix them up unless you tell it to.

**Session** — One working conversation with Claude. You start it with `/start` and end it with `/end`. Each session focuses on one task — this keeps things clean and prevents half-finished work from piling up. Claude remembers everything between sessions, so you never have to re-explain your project.

**Commands** — Shortcuts that trigger specific workflows. You type them, Claude follows the playbook:
- `/start` — Begin a session. Claude reads your project context and briefs you.
- `/end` — Wrap up. Claude saves everything and gives you a summary.
- `/plan` — Think before building. Claude proposes an approach for your approval.
- `/debug` — Something broke. Claude systematically finds and fixes the problem.
- `/quick` — Small, fast change. In and out.

**CLAUDE.md** — The rules file for your project. It tells Claude how to behave — what tools to use, what conventions to follow, what to avoid. Think of it as the employee handbook for your AI co-founder. You can customize it, and Playbook gives you a strong starting template.

**WORK_LOG.md** — The handoff document. Claude updates this at the end of every session so the next one starts with full context. It's how Claude "remembers" what happened — what was built, what decisions were made, what's left to do.

---

## 3. Your First Session

Here's exactly what to do, step by step.

**Step 1: Open the terminal.**
On Mac, it's pre-installed. Press Command + Space to open Spotlight, type "Terminal," and hit Enter. A text window will appear — that's it. On Windows, open VS Code or Windows Terminal.

**Step 2: Go to your project folder.**
If Playbook's `/new-project` command set up your project, it may have created a shortcut. Otherwise, type the following and hit Enter (replace the path with wherever your project lives):

```
cd ~/Documents/my-project
```

**Step 3: Launch Claude Code.**
Type this and hit Enter:

```
claude
```

Claude Code will start up. You'll see a text prompt where you can type messages to Claude.

**Step 4: Start the session.**
Type:

```
/start
```

Claude reads your project files, checks your PM tool if one is connected, and gives you a briefing: where you left off, what's in progress, what needs attention, and suggested next steps. If this is your first session, it'll note that and ask what you'd like to work on.

**Step 5: Tell Claude what you need.**
Just say it in plain English. "I need to update the pricing on my website" or "The checkout page is showing the wrong tax rate." No jargon, no special formatting. Talk to Claude like you'd talk to a smart colleague.

**Step 6: Work together.**
Claude will either jump right in (for simple tasks) or suggest using `/plan` first (for anything complex). Follow its lead. Review what it proposes, approve or redirect, ask questions. This is a conversation, not a one-shot prompt.

**Step 7: Wrap up.**
When you're done, type:

```
/end
```

Claude saves your progress, updates the work log, cleans up temporary files, and gives you a summary of what was accomplished. Next time you start a session, it picks up right where you left off.

---

## 4. Example Conversations

These are fictional examples showing what real sessions feel like.

### Example 1: Simple Task — Updating Business Hours

> **You:** Our new summer hours start Monday. We're open 7am-3pm Tuesday through Saturday, closed Sunday and Monday.
>
> **Claude:** Got it. I found the hours listed in two places — your website's contact page and the footer that appears on every page. I'll update both. Give me a moment.
>
> *Claude makes the changes.*
>
> **Claude:** Done. Both the contact page and the site footer now show the new hours. I also noticed your Google Business profile is linked in the footer — you'll want to update the hours there too, but that's in Google directly, not in your website files.
>
> **You:** Perfect, I'll update Google. Thanks.
>
> **You:** /end

Clean. Five minutes. The kind of thing that used to require emailing your web developer and waiting two days.

### Example 2: Debugging — The Order Form Broke

> **You:** Hey, customers are telling me the order form on the website hasn't been working since yesterday. They click submit and nothing happens.
>
> **Claude:** Let me dig into this. I'll trace the form submission to see where it's failing.
>
> *Claude examines the form, checks the logs, and finds the issue.*
>
> **Claude:** Found it. Your payment processor connection expired yesterday — the API key rotated automatically but the new key wasn't updated in your site's configuration. That's why submissions silently fail. I can update the key now. Do you have the new one, or do you want me to show you where to grab it from your payment dashboard?
>
> **You:** I don't have it handy. Show me where to find it.
>
> **Claude:** Sure. Log into your payment dashboard, go to Settings, then API Keys. Copy the one labeled "Live Secret Key." Paste it here and I'll plug it in.
>
> **You:** Here it is: sk_live_abc123...
>
> **Claude:** Updated. I just submitted a test order and it went through successfully. The form is working again. I'd recommend setting a calendar reminder for the next key rotation so this doesn't catch you off guard.
>
> **You:** Good call. Thanks.

Claude didn't guess. It traced the problem, found the root cause, fixed it, and verified the fix. That's the `/debug` mindset.

### Example 3: Complex Project — Building Inventory Tracking

This one is longer because it shows the planning phase — and that's intentional. Planning is the most important part.

> **You:** I need a way to track my bakery's inventory. Right now I'm using a spreadsheet and it's a mess. I keep running out of flour because I forget to check it.
>
> **Claude:** That's a great candidate for `/plan`. There are a few different ways to approach this, and the right one depends on how you work. Want me to put together some options?
>
> **You:** /plan
>
> **Claude:** Here's what I'm thinking. Three possible approaches:
>
> **Option A — Enhanced spreadsheet.** I clean up your current spreadsheet, add automatic low-stock alerts that email you when something drops below a threshold. Least disruption, builds on what you already know.
>
> **Option B — Simple tracking app.** A lightweight web-based tool where you or your staff log inventory changes. Automatic alerts, usage history, reorder suggestions. More powerful, but there's a learning curve.
>
> **Option C — Full system with supplier integration.** Option B plus automatic reorder emails to your suppliers when stock is low. Most automated, but more complex to set up.
>
> What feels right for where you are now?
>
> **You:** Honestly the spreadsheet is the problem. I want to move away from it. But Option C feels like a lot. Let's go with B.
>
> **Claude:** Good call. A few questions before I draft the plan:
>
> 1. Who updates inventory — just you, or does your team need access too?
> 2. Do you want to log changes from your phone, or is a computer fine?
> 3. What are your top 5 ingredients that run out most often? I'll set those up first so we can test quickly.
>
> **You:** My manager and I both update it. Phone would be great since we're usually in the kitchen. Top items: flour, butter, sugar, eggs, vanilla extract.
>
> **Claude:** Perfect. Here's the plan:
>
> **Phase 1 (this session):** Build a mobile-friendly web page where you and your manager can log inventory. Start with those five ingredients. Each item gets a current quantity, a low-stock threshold, and a simple "add" or "use" button.
>
> **Phase 2 (next session):** Add email alerts when anything drops below its threshold. Add the rest of your ingredients.
>
> **Phase 3 (future):** Usage history and trends — so you can see how fast you go through flour in a typical week.
>
> I'll keep it simple: no logins for now (it'll be on your private network), big buttons that work on a phone screen, and a dashboard that shows everything at a glance.
>
> Sound right, or do you want to adjust anything?
>
> **You:** What if my phone isn't connected to the shop wifi?
>
> **Claude:** Great question. I'll set it up so it's accessible from any internet connection, not just your shop wifi. I'll add a simple password so it's not wide open. That way you can check stock levels from home too.
>
> **You:** Love it. Let's go.

See what happened there? Three rounds of back-and-forth before any building started. Claude proposed options, asked clarifying questions, drafted a phased plan, and the user caught a gap (phone access outside the shop) that would have been a problem later. That ten minutes of planning saved hours of rework.

### Example 4: Quick Fix — Changing a Threshold

> **You:** /quick Change the free shipping threshold from $50 to $75
>
> **Claude:** Found it in the shipping configuration. Updated from $50 to $75. The change is live — I verified it shows "$75.00" on the cart page.
>
> **You:** /end

Thirty seconds. That's what `/quick` is for.

---

## 5. Common Patterns

**When to use `/plan`:**
- Anything that touches multiple parts of your project
- Introducing something new (a feature, a tool, a workflow)
- When you're not sure of the approach
- When the task would take more than 15-20 minutes
- **When in doubt, plan.** It's never wrong to think first.

**When to use `/quick`:**
- Small, obvious changes with a clear target
- Fix a typo, update a number, change a color, swap an image
- Anything where the whole task fits in one sentence

**When to use `/debug`:**
- Something was working and now it isn't
- You're seeing an error you don't understand
- A customer reports a problem
- Don't guess at the cause — let Claude trace it systematically

**When Claude asks for approval vs. just does it:**
Claude asks before making big decisions, changing multiple files, or doing anything that could break existing functionality. For small, safe, well-defined changes, it just handles it. If you want Claude to check in more (or less) often, just say so — "always ask before changing anything" or "you don't need to ask for small stuff."

---

## 6. Tips for Ops People

**You don't need to understand the code.** Claude handles the technical side. Your job is to describe what you want, review what Claude proposes, and make decisions. Think of it like working with a contractor — you don't need to know how to run plumbing, but you need to know you want a sink in the kitchen.

**Be specific about what you want, not how to build it.** "I want customers to get an email when their order ships" is a great instruction. "Write a JavaScript function that calls the SMTP API" is unnecessary. Describe the outcome. Claude figures out the implementation.

**Plan before you build. This is the single most important habit.** The biggest mistake is jumping straight to "just build it" when the task is complex. Take the time to go through `/plan`. Challenge Claude's approach. Ask "what could go wrong?" Ask "is there a simpler way?" Ask "what happens when this breaks at 2am?" A solid plan prevents the kind of rework that eats days. You wouldn't start renovating your kitchen without a blueprint. Same principle.

**Give feedback freely.** If Claude's approach doesn't feel right, say so. "That seems overcomplicated" or "I don't love that — can we do something simpler?" or "What about doing it this way instead?" Claude adapts. You're not going to hurt its feelings.

**One thing at a time.** Playbook enforces one task per session for a reason. Trying to juggle three things at once leads to half-finished work and muddled context. Finish one thing, end the session, start a new one for the next task. It feels slower but it's actually faster.

**When Claude seems stuck, take a step back.** Say "let's try a different approach" or "I think we're overcomplicating this." If the session has gone in circles, Claude can hand off the remaining work to a fresh session with full context. A fresh start is sometimes the fastest path forward.

**Check the work yourself.** Claude verifies its own changes, but you should too. Click the button, load the page, place a test order, check the spreadsheet. Trust but verify — the same way you'd check a contractor's work before signing off.

**Ask Claude to explain when you want to learn.** You don't need to understand the code, but if you're curious about why something works a certain way, ask. "Can you explain what you just did in plain English?" Claude will break it down without jargon. Over time, this builds your intuition for what's possible.

**Save your wins.** When Claude builds something that works well, tell it to document the setup. Future sessions (and future you) will thank you when you need to modify or troubleshoot something six months later.
