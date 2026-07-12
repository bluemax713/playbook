#!/usr/bin/env node

/**
 * Generates skills/ from commands/ to keep the plugin in sync.
 * Run: node scripts/build-skills.js
 *
 * commands/*.md = single source of truth
 * skills/<name>/SKILL.md = generated for the plugin format
 */

import { promises as fs } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const COMMANDS_DIR = path.join(ROOT, 'commands');
const SKILLS_DIR = path.join(ROOT, 'skills');

// Skill descriptions — keep in sync when adding new commands
const SKILL_META = {
  start: {
    description:
      'Session kickoff. Checks for playbook updates, reads WORK_LOG.md and CLAUDE.md, and presents a briefing with status, issues, and suggested next steps. Use when starting a new work session.',
  },
  end: {
    description:
      'Session closeout. Saves all progress to WORK_LOG.md, updates PM tools, cleans up temp files, commits and pushes changes, and presents a summary. Ensures zero information loss between sessions.',
  },
  plan: {
    description:
      'Structured planning before multi-file changes. Assesses complexity, brainstorms approaches with tradeoffs if needed, then produces a scoped implementation plan with steps, dependencies, and risks. Use before any non-trivial change.',
  },
  debug: {
    description:
      'Systematic debugging process. Reproduces the bug, isolates the root cause, applies a minimal fix, and verifies it works with no regressions. Use when something is broken or behaving unexpectedly.',
  },
  quick: {
    description:
      'Quick mode for bug fixes, small changes, and one-off tasks. Skips the full session briefing, does the task, logs a brief WORK_LOG entry, and commits. Use for small, well-defined tasks that don\'t need ceremony.',
  },
  handoff: {
    description:
      'Generates a self-contained prompt for a parallel Claude Code session. Creates a complete context block with task instructions, file paths, and output rules for pasting into a new terminal. For Claude to invoke when work should be split into a parallel session.',
    disableModelInvocation: true,
  },
  chess: {
    description:
      'Adversarial strategy analysis. Human Mode models a real opponent and traces move branches; System Mode attacks a technical plan to find failure points before building. Use for negotiations, partnerships, competitive moves, or stress-testing a plan.',
  },
  future: {
    description:
      'Scenario planning via three futures (The Win, The Unraveling, The Headwind). Rewinds each path to today, surfaces the decisions that matter most across scenarios, and gives one specific action this week. Use when navigating uncertainty.',
  },
  'new-project': {
    description:
      'Full project setup with a guided interview — clone or create a repo, wire local config (CLAUDE.md, WORK_LOG.md, MCP servers), and get ready for a first session. Use when starting work on a new project.',
  },
  autopilot: {
    description:
      'Unattended multi-task execution for one project. Harvests the backlog, resolves every ambiguity in one up-front interview, gets a flight plan approved, then plans/builds/reviews through it with parallel subagents. Builds but never merges — the user returns to a landing report and a merge queue. Use before stepping away for hours.',
  },
};

async function build() {
  const commandFiles = (await fs.readdir(COMMANDS_DIR)).filter((f) =>
    f.endsWith('.md')
  );

  let generated = 0;
  let warnings = 0;

  for (const file of commandFiles) {
    const name = file.replace(/\.md$/, '');
    const meta = SKILL_META[name];

    if (!meta) {
      console.warn(`  ⚠ No metadata for commands/${file} — add it to SKILL_META in this script`);
      warnings++;
      continue;
    }

    const commandContent = await fs.readFile(
      path.join(COMMANDS_DIR, file),
      'utf-8'
    );

    // Build frontmatter
    let frontmatter = `---\nname: ${name}\ndescription: ${meta.description}\n`;
    if (meta.disableModelInvocation) {
      frontmatter += 'disable-model-invocation: true\n';
    }
    frontmatter += '---\n';

    const skillContent = frontmatter + '\n' + commandContent;

    const skillDir = path.join(SKILLS_DIR, name);
    await fs.mkdir(skillDir, { recursive: true });
    await fs.writeFile(path.join(skillDir, 'SKILL.md'), skillContent);

    generated++;
  }

  console.log(`Generated ${generated} skill(s) from ${commandFiles.length} command(s).`);
  if (warnings > 0) {
    console.log(`${warnings} warning(s) — see above.`);
    process.exit(1);
  }
}

build().catch((err) => {
  console.error('Build failed:', err.message);
  process.exit(1);
});
