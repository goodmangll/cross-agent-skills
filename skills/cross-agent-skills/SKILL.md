---
name: cross-agent-skills
description: Use when creating skill repositories that work across multiple AI coding agents (Pi, Claude Code, Codex, Cursor, etc.)
---

# Cross-Agent Skills

## Overview

**Build skill repositories that work across any AI coding agent.** Separate platform-agnostic skills from platform-specific adapters, then package for multi-platform distribution.

**Core principle:** Skills are methodology; adapters are integration. Keep them separate.

## When to Use

- Creating reusable skill libraries for multiple AI agents
- Adapting existing skills to work on new platforms
- Building skill marketplaces or package repositories
- Standardizing skill formats across different agent ecosystems

**When NOT to use:**
- Single-platform skills (use platform-native format)
- One-off project-specific conventions (use AGENTS.md/CLAUDE.md)
- Mechanical constraints (automate, don't document)

## Architecture: Three-Layer Separation

```
1. Skills Layer (platform-agnostic)
   ├── SKILL.md files
   ├── Methodologies & patterns
   └── Reusable techniques

2. Adapter Layer (platform-specific)
   ├── Pi: .pi/extensions/adapter.ts
   ├── Claude Code: .claude-plugin/plugin.json
   ├── Codex: .codex-plugin/plugin.json
   └── Cursor: .cursor-plugin/config.json

3. Packaging Layer
   ├── package.json (npm config)
   ├── Installation guides
   └── Version management
```

## Quick Reference

| Component | Location | Purpose |
|-----------|----------|---------|
| Skills | `skills/*/SKILL.md` | Platform-agnostic instructions |
| Pi adapter | `.pi/extensions/*.ts` | Pi extension API integration |
| Claude adapter | `.claude-plugin/plugin.json` | Claude plugin marketplace |
| Codex adapter | `.codex-plugin/plugin.json` | Codex plugin system |
| Package config | `package.json` | npm distribution |

## Implementation

### 1. Create Platform-Agnostic Skills

Follow Agent Skills standard ([agentskills.io](https://agentskills.io)):

```markdown
---
name: skill-name
description: Use when [specific triggering conditions]
---

# Skill Name

## Overview
Core principle (1-2 sentences)

## When to Use
Symptoms and use cases

## Core Pattern
Code examples or flowcharts

## Quick Reference
Tables or lists

## Implementation
Step-by-step guide

## Common Mistakes
Errors and fixes
```

### 2. Create Platform Adapters

#### Pi Adapter Template

```typescript
// .pi/extensions/adapter.ts
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function skillAdapter(pi: ExtensionAPI) {
  // Register skill directory
  pi.on("resources_discover", async () => ({
    skillPaths: ["/path/to/skills"]
  }));

  // Optional: Inject bootstrap message
  pi.on("context", async (event) => {
    // Add skill usage guidance
  });
}
```

#### Claude Code Adapter Template

```json
// .claude-plugin/plugin.json
{
  "name": "your-skills",
  "description": "Cross-platform skills collection",
  "version": "1.0.0",
  "skills": "./skills/"
}
```

#### Codex Adapter Template

```json
// .codex-plugin/plugin.json
{
  "name": "your-skills",
  "version": "1.0.0",
  "description": "Cross-platform skills",
  "skills": "./skills/",
  "interface": {
    "displayName": "Your Skills",
    "category": "Developer Tools"
  }
}
```

### 3. Package Structure

```
your-skills-repo/
├── skills/                    # Platform-agnostic skills
│   ├── skill-a/
│   │   └── SKILL.md
│   └── skill-b/
│       └── SKILL.md
├── adapters/                  # Platform adapters
│   ├── pi/
│   │   └── extensions/
│   │       └── adapter.ts
│   ├── claude/
│   │   └── plugin.json
│   └── codex/
│       └── plugin.json
├── package.json               # npm config
├── README.md                  # Installation guide
└── tests/                     # Cross-platform tests
```

### 4. Package.json Configuration

```json
{
  "name": "cross-agent-skills",
  "keywords": ["pi-package", "claude-plugin", "codex-plugin"],
  "version": "1.0.0",
  "pi": {
    "extensions": ["adapters/pi/extensions"],
    "skills": ["skills"]
  },
  "claude": {
    "plugin": "adapters/claude/plugin.json"
  },
  "codex": {
    "plugin": "adapters/codex/plugin.json"
  }
}
```

## Tool Mapping

Different platforms use different tool names:

| Action | Pi | Claude Code | Codex |
|--------|----|-------------|-------|
| Read file | `read` | `Read` | `read_file` |
| Write file | `write` | `Write` | `write_file` |
| Edit file | `edit` | `Edit` | `edit_file` |
| Run command | `bash` | `Bash` | `execute_command` |
| Search files | `grep` | `Grep` | `search_files` |

**Solution:** Create mapping layer in adapters:

```typescript
const toolMapping = {
  pi: { read: 'read', write: 'write', execute: 'bash' },
  claude: { read: 'Read', write: 'Write', execute: 'Bash' },
  codex: { read: 'read_file', write: 'write_file', execute: 'execute_command' }
};
```

## Installation Guides

### For Users

```bash
# Pi
pi install git:github.com/your-org/your-skills

# Claude Code
/plugin install your-skills@your-marketplace

# Codex
/plugins install your-skills

# Cursor
/add-plugin your-skills
```

### For Developers

```bash
# Clone repository
git clone https://github.com/your-org/your-skills.git

# Install dependencies
npm install

# Test on Pi
pi -e /path/to/your-skills

# Test on Claude Code
# Use Claude's plugin development mode
```

## Testing Cross-Platform Compatibility

### 1. Skill Behavior Tests

Verify skills work the same across platforms:

```javascript
// tests/cross-platform-test.js
const platforms = ['pi', 'claude', 'codex'];

async function testSkill(skillName, platform) {
  // Load skill
  // Simulate platform environment
  // Verify behavior matches
  // Check tool mappings work
}
```

### 2. Adapter Integration Tests

Test each adapter separately:

```bash
# Test Pi adapter
pi -e ./adapters/pi

# Test Claude adapter
# Use Claude's plugin testing framework

# Test Codex adapter
# Use Codex's plugin testing tools
```

### 3. Package Installation Tests

Verify installation works on each platform:

```bash
# Test npm installation
npm pack
pi install ./your-skills-1.0.0.tgz

# Test git installation
pi install git:github.com/your-org/your-skills
```

## Common Pitfalls

### 1. Platform-Specific Code in Skills

**Problem:** Skills contain platform-specific tool calls.

**Solution:** Use abstract tool names in skills, map in adapters.

### 2. Inconsistent Skill Discovery

**Problem:** Different platforms load skills differently.

**Solution:** Follow standard directory structure, test discovery on each platform.

### 3. Missing Tool Mappings

**Problem:** Skills reference tools that don't exist on some platforms.

**Solution:** Create comprehensive tool mapping, handle missing tools gracefully.

### 4. Version Mismatch

**Problem:** Different platforms expect different package formats.

**Solution:** Use semantic versioning, test installation on all target platforms.

## Real-World Example: Superpowers

Superpowers implements this pattern successfully:

```bash
# Same skills work on:
pi install git:github.com/obra/superpowers      # Pi
/plugin install superpowers@claude-plugins      # Claude Code
/plugins install superpowers                     # Codex
/add-plugin superpowers                          # Cursor
```

**Key success factors:**
1. Platform-agnostic skill content
2. Separate adapter files for each platform
3. Comprehensive tool mapping
4. Multi-platform installation guides
5. Cross-platform testing

## Quick Start Checklist

- [ ] Create `skills/` directory with SKILL.md files
- [ ] Create adapter for Pi (`.pi/extensions/adapter.ts`)
- [ ] Create adapter for Claude Code (`.claude-plugin/plugin.json`)
- [ ] Create adapter for Codex (`.codex-plugin/plugin.json`)
- [ ] Add `package.json` with multi-platform keywords
- [ ] Write installation guide for each platform
- [ ] Test skills on each target platform
- [ ] Create cross-platform tests

## Common Mistakes

### ❌ Mixing Platform-Specific Code
Putting Pi API calls in SKILL.md files.

### ❌ Single Platform Focus
Only creating Pi adapter when building for multiple platforms.

### ❌ Missing Tool Mappings
Not handling different tool names across platforms.

### ❌ No Installation Guide
Forgetting to document how to install on each platform.

### ❌ Skipping Cross-Platform Testing
Assuming skills work everywhere without testing.

## Next Steps

1. **Start with one skill** - Create a simple skill, then add adapters
2. **Test early** - Verify on each platform before adding more skills
3. **Document patterns** - Record what works across platforms
4. **Build incrementally** - Add platforms one at a time
5. **Share learnings** - Contribute back to cross-platform skill community

## References

- [Agent Skills Standard](https://agentskills.io)
- [Superpowers Repository](https://github.com/obra/superpowers)
- [Pi Documentation](https://pi.dev)
- [Claude Code Plugins](https://claude.com/plugins)
- [Codex Plugins](https://github.com/openai/plugins)