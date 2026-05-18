#!/bin/bash
# PreCompact hook: appends a marker to WORK_LOG.md before context compaction fires.
# Receives session JSON on stdin from Claude Code.
CWD=$(python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('cwd',''))" 2>/dev/null)
[ -z "$CWD" ] && CWD=$(pwd)
WORK_LOG="$CWD/WORK_LOG.md"
if [ -f "$WORK_LOG" ]; then
  TS=$(date "+%Y-%m-%d %H:%M")
  printf "\n---\n**AUTO-COMPACT %s** — Context limit reached mid-session. State above this line may be incomplete. Start a new session to continue.\n" "$TS" >> "$WORK_LOG"
fi
