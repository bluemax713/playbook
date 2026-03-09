#!/usr/bin/env node

import { parseArgs } from 'node:util';
import { install } from '../lib/installer.js';

const USAGE = `
playbook-ai — Operating playbook for non-technical founders working with Claude Code

Usage:
  npx playbook-ai install    Install the playbook to ~/.claude/
  npx playbook-ai --help     Show this help message

Learn more: https://github.com/bluemax713/playbook
`.trim();

const { values, positionals } = parseArgs({
  allowPositionals: true,
  options: {
    help: { type: 'boolean', short: 'h' },
  },
});

const command = positionals[0];

if (values.help || !command) {
  console.log(USAGE);
  process.exit(0);
}

if (command === 'install') {
  await install();
} else {
  console.error(`Unknown command: ${command}\n`);
  console.log(USAGE);
  process.exit(1);
}
