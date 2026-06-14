#!/bin/bash
# ============================================================================
#  Claude Code statusline — gradient usage bars, pace markers
#
#  Three lines:
#    1) model · context-window bar (tokens + %) · lines changed · session cost
#    2) git branch · PR (clickable) · vim mode · session name · repo-aware dir
#    3) Session (5h) + Weekly (7d) usage bars, each with an even-pace target
#       marker showing where you'd be if you spread usage evenly
#
#  Install (settings.json):
#    "statusLine": { "type": "command", "command": "bash /path/to/statusline.sh" }
#
#  Requires: bash, jq.  Optional: gh (open-PR display).
#  Best on a 256-color, Unicode-capable terminal with a DARK background.
#  Cross-platform date handling (macOS/BSD + GNU/Linux).
# ============================================================================

# Read JSON input from stdin
input=$(cat)

# --- Helpers ---
# Compact token formatting: 76275 -> 76k, 1000000 -> 1.0M, 3400 -> 3.4k
fmt_tokens() {
  awk -v n="$1" 'BEGIN{
    if (n >= 1000000)      printf "%.1fM", n/1000000;
    else if (n >= 10000)   printf "%.0fk", n/1000;
    else if (n >= 1000)    printf "%.1fk", n/1000;
    else                   printf "%d", n;
  }'
}

# Format a Unix epoch as a date string. Tries BSD/macOS (date -r EPOCH),
# falls back to GNU/Linux (date -d @EPOCH).  fmt_epoch <epoch> <strftime>
fmt_epoch() {
  date -r "$1" +"$2" 2>/dev/null || date -d "@$1" +"$2" 2>/dev/null
}

# 256-color heat ramp, green -> yellow -> red, applied left-to-right across a bar
RAMP=(46 82 118 154 190 226 220 214 208 202 196)
# Pace-marker contrast color paired index-for-index to RAMP. Bright cells
# (green/yellow/orange) get a dark blue line; the dark-red cells get white.
CONTRAST=(21 21 21 21 21 21 21 21 21 231 231)

