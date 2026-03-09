#!/bin/bash
# Playbook Updater — Fetches latest version and updates commands + settings.
# Called by /start when an update is available and the user approves.
# CLAUDE.md is NOT touched by this script — Claude handles that interactively.

set -e

CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
PLAYBOOK_DIR="$CLAUDE_DIR/.playbook"
REPO_URL="https://github.com/bluemax713/playbook.git"
RAW_BASE="https://raw.githubusercontent.com/bluemax713/playbook/main"
TEMP_DIR="$CLAUDE_DIR/.playbook-update-tmp"

# --- Fetch latest source ---

fetch_via_git() {
  if [ -d "$PLAYBOOK_DIR/.git" ]; then
    git -C "$PLAYBOOK_DIR" pull --quiet origin main 2>/dev/null
    return $?
  elif command -v git &> /dev/null; then
    rm -rf "$PLAYBOOK_DIR"
    git clone --quiet "$REPO_URL" "$PLAYBOOK_DIR" 2>/dev/null
    return $?
  fi
  return 1
}

fetch_via_curl() {
  # Download key files individually via GitHub raw content
  local files=("VERSION" "CHANGELOG.md" "CLAUDE.md" "settings.json" "install.sh" "update.sh")
  local cmd_files=("start.md" "end.md" "plan.md" "debug.md" "quick.md" "handoff.md")

  mkdir -p "$PLAYBOOK_DIR/commands"

  for f in "${files[@]}"; do
    curl -sf "$RAW_BASE/$f" -o "$PLAYBOOK_DIR/$f" || return 1
  done

  for f in "${cmd_files[@]}"; do
    curl -sf "$RAW_BASE/commands/$f" -o "$PLAYBOOK_DIR/commands/$f" || return 1
  done

  return 0
}

echo "Updating Playbook..."

# Try git first, fall back to curl
if ! fetch_via_git; then
  if ! fetch_via_curl; then
    echo "ERROR: Could not fetch updates. Check your internet connection."
    exit 1
  fi
fi

# --- Stage updates in temp directory (atomic) ---

rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR/commands"

# Copy commands to temp
for cmd in "$PLAYBOOK_DIR/commands/"*.md; do
  [ -f "$cmd" ] && cp "$cmd" "$TEMP_DIR/commands/"
done

# Copy settings.json to temp (will be merged, not overwritten)
if [ -f "$PLAYBOOK_DIR/settings.json" ]; then
  cp "$PLAYBOOK_DIR/settings.json" "$TEMP_DIR/settings.json"
fi

# --- Validate staged files ---

# Check that key files exist in temp
if [ ! -f "$TEMP_DIR/commands/start.md" ]; then
  echo "ERROR: Update validation failed — missing start.md. Update aborted."
  rm -rf "$TEMP_DIR"
  exit 1
fi

# --- Apply updates ---

# Commands: overwrite (they're standard)
for cmd in "$TEMP_DIR/commands/"*.md; do
  filename=$(basename "$cmd")
  cp "$cmd" "$COMMANDS_DIR/$filename"
  echo "  Updated command: /${filename%.md}"
done

# Settings.json: additive merge
if [ -f "$TEMP_DIR/settings.json" ] && [ -f "$CLAUDE_DIR/settings.json" ]; then
  # Use a simple merge strategy: if the user has settings.json, we don't overwrite.
  # Claude will handle intelligent merging of new permissions in /start if needed.
  echo "  settings.json: existing file preserved (new permissions will be suggested in /start)"
elif [ -f "$TEMP_DIR/settings.json" ]; then
  cp "$TEMP_DIR/settings.json" "$CLAUDE_DIR/settings.json"
  echo "  Installed settings.json"
fi

# --- Update version (LAST — only on success) ---

if [ -f "$PLAYBOOK_DIR/VERSION" ]; then
  cp "$PLAYBOOK_DIR/VERSION" "$CLAUDE_DIR/.playbook-version"
  echo "  Updated to version $(cat "$CLAUDE_DIR/.playbook-version" | tr -d '\n')"
fi

# --- Cleanup ---

rm -rf "$TEMP_DIR"
echo "Update complete."
