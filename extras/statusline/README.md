# Statusline (optional)

A three-line custom statusline for Claude Code — a live dashboard that sits at the
bottom of your terminal. It shows, at a glance:

```
Opus 4.8  ▕████████▍░░░▏ 415k/1.0M (42%)  +501 -77 | $67.85
main #42 Fix flaky test | myrepo
Session ▕████░░│░▏ 50% ↻ 05:43 PM   Weekly ▕█▌░│░░░░▏ 20% ↻ 06-15 02:00 AM
```

This is **optional**. It is not part of the standard Playbook install — nothing
runs it unless you wire it up yourself with the two steps below.

## What each line tells you

1. **This conversation** — the model you're on, how full the chat's memory is
   (the bar + `used/max` tokens + %), lines of code changed this session, and the
   session's cost. *On a Pro/Max plan the dollar figure is an estimate of what the
   session would cost at pay-as-you-go API rates — not a charge on top of your plan.*
2. **Your code** — git branch, a clickable PR link (if you use `gh`), vim mode if
   on, the session name, and a repo-aware folder name.
3. **Your plan limits** — Session (5-hour) and Weekly (7-day) usage bars. Each has
   an **even-pace marker** (`│`) that sits at the point in the window you've reached
   in *time*: if the bar's fill stops **short of (left of)** the marker, you've used
   *less* than the clock has — you're under an even burn rate. If the fill goes
   **past (right of)** the marker, you're burning *faster* than the clock. Reset
   times shown in AM/PM. This line only appears on Pro/Max plans.

## Requirements

- `bash` and [`jq`](https://jqlang.github.io/jq/)
- A **256-color**, Unicode-capable terminal on a **dark background**. On a default
  light terminal the bars and box characters may look wrong — this is built for a
  dark theme.
- Optional: [`gh`](https://cli.github.com/) for the clickable open-PR display.
- macOS or Linux (date handling is cross-platform).

## Install

1. Copy `statusline.sh` into your Claude config folder and make it executable:
   ```bash
   cp statusline.sh ~/.claude/statusline.sh
   chmod +x ~/.claude/statusline.sh
   ```
2. Add this line to `~/.claude/settings.json` (inside the top-level `{ }`):
   ```json
   "statusLine": { "type": "command", "command": "bash ~/.claude/statusline.sh" }
   ```

It costs **zero tokens** — it's a local shell script Claude Code runs, not a call
to a model. You'll see it on your next session.

## Preview

```bash
bash preview.sh
```

Renders the bar across a spectrum of states (in real color) so you can see it
without waiting for a live session.

## Customize

The knobs live near the top of `statusline.sh`:

| Want to change… | Where |
|---|---|
| Gradient colors | `RAMP=(...)` — 256-color codes, green→red |
| Pace-marker colors | `CONTRAST=(...)` — paired index-for-index to `RAMP` |
| Bar widths | the `gradient_bar "$x" 12` / `8` calls (context=12, usage=8) |
| Reset time format | the `fmt_epoch` calls (`%I:%M %p` = AM/PM) |

> This version intentionally ships **without** the original's reactive emoticon
> faces and the `($‿$)` cost easter egg — the percentage and bar already convey the
> same thing. If you want them back, they're easy to re-add; see the project history.

## Credit & license

Adapted from a community Claude Code statusline. Public domain / do whatever you
want. No warranty.
