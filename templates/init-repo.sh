#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <repo-name> [description]" >&2
  exit 1
fi

repo_name="$1"
description="${2:-Reusable AI agent skills}"
if [[ "$repo_name" = /* ]]; then
  root="$repo_name"
else
  root="$(pwd)/$repo_name"
fi

if [[ -e "$root" ]]; then
  echo "error: $root already exists" >&2
  exit 1
fi

package_name="$(basename "$root")"
if [[ ! "$package_name" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "error: repository directory name must use lowercase letters, numbers, and hyphens" >&2
  exit 1
fi

mkdir -p "$root/skills/example-skill" \
  "$root/.claude-plugin" \
  "$root/.codex-plugin" \
  "$root/tests"

cat > "$root/package.json" <<EOF
{
  "name": "$package_name",
  "version": "0.1.0",
  "description": "$description",
  "license": "MIT",
  "keywords": ["pi-package", "agent-skill"],
  "pi": {
    "skills": ["skills"]
  },
  "scripts": {
    "test": "node --test tests/*.mjs"
  }
}
EOF

cat > "$root/.claude-plugin/plugin.json" <<EOF
{
  "name": "$package_name",
  "description": "$description",
  "version": "0.1.0",
  "author": {
    "name": "your-name"
  }
}
EOF

cat > "$root/.claude-plugin/marketplace.json" <<EOF
{
  "name": "$package_name",
  "description": "$description",
  "owner": {
    "name": "your-name"
  },
  "plugins": [
    { "name": "$package_name", "source": "./" }
  ]
}
EOF

cat > "$root/.codex-plugin/plugin.json" <<EOF
{
  "name": "$package_name",
  "version": "0.1.0",
  "description": "$description",
  "skills": "./skills"
}
EOF

cat > "$root/skills/example-skill/SKILL.md" <<'EOF'
---
name: example-skill
description: Use when testing portable skill discovery across supported agents.
---

# Example Skill

Replace this example with a reusable workflow.
EOF

cat > "$root/README.md" <<EOF
# $package_name

$description

## Support Matrix

| Platform | Status | Install or validation |
|---|---|---|
| Pi | Supported | \`pi install git:github.com/<owner>/$package_name\` |
| Claude Code | Supported | \`claude plugin marketplace add <owner>/$package_name\`, then \`claude plugin install $package_name@$package_name\` |
| Codex | Manifest included | Validate the current marketplace or plugin-browser installation flow before publishing an install command. |
| Cursor | Not configured | Add only after its official plugin format and distribution flow are verified. |

## Layout

- \`skills/\` is the canonical portable source.
- \`.claude-plugin/\` and \`.codex-plugin/\` contain platform discovery metadata.
- User credentials and generated data do not belong in this repository.
EOF

cat > "$root/tests/manifest-layout.mjs" <<'EOF'
import assert from 'node:assert/strict';
import { existsSync } from 'node:fs';
import { resolve } from 'node:path';
import test from 'node:test';

for (const path of [
  'skills/example-skill/SKILL.md',
  '.claude-plugin/plugin.json',
  '.claude-plugin/marketplace.json',
  '.codex-plugin/plugin.json',
]) {
  test(`${path} exists`, () => assert.ok(existsSync(resolve(path))));
}
EOF

cat > "$root/.gitignore" <<'EOF'
node_modules/
*.tgz
__pycache__/
*.pyc
EOF

git -C "$root" init -q
git -C "$root" add .
git -C "$root" commit -qm "Initial skill repository"
printf 'Created %s\n' "$root"
