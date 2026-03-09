import { promises as fs } from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const PACKAGE_ROOT = path.resolve(__dirname, '..');

const CLAUDE_DIR = path.join(os.homedir(), '.claude');
const COMMANDS_DIR = path.join(CLAUDE_DIR, 'commands');
const PLAYBOOK_DIR = path.join(CLAUDE_DIR, '.playbook');

// Files to copy into .playbook/ for the update mechanism
const PLAYBOOK_SOURCE_FILES = [
  'CLAUDE.md',
  'settings.json',
  'install.sh',
  'update.sh',
  'VERSION',
  'CHANGELOG.md',
];

export async function install() {
  console.log(`Installing Playbook into ${CLAUDE_DIR}...`);

  // Create directories
  await fs.mkdir(COMMANDS_DIR, { recursive: true });
  await fs.mkdir(PLAYBOOK_DIR, { recursive: true });

  const summary = { installed: [], skipped: [] };

  // --- Install CLAUDE.md ---
  const claudeMdDest = path.join(CLAUDE_DIR, 'CLAUDE.md');
  if (await fileExists(claudeMdDest)) {
    summary.skipped.push('CLAUDE.md (already exists)');
  } else {
    await fs.copyFile(path.join(PACKAGE_ROOT, 'CLAUDE.md'), claudeMdDest);
    summary.installed.push('CLAUDE.md');
  }

  // --- Install commands (always overwrite) ---
  const commandsSource = path.join(PACKAGE_ROOT, 'commands');
  const commandFiles = await fs.readdir(commandsSource);
  for (const file of commandFiles) {
    if (!file.endsWith('.md')) continue;
    await fs.copyFile(
      path.join(commandsSource, file),
      path.join(COMMANDS_DIR, file)
    );
    const commandName = file.replace(/\.md$/, '');
    summary.installed.push(`command: /${commandName}`);
  }

  // --- Install settings.json ---
  const settingsDest = path.join(CLAUDE_DIR, 'settings.json');
  if (await fileExists(settingsDest)) {
    summary.skipped.push('settings.json (already exists)');
  } else {
    await fs.copyFile(path.join(PACKAGE_ROOT, 'settings.json'), settingsDest);
    summary.installed.push('settings.json');
  }

  // --- Set up .playbook/ source for auto-updates ---
  // Copy individual files
  for (const file of PLAYBOOK_SOURCE_FILES) {
    const src = path.join(PACKAGE_ROOT, file);
    if (await fileExists(src)) {
      await fs.copyFile(src, path.join(PLAYBOOK_DIR, file));
    }
  }

  // Copy commands/ directory into .playbook/commands/
  const playbookCommandsDir = path.join(PLAYBOOK_DIR, 'commands');
  await fs.mkdir(playbookCommandsDir, { recursive: true });
  for (const file of commandFiles) {
    if (!file.endsWith('.md')) continue;
    await fs.copyFile(
      path.join(commandsSource, file),
      path.join(playbookCommandsDir, file)
    );
  }

  // --- Write version ---
  const versionFile = path.join(PACKAGE_ROOT, 'VERSION');
  let version = '1.0.0';
  if (await fileExists(versionFile)) {
    version = (await fs.readFile(versionFile, 'utf-8')).trim();
  }
  await fs.writeFile(path.join(CLAUDE_DIR, '.playbook-version'), version + '\n');

  // --- Print summary ---
  console.log('');
  if (summary.installed.length > 0) {
    console.log('Installed:');
    for (const item of summary.installed) {
      console.log(`  + ${item}`);
    }
  }
  if (summary.skipped.length > 0) {
    console.log('Skipped:');
    for (const item of summary.skipped) {
      console.log(`  - ${item}`);
    }
  }

  console.log(`\nVersion ${version} installed.`);
  console.log('');
  console.log('Next steps:');
  console.log('  1. Open ~/.claude/CLAUDE.md and replace "you" with your name');
  console.log('  2. Create a WORK_LOG.md in your project root');
  console.log('  3. Run /start in Claude Code');
  console.log('');
  console.log('Playbook will automatically check for updates when you run /start.');
}

async function fileExists(filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
}
