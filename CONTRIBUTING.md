# Contributing to Cross-Agent Skills

Thank you for your interest in contributing to Cross-Agent Skills! This document provides guidelines and information for contributors.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates.

When creating a bug report, please include:

- **Clear and descriptive title**
- **Exact steps to reproduce the problem**
- **Expected behavior**
- **Actual behavior**
- **Platform and version information**
- **Any relevant logs or error messages**

### Suggesting Enhancements

Enhancement suggestions are welcome! Please provide:

- **Clear description of the enhancement**
- **Use case and benefits**
- **Possible implementation approach**
- **Platform compatibility considerations**

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes**
4. **Test on multiple platforms** (Pi, Claude Code, Codex, Cursor)
5. **Commit your changes** (`git commit -m 'Add amazing feature'`)
6. **Push to the branch** (`git push origin feature/amazing-feature`)
7. **Open a Pull Request**

## Development Guidelines

### Code Style

- Follow the existing code style
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally

Example:
```
Add new skill for code review

- Implement cross-platform code review skill
- Add adapters for Pi, Claude Code, and Codex
- Include testing examples and documentation

Fixes #123
```

### Testing

- Test your changes on all target platforms when possible
- Include test cases for new functionality
- Ensure existing tests pass
- Document any platform-specific behaviors

### Documentation

- Update README.md if adding new features
- Add or update skill documentation as needed
- Include examples for new functionality
- Keep installation guides current

## Skill Development

### Creating New Skills

1. **Follow the Agent Skills standard** ([agentskills.io](https://agentskills.io))
2. **Use platform-agnostic language** in SKILL.md files
3. **Include clear triggering conditions** in the description
4. **Provide practical examples**
5. **Test on multiple platforms**

### Skill Structure

```
skills/
└── skill-name/
    ├── SKILL.md           # Main skill document
    ├── examples/          # Optional examples
    └── tools/             # Optional reusable tools
```

### Skill Quality Checklist

- [ ] Follows Agent Skills standard
- [ ] Platform-agnostic language
- [ ] Clear triggering conditions
- [ ] Practical examples
- [ ] Tested on multiple platforms
- [ ] Documentation complete

## Adapter Development

### Creating New Adapters

1. **Create platform directory** in `adapters/`
2. **Follow platform-specific guidelines**
3. **Map abstract tools to platform tools**
4. **Test skill loading on the platform**
5. **Document installation instructions**

### Adapter Structure

```
adapters/
└── platform-name/
    ├── plugin.json        # Plugin configuration
    ├── extensions/        # Optional extensions
    └── README.md          # Platform-specific docs
```

## Review Process

1. **Initial review** - Check for basic requirements
2. **Platform testing** - Verify on target platforms
3. **Code review** - Review code quality and style
4. **Documentation review** - Ensure docs are clear
5. **Merge** - Once approved, merge into main branch

## Community

- **GitHub Issues** - For bug reports and feature requests
- **Discussions** - For questions and general discussion
- **Discord** - For real-time communication (if available)

## Code of Conduct

Please be respectful and inclusive in all interactions. We are committed to providing a welcoming and constructive community for everyone.

## Questions?

If you have questions about contributing, please open an issue or reach out to the maintainers.

Thank you for contributing to Cross-Agent Skills!