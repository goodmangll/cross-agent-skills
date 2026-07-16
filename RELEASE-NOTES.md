# Cross-Agent Skills Release Notes

## v1.0.0 (2026-07-16)

### Initial Release

This is the first official release of Cross-Agent Skills, a framework for creating skill repositories that work across multiple AI coding agents.

#### Features

- **Cross-platform skill architecture** - Three-layer separation (Skills, Adapters, Packaging)
- **Multi-platform support** - Pi, Claude Code, Codex, and Cursor adapters
- **Platform-agnostic skills** - Skills that work on any platform through adapters
- **Standard format** - Follows Agent Skills standard (agentskills.io)
- **Comprehensive documentation** - Installation guides, troubleshooting, and examples

#### Components

**Core Skill**
- `cross-agent-skills` - Guide for creating cross-platform skill repositories

**Platform Adapters**
- Pi adapter with tool mapping and skill discovery
- Claude Code adapter with plugin marketplace integration
- Codex adapter with plugin system support
- Cursor adapter with Agent mode integration

**Development Tools**
- Cross-platform compatibility testing framework
- Version management with drift detection
- Automated test runner for all platforms

#### Architecture

```
cross-agent-skills/
├── skills/                    # Platform-agnostic skills
├── adapters/                  # Platform-specific adapters
│   ├── pi/                    # Pi adapter
│   ├── claude/                # Claude Code adapter
│   ├── codex/                 # Codex adapter
│   └── cursor/                # Cursor adapter
├── tests/                     # Test framework
├── scripts/                   # Maintenance scripts
└── package.json               # npm configuration
```

#### Installation

**Pi:**
```bash
pi install git:github.com/goodmangll/cross-agent-skills
```

**Claude Code:**
```bash
/plugin install cross-agent-skills@github:goodmangll/cross-agent-skills
```

**Codex:**
```bash
/plugins install https://github.com/goodmangll/cross-agent-skills
```

**Cursor:**
```bash
/add-plugin cross-agent-skills
```

#### Testing

```bash
# Run all tests
npm test

# Run specific platform tests
./scripts/run-tests.sh --pi
./scripts/run-tests.sh --claude
./scripts/run-tests.sh --codex
./scripts/run-tests.sh --cursor
./scripts/run-tests.sh --cross
```

#### Version Management

```bash
# Check version sync
./scripts/bump-version.sh --check

# Update versions
./scripts/bump-version.sh 1.1.0

# Audit for missed files
./scripts/bump-version.sh --audit
```

### What's Next

- [ ] Publish to npm for easier installation
- [ ] Submit to platform marketplaces
- [ ] Add more platform adapters (Kimi, Gemini, etc.)
- [ ] Create skill discovery and search tools
- [ ] Add skill versioning and dependency management

### Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

### Support

- [GitHub Issues](https://github.com/goodmangll/cross-agent-skills/issues)
- [Discussions](https://github.com/goodmangll/cross-agent-skills/discussions)