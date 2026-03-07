#!/bin/bash
# Playbook Installer — Claude Code Operating Playbook
# Copies config files into ~/.claude/ for Claude Code to use.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"

echo "Installing Playbook into $CLAUDE_DIR..."

# Create directories if they don't exist
mkdir -p "$COMMANDS_DIR"

# Copy CLAUDE.md (won't overwrite if exists — user might have customized it)
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  echo "  CLAUDE.md already exists — skipping (back up yours first if you want to replace it)"
else
  cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
  echo "  Installed CLAUDE.md"
fi

# Copy commands (will overwrite — commands are meant to be standard)
for cmd in "$SCRIPT_DIR/commands/"*.md; do
  filename=$(basename "$cmd")
  cp "$cmd" "$COMMANDS_DIR/$filename"
  echo "  Installed command: /$filename"
done

# Copy settings.json (won't overwrite if exists — user might have custom permissions)
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  echo "  settings.json already exists — skipping (review playbook/settings.json to merge permissions)"
else
  cp "$SCRIPT_DIR/settings.json" "$CLAUDE_DIR/settings.json"
  echo "  Installed settings.json"
fi

echo ""
echo "Done! Restart Claude Code to pick up the new config."
echo ""
echo "Next steps:"
echo "  1. Edit ~/.claude/CLAUDE.md to add your name (replace 'you/your' with your preferences)"
echo "  2. Set up your MCP servers in ~/.claude.json (project management, database, etc.)"
echo "  3. Create a WORK_LOG.md in your project root"
echo "  4. Run /start in Claude Code to verify everything works"
