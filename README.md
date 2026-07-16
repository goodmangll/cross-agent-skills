# Cross-Agent Skills

[![npm version](https://img.shields.io/npm/v/cross-agent-skills.svg)](https://www.npmjs.com/package/cross-agent-skills)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Cross-platform skills that work across multiple AI coding agents. Write skills once, use them everywhere.

## Features

- 🎯 **Platform-Agnostic Skills** - Same skills work on Pi, Claude Code, Codex, Cursor, and more
- 🔌 **Separate Adapters** - Platform-specific integration code isolated from skills
- 📦 **Standard Structure** - Follows [Agent Skills standard](https://agentskills.io)
- 🚀 **Easy Installation** - Multiple installation methods for different platforms

## Architecture

```
cross-agent-skills/
├── skills/                    # Platform-agnostic skills
│   └── cross-agent-skills/
│       └── SKILL.md           # This skill itself
├── adapters/                  # Platform-specific adapters
│   ├── pi/extensions/         # Pi adapter
│   ├── claude/                # Claude Code adapter
│   ├── codex/                 # Codex adapter
│   └── cursor/                # Cursor adapter
├── package.json               # npm configuration
└── README.md                  # This file
```

## Installation

### Pi

**Prerequisites:**
- Pi coding agent installed (`npm install -g @earendil-works/pi-coding-agent`)
- API key configured (Anthropic, OpenAI, etc.)

**Installation:**

```bash
# Install from GitHub (recommended)
pi install git:github.com/goodmangll/cross-agent-skills

# Or install from npm (when published)
pi install npm:cross-agent-skills

# Or install locally for testing
pi install /path/to/cross-agent-skills
```

**Verify installation:**
```bash
pi list  # Should show cross-agent-skills
pi "Use the cross-agent-skills skill"  # Test skill loading
```

**Uninstall:**
```bash
pi remove git:github.com/goodmangll/cross-agent-skills
```

### Claude Code

**Prerequisites:**
- Claude Code installed and configured
- Plugin marketplace access (if using marketplace)

**Installation:**

```bash
# Install from official marketplace (when available)
/plugin install cross-agent-skills@claude-plugins-official

# Or install from custom marketplace
/plugin marketplace add goodmangll/cross-agent-skills-marketplace
/plugin install cross-agent-skills@cross-agent-skills-marketplace

# Or install directly from GitHub
/plugin install cross-agent-skills@github:goodmangll/cross-agent-skills
```

**Verify installation:**
```bash
# In Claude Code, ask:
"List available skills"
# Should show cross-agent-skills
```

**Uninstall:**
```bash
/plugin uninstall cross-agent-skills
```

### Codex

**Prerequisites:**
- Codex CLI or Codex App installed
- Plugin system enabled

**Installation:**

```bash
# Open plugin search
/plugins

# Search for "cross-agent-skills" and select Install Plugin

# Or install directly from GitHub
/plugins install https://github.com/goodmangll/cross-agent-skills
```

**Verify installation:**
```bash
# In Codex, ask:
"Show installed plugins"
# Should show cross-agent-skills
```

**Uninstall:**
```bash
/plugins uninstall cross-agent-skills
```

### Cursor

**Prerequisites:**
- Cursor installed with Agent mode enabled
- Plugin marketplace access

**Installation:**

```bash
# Open Cursor Agent chat
/add-plugin cross-agent-skills

# Or search in plugin marketplace:
# 1. Open Cursor Settings
# 2. Go to Plugins
# 3. Search for "cross-agent-skills"
# 4. Click Install
```

**Verify installation:**
```bash
# In Cursor Agent, ask:
"List available skills"
# Should show cross-agent-skills
```

**Uninstall:**
```bash
/remove-plugin cross-agent-skills
```

## Usage

Once installed, skills are automatically available:

```bash
# On Pi
pi "Use the cross-agent-skills skill to create a new skill repository"

# On Claude Code
# Skills are available in conversations

# On Codex
# Skills are available in conversations

# On Cursor
# Skills are available in Agent mode
```

## Creating Your Own Cross-Platform Skills

This repository includes a skill that teaches you how to create cross-platform skill repositories. The skill is located at `skills/cross-agent-skills/SKILL.md`.

### Quick Start

1. **Clone this repository**
2. **Read the skill**: `skills/cross-agent-skills/SKILL.md`
3. **Follow the architecture**: Three-layer separation (Skills, Adapters, Packaging)
4. **Test on multiple platforms**: Verify your skills work everywhere

### Key Principles

1. **Skills are platform-agnostic** - No platform-specific code in SKILL.md files
2. **Adapters handle integration** - Platform-specific code lives in adapters
3. **Tool mapping** - Abstract tool names mapped to platform-specific tools
4. **Standard format** - Follow Agent Skills standard for maximum compatibility

## Development

### Adding New Skills

1. Create directory in `skills/`
2. Add `SKILL.md` with proper frontmatter
3. Test on all target platforms
4. Update installation guides

### Adding New Adapters

1. Create platform directory in `adapters/`
2. Add platform-specific configuration
3. Test skill loading on that platform
4. Update README with installation instructions

### Testing

```bash
# Test on Pi
pi -e /path/to/cross-agent-skills

# Test on Claude Code
# Use Claude's plugin development mode

# Test on Codex
# Use Codex's plugin testing tools
```

## Tool Mapping

Different platforms use different tool names. Adapters handle the mapping:

| Abstract Tool | Pi | Claude Code | Codex | Cursor |
|---------------|----|-------------|-------|--------|
| `read` | `read` | `Read` | `read_file` | `read_file` |
| `write` | `write` | `Write` | `write_file` | `write_file` |
| `edit` | `edit` | `Edit` | `edit_file` | `edit_file` |
| `execute` | `bash` | `Bash` | `execute_command` | `run_command` |
| `search` | `grep` | `Grep` | `search_files` | `search_files` |
| `find` | `find` | `Glob` | `find_files` | `find_files` |

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Agent Skills Standard](https://agentskills.io) - The standard this project follows
- [Superpowers](https://github.com/obra/superpowers) - Inspiration for cross-platform skill architecture
- [Pi](https://pi.dev) - Primary development platform
- [Claude Code](https://claude.ai/code) - Anthropic's coding assistant
- [Codex](https://github.com/openai/codex) - OpenAI's coding assistant
- [Cursor](https://cursor.sh) - AI-first code editor

## Support

- [GitHub Issues](https://github.com/goodmangll/cross-agent-skills/issues)
- [Discussions](https://github.com/goodmangll/cross-agent-skills/discussions)

## Roadmap

- [ ] Add more platform adapters (Kimi, Gemini, etc.)
- [ ] Create skill testing framework
- [ ] Build skill marketplace integration
- [ ] Add skill versioning and dependency management
- [ ] Create skill discovery and search tools