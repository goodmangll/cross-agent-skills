import assert from 'node:assert/strict';
import { existsSync } from 'node:fs';
import { readFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');

async function readJson(relativePath) {
  return JSON.parse(await readFile(resolve(root, relativePath), 'utf8'));
}

test('ships platform manifests at each platform discovery path', () => {
  for (const relativePath of [
    '.claude-plugin/plugin.json',
    '.claude-plugin/marketplace.json',
    '.codex-plugin/plugin.json',
  ]) {
    assert.ok(existsSync(resolve(root, relativePath)), `missing ${relativePath}`);
  }
  assert.ok(!existsSync(resolve(root, 'adapters')), 'obsolete generic adapters directory must not exist');
});

test('Claude marketplace points to the repository-root plugin', async () => {
  const plugin = await readJson('.claude-plugin/plugin.json');
  const marketplace = await readJson('.claude-plugin/marketplace.json');
  assert.equal(plugin.name, 'cross-agent-skills');
  assert.equal(plugin.version, '1.1.0');
  assert.equal(marketplace.name, 'cross-agent-skills');
  assert.deepEqual(marketplace.plugins, [{
    name: 'cross-agent-skills',
    source: './',
  }]);
});

test('Codex manifest targets the canonical skills directory', async () => {
  const plugin = await readJson('.codex-plugin/plugin.json');
  assert.equal(plugin.name, 'cross-agent-skills');
  assert.equal(plugin.version, '1.1.0');
  assert.equal(plugin.skills, './skills');
});

test('README publishes only verified installation commands', async () => {
  const readme = await readFile(resolve(root, 'README.md'), 'utf8');
  assert.match(readme, /claude plugin marketplace add goodmangll\/cross-agent-skills/);
  assert.doesNotMatch(readme, /\/plugin install .*@github:/);
  assert.doesNotMatch(readme, /\/plugins install https:\/\//);
  assert.doesNotMatch(readme, /\/add-plugin/);
  assert.match(readme, /\| Cursor \| Not configured \|/);
});

test('version manifest tracks package and platform manifests', async () => {
  const config = await readJson('.version-bump.json');
  assert.deepEqual(config.files, [
    { path: 'package.json', field: 'version' },
    { path: '.claude-plugin/plugin.json', field: 'version' },
    { path: '.codex-plugin/plugin.json', field: 'version' },
  ]);
});