# Smooth gradient bar with 1/8-cell resolution: gradient_bar <pct> <width>
# Filled cells fade green->red by position; the leading edge is a partial block.
# Optional <marker_cell> draws a contrasting pace line at that cell index (0-based).
gradient_bar() {
  local pct="$1" width="$2" marker="${3:-}"
  local int total_eighths full part i color ramp_idx contrast out=""
  local parts=(" " "▏" "▎" "▍" "▌" "▋" "▊" "▉")
  local nramp=${#RAMP[@]}
  int=$(printf "%.0f" "$pct" 2>/dev/null || echo 0)
  if [ "$int" -lt 0 ];   then int=0;   fi
  if [ "$int" -gt 100 ]; then int=100; fi
  total_eighths=$(( int * width * 8 / 100 ))
  full=$(( total_eighths / 8 ))
  part=$(( total_eighths % 8 ))
  for (( i=0; i<width; i++ )); do
    if [ "$width" -gt 1 ]; then
      ramp_idx=$(( i * (nramp - 1) / (width - 1) ))
    else
      ramp_idx=0
    fi
    color="${RAMP[$ramp_idx]}"
    # Even-pace target marker: thin line. Over the filled bar it sits on the fill
    # color in a contrasting hue (no black notch); over the empty track it is white.
    if [ -n "$marker" ] && [ "$i" -eq "$marker" ]; then
      if (( i < full || (i == full && part > 0) )); then
        contrast="${CONTRAST[$ramp_idx]}"
        out+="\033[0m\033[48;5;${color}m\033[38;5;${contrast}m│\033[0m"
      else
        out+="\033[0m\033[97m│\033[0m"
      fi
      continue
    fi
    if (( i < full )); then
      out+="\033[38;5;${color}m█"
    elif (( i == full )) && (( part > 0 )); then
      out+="\033[38;5;${color}m${parts[$part]}"
    else
      out+="\033[38;5;240m░"
    fi
  done
  out+="\033[0m"
  printf "%b" "$out"
}

# --- Extract values ---
model=$(echo "$input" | jq -r '.model.display_name')
# Effort level: try JSON input first, fall back to settings.json
effort=$(echo "$input" | jq -r '.effort.level // .effort_level // empty')
if [ -z "$effort" ]; then
  effort=$(jq -r '.effortLevel // empty' ~/.claude/settings.json 2>/dev/null)
fi
if [ -n "$effort" ]; then
  # Capitalize first letter
  effort="$(echo "${effort:0:1}" | tr '[:lower:]' '[:upper:]')${effort:1}"
  model="${model} ${effort}"
fi
session_used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_used_tokens=$(echo "$input"  | jq -r '.context_window.total_input_tokens // empty')
ctx_max_tokens=$(echo "$input"   | jq -r '.context_window.context_window_size // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Rate limits (Pro/Max only, present after first API response — guard everything)
fh_pct=$(echo "$input"   | jq -r '.rate_limits.five_hour.used_percentage // empty')
fh_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
sd_pct=$(echo "$input"   | jq -r '.rate_limits.seven_day.used_percentage // empty')
sd_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# --- Git info ---
git_branch=""
git_pr=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || echo "")

  if [ -n "$branch" ]; then
    git_branch="\033[0;36m${branch}\033[0m"

    # Look up open PR for this branch via gh (suppress all errors; gh may not be auth'd in every session)
    if command -v gh > /dev/null 2>&1; then
      pr_info=$(GIT_DIR="$cwd/.git" gh pr view "$branch" \
        --json number,title,isDraft,url \
        --jq '"\(.number)|\(.title)|\(.isDraft)|\(.url)"' 2>/dev/null || echo "")
      if [ -n "$pr_info" ]; then
        pr_num=$(echo "$pr_info"  | cut -d'|' -f1)
        pr_title=$(echo "$pr_info" | cut -d'|' -f2)
        pr_draft=$(echo "$pr_info" | cut -d'|' -f3)
        pr_url=$(echo "$pr_info"  | cut -d'|' -f4)

        # Truncate long titles
        if [ "${#pr_title}" -gt 50 ]; then
          pr_title="${pr_title:0:47}..."
        fi

        # Draft PRs get a dimmed prefix
        if [ "$pr_draft" = "true" ]; then
          pr_label="\033[2mDRAFT \033[0m"
        else
          pr_label=""
        fi

        # Clickable PR number (OSC 8 hyperlink — works in iTerm2, WezTerm, Kitty)
        pr_link="\033]8;;${pr_url}\a\033[0;33m#${pr_num}\033[0m\033]8;;\a"
        git_pr=" ${pr_label}${pr_link}"
      fi
    fi
  fi
fi

# Compose git segment
git_segment=""
if [ -n "$git_branch" ] || [ -n "$git_pr" ]; then
  git_segment=" | ${git_branch}${git_pr}"
fi

# --- Context window bar: ▕████████▍░░░▏ 76k/1.0M (8%) ---
ctx_segment=""
if [ -n "$session_used_pct" ]; then
  ctx_int=$(printf "%.0f" "$session_used_pct")
  ctx_bar=$(gradient_bar "$session_used_pct" 12)
  tok=""
  if [ -n "$ctx_used_tokens" ] && [ -n "$ctx_max_tokens" ]; then
    tok="$(fmt_tokens "$ctx_used_tokens")/$(fmt_tokens "$ctx_max_tokens") "
  fi
  ctx_segment=" \033[2m▕\033[0m${ctx_bar}\033[2m▏\033[0m ${tok}(${ctx_int}%)"
fi

# --- Session (5h) + Weekly (7d) usage line ---
fh_part=""
if [ -n "$fh_pct" ]; then
  fh_int=$(printf "%.0f" "$fh_pct")
  # Even-pace target: where session usage "should" sit if spread evenly across the
  # 5-hour window. Marker cell = fraction of the window already elapsed.
  fh_marker=""
  if [ -n "$fh_reset" ]; then
    FIVEH=18000
    now_epoch=$(date +%s)
    rem=$(( fh_reset - now_epoch ))            # seconds until reset
    if [ "$rem" -lt 0 ];       then rem=0;       fi
    if [ "$rem" -gt "$FIVEH" ]; then rem=$FIVEH; fi
    fh_marker=$(( (FIVEH - rem) * 8 / FIVEH ))  # elapsed fraction -> cell index
    if [ "$fh_marker" -gt 7 ]; then fh_marker=7; fi
    if [ "$fh_marker" -lt 0 ]; then fh_marker=0; fi
  fi
  fh_bar=$(gradient_bar "$fh_pct" 8 "$fh_marker")
  fh_time=""
  [ -n "$fh_reset" ] && fh_time=" \033[2m↻ $(fmt_epoch "$fh_reset" "%I:%M %p")\033[0m"
  fh_part="\033[0;36mSession\033[0m \033[2m▕\033[0m${fh_bar}\033[2m▏\033[0m ${fh_int}%${fh_time}"
fi
sd_part=""
if [ -n "$sd_pct" ]; then
  sd_int=$(printf "%.0f" "$sd_pct")
  # Even-pace target: where weekly usage "should" sit if spread evenly across the
  # 7-day window. Marker cell = fraction of the week already elapsed.
  sd_marker=""
  if [ -n "$sd_reset" ]; then
    WEEK=604800
    now_epoch=$(date +%s)
    rem=$(( sd_reset - now_epoch ))            # seconds until reset
    if [ "$rem" -lt 0 ];      then rem=0;      fi
    if [ "$rem" -gt "$WEEK" ]; then rem=$WEEK; fi
    sd_marker=$(( (WEEK - rem) * 8 / WEEK ))   # elapsed fraction -> cell index
    if [ "$sd_marker" -gt 7 ]; then sd_marker=7; fi
    if [ "$sd_marker" -lt 0 ]; then sd_marker=0; fi
  fi
  sd_bar=$(gradient_bar "$sd_pct" 8 "$sd_marker")
  sd_time=""
  [ -n "$sd_reset" ] && sd_time=" \033[2m↻ $(fmt_epoch "$sd_reset" "%m-%d %I:%M %p")\033[0m"
  sd_part="\033[0;36mWeekly\033[0m \033[2m▕\033[0m${sd_bar}\033[2m▏\033[0m ${sd_int}%${sd_time}"
fi
usage_line=""
if [ -n "$fh_part" ] && [ -n "$sd_part" ]; then
  usage_line="${fh_part}   ${sd_part}"
elif [ -n "$fh_part" ]; then
  usage_line="$fh_part"
elif [ -n "$sd_part" ]; then
  usage_line="$sd_part"
fi

# --- Session cost (to the penny) ---
cost_display=""
if [ "$cost" != "0" ] && [ "$cost" != "null" ] && [ "$cost" != "" ]; then
  cost_fmt=$(printf "%.2f" "$cost" 2>/dev/null)
  cost_display=" | \033[0;32m\$${cost_fmt}\033[0m"
fi

# --- Directory: repo-aware. <repo>, <repo>/<subpath>, or <repo> ⑂<worktree> ---
# Outside a git repo, fall back to the plain folder name.
short_dir=$(basename "$cwd")
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  # --git-common-dir points at the MAIN repo's .git even from a linked worktree,
  # so its parent is the true repo root (not the worktree folder).
  common=$(git -C "$cwd" rev-parse --git-common-dir 2>/dev/null)
  case "$common" in /*) ;; *) common="$cwd/$common" ;; esac
  repo_root=$(cd "$(dirname "$common")" 2>/dev/null && pwd)
  if [ -n "$repo_root" ]; then
    repo_name=$(basename "$repo_root")
    abs_git_dir=$(git -C "$cwd" rev-parse --absolute-git-dir 2>/dev/null || echo "")
    case "$abs_git_dir" in
      */worktrees/*) short_dir="${repo_name} ⑂$(basename "$cwd")" ;;
      *)
        if [ "$cwd" = "$repo_root" ]; then
          short_dir="$repo_name"
        else
          short_dir="${repo_name}/${cwd#"$repo_root"/}"
        fi
        ;;
    esac
  fi
fi

# --- Vim mode indicator ---
vim_mode=""
vim_mode_raw=$(echo "$input" | jq -r '.vim.mode // empty')
if [ -n "$vim_mode_raw" ]; then
  if [ "$vim_mode_raw" = "NORMAL" ]; then
    vim_mode=" \033[0;33m[NORMAL]\033[0m"
  else
    vim_mode=" \033[0;32m[INSERT]\033[0m"
  fi
fi

# --- Session name (if renamed) ---
session_name=""
session_name_raw=$(echo "$input" | jq -r '.session_name // empty')
if [ -n "$session_name_raw" ]; then
  session_name=" \033[0;35m\"${session_name_raw}\"\033[0m"
fi

# --- Lines changed ---
lines_display=""
if [ "$lines_added" != "0" ] || [ "$lines_removed" != "0" ]; then
  lines_display=" \033[0;32m+${lines_added}\033[0m \033[0;31m-${lines_removed}\033[0m"
fi

# --- Assemble output ---
# Line 1: Model ▕████▏ 76k/1.0M (8%) +42 -15 | $0.96
printf "\033[0;35m%s\033[0m%b%b%b\n" \
  "$model" \
  "$ctx_segment" \
  "$lines_display" \
  "$cost_display"

# Line 2: branch #42 PR title | folder
printf "%b%b%b | \033[0;34m%s\033[0m\n" \
  "${git_branch}${git_pr}" \
  "$vim_mode" \
  "$session_name" \
  "$short_dir"

# Line 3 (only if rate-limit data present): Session ▕██░░▏ 15% ↻ 11:30   Weekly ▕░░▏ 3% ↻ 06-18 02:00
if [ -n "$usage_line" ]; then
  printf "%b\n" "$usage_line"
fi
