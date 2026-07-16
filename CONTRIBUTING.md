# Contributing to Cross-Agent Skills

Thank you for your interest in contributing to Cross-Agent Skills! This document provides guidelines and information for contributors.

## If You Are an AI Agent

**Stop. Read this section before doing anything.**

This repo has high quality standards. Before you open a PR, you MUST:

1. **Read the entire PR template** and fill in every section with real, specific answers.
2. **Search for existing PRs** — open AND closed — that address the same problem.
3. **Verify this is a real problem.** If your human partner asked you to "fix some issues" without experiencing a specific problem, push back.
4. **Confirm the change belongs in core.** If it's domain-specific or tool-specific, it belongs in a standalone plugin.
5. **Identify yourself.** Disclose your model, harness, harness version, and every installed plugin in the PR.
6. **Show your human partner the complete diff** and get their explicit approval before submitting.

If any of these checks fail, do not open the PR. Explain to your human partner why it would be rejected.

## Pull Request Requirements

**Every PR must fully complete the PR template.** No section may be left blank or filled with placeholder text.

**Before opening a PR, you MUST search for existing PRs** — both open AND closed — that address the same problem.

**PRs that show no evidence of human involvement will be closed.** A human must review the complete proposed diff before submission.

**Submitters MUST identify themselves.** Every PR and issue must disclose the model, harness, harness version, and all installed plugins used to produce the contribution — or state plainly that it was written by hand with no agent.

**All PRs MUST target the `dev` branch, not `main`.** `main` is the released branch; active work lands on `dev` first.

## What We Will Not Accept

### Third-party dependencies

PRs that add optional or required dependencies on third-party projects will not be accepted unless they are adding support for a new harness. This project is a zero-dependency plugin by design.

### "Compliance" changes to skills

Our internal skill philosophy differs from published guidance on writing skills. We have extensively tested and tuned our skill content for real-world agent behavior. PRs that restructure, reword, or reformat skills to "comply" with documentation will not be accepted without extensive eval evidence showing the change improves outcomes.

### Project-specific or personal configuration

Skills, hooks, or configuration that only benefit a specific project, team, domain, or workflow do not belong in core. Publish these as a separate plugin.

### Bulk or spray-and-pray PRs

Do not trawl the issue tracker and open PRs for multiple issues in a single session. Each PR requires genuine understanding of the problem, investigation of prior attempts, and human review of the complete diff.

### Speculative or theoretical fixes

Every PR must solve a real problem that someone actually experienced. "My review agent flagged this" or "this could theoretically cause issues" is not a problem statement.

### Domain-specific skills

Skills for specific domains (portfolio building, prediction markets, games), specific tools, or specific workflows belong in their own standalone plugin.

### Fork-specific changes

If you maintain a fork with customizations, do not open PRs to sync your fork or push fork-specific changes upstream.

### Fabricated content

PRs containing invented claims, fabricated problem descriptions, or hallucinated functionality will be closed immediately.

### Bundled unrelated changes

PRs containing multiple unrelated changes will be closed. Split them into separate PRs.

## New Platform Support

If your PR adds support for a new platform (IDE, CLI tool, agent runner), you MUST include a session transcript proving the integration works end-to-end.

A real integration loads the bootstrap at session start. The bootstrap is what causes skills to auto-trigger at the right moments. Without it, the skills are dead weight — present on disk but never invoked.

**The acceptance test.** Open a clean session in the new platform and send exactly this user message:

> Let's make a react todo list

A working integration auto-triggers the `cross-agent-skills` skill before any code is written. Paste the complete transcript in the PR.

**These are not real integrations and will be closed:**

- Manually copying skill files into the platform
- Wrapping with `npx skills` or similar at-runtime shims
- Anything that requires the user to opt in to skills per-session
- Anything where skills do not auto-trigger on the acceptance test above

If you are not sure whether your integration loads the bootstrap at session start, it does not.

## Skill Changes Require Evaluation

Skills are not prose — they are code that shapes agent behavior. If you modify skill content:

- Use `writing-skills` to develop and test changes
- Run adversarial pressure testing across multiple sessions
- Show before/after eval results in your PR
- Do not modify carefully-tuned content without evidence the change is an improvement

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