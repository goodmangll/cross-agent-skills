#!/usr/bin/env bash
#
# init-repo.sh — Initialize a new cross-agent-skills repository
#
# Usage:
#   init-repo.sh <repo-name> [description]
#
# Example:
#   init-repo.sh my-skills "My cross-platform skills collection"
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_NAME="${1:-}"
DESCRIPTION="${2:-Cross-platform skills collection}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Validate inputs
if [[ -z "$REPO_NAME" ]]; then
  echo "Usage: $0 <repo-name> [description]"
  echo ""
  echo "Example:"
  echo "  $0 my-skills \"My cross-platform skills collection\""
  exit 1
fi

# Check if directory exists
if [[ -d "$REPO_NAME" ]]; then
  log_error "Directory '$REPO_NAME' already exists"
  exit 1
fi

log_info "Creating repository: $REPO_NAME"

# Create directory structure
mkdir -p "$REPO_NAME"/{skills,adapters/{pi/extensions,claude,codex,cursor},tests,scripts,docs,config}

# Copy template files
log_info "Copying template files..."

# Copy scripts
cp "$SCRIPT_DIR/scripts/bump-version.sh" "$REPO_NAME/scripts/"
cp "$SCRIPT_DIR/scripts/run-tests.sh" "$REPO_NAME/scripts/"
cp "$SCRIPT_DIR/scripts/update-skill.sh" "$REPO_NAME/scripts/"
chmod +x "$REPO_NAME/scripts/"*.sh

# Copy config files
cp "$SCRIPT_DIR/config/.version-bump.json" "$REPO_NAME/"
cp "$SCRIPT_DIR/config/.editorconfig" "$REPO_NAME/"
cp "$SCRIPT_DIR/config/.gitignore" "$REPO_NAME/"

# Copy adapter templates
cp "$SCRIPT_DIR/adapters/pi/extensions/adapter.ts" "$REPO_NAME/adapters/pi/extensions/"
cp "$SCRIPT_DIR/adapters/claude/plugin.json" "$REPO_NAME/adapters/claude/"
cp "$SCRIPT_DIR/adapters/codex/plugin.json" "$REPO_NAME/adapters/codex/"
cp "$SCRIPT_DIR/adapters/cursor/plugin.json" "$REPO_NAME/adapters/cursor/"

# Create package.json
cat > "$REPO_NAME/package.json" << EOF
{
  "name": "$REPO_NAME",
  "version": "1.0.0",
  "description": "$DESCRIPTION",
  "keywords": [
    "pi-package",
    "claude-plugin",
    "codex-plugin",
    "cursor-plugin",
    "cross-platform",
    "skills",
    "multi-agent"
  ],
  "author": "",
  "license": "MIT",
  "pi": {
    "extensions": ["adapters/pi/extensions"],
    "skills": ["skills"]
  },
  "scripts": {
    "test": "./scripts/run-tests.sh",
    "test:pi": "./scripts/run-tests.sh --pi",
    "test:claude": "./scripts/run-tests.sh --claude",
    "test:codex": "./scripts/run-tests.sh --codex",
    "test:cursor": "./scripts/run-tests.sh --cursor",
    "test:cross": "./scripts/run-tests.sh --cross",
    "version:check": "./scripts/bump-version.sh --check",
    "version:audit": "./scripts/bump-version.sh --audit",
    "skill:update": "./scripts/update-skill.sh",
    "lint": "echo \"No lint configured\" && exit 0",
    "validate": "npm test && npm run lint"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
EOF

# Create README.md
cat > "$REPO_NAME/README.md" << EOF
# $REPO_NAME

$DESCRIPTION

## Installation

### Pi

\`\`\`bash
pi install git:github.com/YOUR_USERNAME/$REPO_NAME
\`\`\`

### Claude Code

\`\`\`bash
/plugin install $REPO_NAME@github:YOUR_USERNAME/$REPO_NAME
\`\`\`

### Codex

\`\`\`bash
/plugins install https://github.com/YOUR_USERNAME/$REPO_NAME
\`\`\`

### Cursor

\`\`\`bash
/add-plugin $REPO_NAME
\`\`\`

## Usage

Once installed, skills are automatically available.

## Development

\`\`\`bash
# Run tests
npm test

# Update skill version
./scripts/update-skill.sh skill-name patch "Fix bug"

# Check version sync
./scripts/bump-version.sh --check
\`\`\`

## License

MIT
EOF

# Create CONTRIBUTING.md
cat > "$REPO_NAME/CONTRIBUTING.md" << EOF
# Contributing to $REPO_NAME

Thank you for your interest in contributing!

## Pull Request Requirements

1. Fill out PR template completely
2. Test on multiple platforms
3. Disclose AI agent (if used)
4. Target \`dev\` branch

## Skill Updates

\`\`\`bash
# Update skill with version bump
./scripts/update-skill.sh skill-name patch "Fix bug"
\`\`\`

## Testing

\`\`\`bash
# Run all tests
npm test

# Run specific platform tests
npm run test:pi
\`\`\`
EOF

# Create RELEASE-NOTES.md
cat > "$REPO_NAME/RELEASE-NOTES.md" << EOF
# $REPO_NAME Release Notes

## v1.0.0 ($(date +%Y-%m-%d))

### Initial Release

- Initial release with cross-platform skill support
EOF

# Create example skill
cat > "$REPO_NAME/skills/example-skill/SKILL.md" << EOF
---
name: example-skill
description: Use when testing cross-platform skill compatibility
version: 1.0.0
last_updated: $(date +%Y-%m-%d)
---

# Example Skill

## Overview

This is an example skill demonstrating cross-platform skill structure.

## When to Use

- Testing skill loading on different platforms
- Learning cross-platform skill format

## Implementation

1. Step one
2. Step two
3. Step three

## Common Mistakes

- Mistake 1
- Mistake 2
EOF

# Initialize git repository
log_info "Initializing git repository..."
cd "$REPO_NAME"
git init
git add .
git commit -m "Initial commit: $REPO_NAME

- Add cross-platform skill structure
- Add platform adapters (Pi, Claude, Codex, Cursor)
- Add maintenance scripts
- Add example skill"

log_info "Repository created successfully!"
log_info ""
log_info "Next steps:"
log_info "  1. cd $REPO_NAME"
log_info "  2. Edit package.json with your info"
log_info "  3. Add your skills to skills/ directory"
log_info "  4. Create remote repository:"
log_info "     git remote add origin git@github.com:YOUR_USERNAME/$REPO_NAME.git"
log_info "     git push -u origin main"
log_info ""
log_info "For more information, see docs/skill-maintenance.md"