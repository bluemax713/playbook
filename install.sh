#!/bin/bash
# Playbook Installer — Claude Code Operating Playbook
# Copies config files into ~/.claude/ for Claude Code to use.
# Also sets up the local Playbook source for automatic updates.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
PLAYBOOK_DIR="$CLAUDE_DIR/.playbook"
REPO_URL="https://github.com/bluemax713/playbook.git"

echo "Installing Playbook into $CLAUDE_DIR..."

# Create directories if they don't exist
mkdir -p "$COMMANDS_DIR"

# --- Set up Playbook source for updates ---

# Determine if we're running from a git repo
IS_GIT_REPO=false
if [ -d "$SCRIPT_DIR/.git" ] || git -C "$SCRIPT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
  IS_GIT_REPO=true
fi

if [ "$IS_GIT_REPO" = true ]; then
  # Running from a git clone — copy the repo to the standard location
  if [ "$SCRIPT_DIR" != "$PLAYBOOK_DIR" ]; then
    if [ -d "$PLAYBOOK_DIR" ]; then
      echo "  Updating Playbook source at $PLAYBOOK_DIR..."
      rm -rf "$PLAYBOOK_DIR"
    fi
    cp -R "$SCRIPT_DIR" "$PLAYBOOK_DIR"
    echo "  Playbook source saved to $PLAYBOOK_DIR"
  else
    echo "  Already running from $PLAYBOOK_DIR"
  fi
else
  # Not a git repo (downloaded zip, curl, etc.) — try to clone fresh
  if command -v git &> /dev/null; then
    echo "  Cloning Playbook repo for update support..."
    if [ -d "$PLAYBOOK_DIR" ]; then
      rm -rf "$PLAYBOOK_DIR"
    fi
    git clone --quiet "$REPO_URL" "$PLAYBOOK_DIR"
    echo "  Playbook source cloned to $PLAYBOOK_DIR"
  else
    # No git available — copy what we have, updates will use curl
    if [ -d "$PLAYBOOK_DIR" ]; then
      rm -rf "$PLAYBOOK_DIR"
    fi
    cp -R "$SCRIPT_DIR" "$PLAYBOOK_DIR"
    echo "  Playbook source saved to $PLAYBOOK_DIR (install git for easier updates)"
  fi
fi

# --- Install files ---

# Copy CLAUDE.md (won't overwrite if exists — user might have customized it)
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  echo "  CLAUDE.md already exists — skipping (back up yours first if you want to replace it)"
else
  cp "$PLAYBOOK_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
  echo "  Installed CLAUDE.md"
fi

# Copy commands (will overwrite — commands are meant to be standard)
for cmd in "$PLAYBOOK_DIR/commands/"*.md; do
  filename=$(basename "$cmd")
  cp "$cmd" "$COMMANDS_DIR/$filename"
  echo "  Installed command: /${filename%.md}"
done

# Copy settings.json (won't overwrite if exists — user might have custom permissions)
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  echo "  settings.json already exists — skipping (review playbook/settings.json to merge permissions)"
else
  cp "$PLAYBOOK_DIR/settings.json" "$CLAUDE_DIR/settings.json"
  echo "  Installed settings.json"
fi

# Copy tech_stack.md template (won't overwrite if exists — user populates this)
if [ -f "$CLAUDE_DIR/tech_stack.md" ]; then
  echo "  tech_stack.md already exists — skipping"
else
  if [ -f "$PLAYBOOK_DIR/templates/tech_stack.md" ]; then
    cp "$PLAYBOOK_DIR/templates/tech_stack.md" "$CLAUDE_DIR/tech_stack.md"
    echo "  Installed tech_stack.md template"
  fi
fi

# --- Install default plugins ---
if command -v claude &> /dev/null; then
  echo "  Installing default plugins..."
  claude plugin install frontend-design@claude-plugins-official --scope user 2>/dev/null && \
    echo "  Installed plugin: Frontend Design" || \
    echo "  Could not install Frontend Design plugin (install manually: /plugin install frontend-design@claude-plugins-official)"
else
  echo "  Claude Code CLI not found — install Frontend Design plugin manually after setup:"
  echo "    /plugin install frontend-design@claude-plugins-official"
fi

# --- Record installed version ---
if [ -f "$PLAYBOOK_DIR/VERSION" ]; then
  cp "$PLAYBOOK_DIR/VERSION" "$CLAUDE_DIR/.playbook-version"
  echo "  Version $(cat "$CLAUDE_DIR/.playbook-version" | tr -d '\n') installed"
else
  echo "1.0.0" > "$CLAUDE_DIR/.playbook-version"
  echo "  Version 1.0.0 installed"
fi

echo ""
echo "Done! Restart Claude Code to pick up the new config."
echo ""
echo "Next steps:"
echo "  1. Edit ~/.claude/CLAUDE.md to add your name (replace 'you/your' with your preferences)"
echo "  2. Set up your MCP servers in ~/.claude.json (project management, database, etc.)"
echo "  3. Create a WORK_LOG.md in your project root"
echo "  4. Run /start in Claude Code to verify everything works"
echo ""
echo "Playbook will automatically check for updates when you run /start."
