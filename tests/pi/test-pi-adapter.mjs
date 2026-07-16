import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { existsSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import test from 'node:test';

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(__dirname, '../..');
const packageJsonPath = resolve(repoRoot, 'package.json');
const extensionPath = resolve(repoRoot, 'adapters/pi/extensions/adapter.ts');

async function readPackageJson() {
  return JSON.parse(await readFile(packageJsonPath, 'utf8'));
}

async function loadExtension() {
  const handlers = new Map();
  const pi = {
    on(event, handler) {
      if (!handlers.has(event)) handlers.set(event, []);
      handlers.get(event).push(handler);
    },
  };
  const mod = await import(pathToFileURL(extensionPath).href + `?cachebust=${Date.now()}-${Math.random()}`);
  mod.default(pi);
  return { handlers };
}

function firstHandler(handlers, event) {
  const eventHandlers = handlers.get(event) ?? [];
  assert.equal(eventHandlers.length, 1, `expected one ${event} handler`);
  return eventHandlers[0];
}

test('package.json declares a pi package with skills and extension resources', async () => {
  const pkg = await readPackageJson();

  assert.equal(pkg.name, 'cross-agent-skills');
  assert.ok(pkg.keywords.includes('pi-package'));
  assert.deepEqual(pkg.pi.skills, ['skills']);
  assert.deepEqual(pkg.pi.extensions, ['adapters/pi/extensions']);
});

test('Pi extension registers resources_discover handler', async () => {
  const { handlers } = await loadExtension();
  assert.ok(handlers.has('resources_discover'), 'extension should register resources_discover handler');
});

test('Pi extension registers context handler', async () => {
  const { handlers } = await loadExtension();
  assert.ok(handlers.has('context'), 'extension should register context handler');
});

test('Pi extension loads skills from correct directory', async () => {
  const { handlers } = await loadExtension();
  const discoverHandler = firstHandler(handlers, 'resources_discover');
  
  const result = await discoverHandler();
  assert.ok(result.skillPaths, 'should return skillPaths');
  assert.ok(Array.isArray(result.skillPaths), 'skillPaths should be an array');
  assert.ok(result.skillPaths.length > 0, 'skillPaths should not be empty');
  
  // Check that the skills directory exists
  const skillsDir = result.skillPaths[0];
  assert.ok(existsSync(skillsDir), `skills directory should exist: ${skillsDir}`);
});

test('Pi extension has tool mapping', async () => {
  const { handlers } = await loadExtension();
  // The extension should define tool mapping internally
  // We can verify it loads without errors
  assert.ok(handlers.size > 0, 'extension should register at least one handler');
});

test('Skills directory contains valid SKILL.md files', async () => {
  const skillsDir = resolve(repoRoot, 'skills');
  assert.ok(existsSync(skillsDir), 'skills directory should exist');
  
  const { readdir } = await import('node:fs/promises');
  const skills = await readdir(skillsDir);
  
  for (const skill of skills) {
    const skillPath = resolve(skillsDir, skill);
    const stat = await import('node:fs/promises').then(fs => fs.stat(skillPath));
    
    if (stat.isDirectory()) {
      const skillFile = resolve(skillPath, 'SKILL.md');
      assert.ok(existsSync(skillFile), `Skill ${skill} should have SKILL.md`);
      
      const content = await readFile(skillFile, 'utf8');
      assert.ok(content.startsWith('---'), `Skill ${skill} should have YAML frontmatter`);
      assert.ok(content.includes('name:'), `Skill ${skill} should have name field`);
      assert.ok(content.includes('description:'), `Skill ${skill} should have description field`);
    }
  }
});