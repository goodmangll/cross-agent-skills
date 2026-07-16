---
name: cross-agent-skills
description: Use when creating or distributing a reusable skill repository for more than one AI coding agent platform.
---

# Cross-Agent Skills

Keep the skill content portable. Add a platform integration only after its discovery path and installation flow have been verified.

## Core Model

```text
skills/<name>/SKILL.md     # Canonical, platform-neutral skill content
platform manifest(s)       # Optional, platform-specific distribution metadata
README + tests             # Supported platform matrix and verification evidence
```

A portable skill is not automatically an installable plugin on every platform. Do not claim a platform is supported until the repository has its required manifest and a verified installation path.

## Repository Layout

```text
repo/
├── skills/
│   └── skill-name/
│       ├── SKILL.md
│       └── scripts/ or references/       # Optional
├── .claude-plugin/
│   ├── plugin.json                       # Claude Code plugin metadata
│   └── marketplace.json                  # Required for marketplace distribution
├── .codex-plugin/
│   └── plugin.json                       # Codex plugin metadata
├── package.json                          # Pi package metadata, when supporting Pi
├── README.md
└── tests/
```

Create only the files for platforms verified by the repository. Do not create placeholder manifests for unsupported platforms.

## Portable Skill Content

Use the Agent Skills standard:

```markdown
---
name: skill-name
description: Use when [specific user intent or condition]
---

# Skill Name

## When To Use

## Workflow

## Verification
```

Keep the core skill independent of a platform's plugin commands, manifest paths, or UI. Describe work in terms of outcomes, such as reading files, running commands, or writing output. The current agent's own tool environment determines the concrete tool names.

Platform names may appear when this skill teaches distribution. That is documentation, not platform-specific implementation.

## Platform Support

| Platform | Required files | Installation evidence |
|---|---|---|
| Pi | `package.json` with `pi.skills` | `pi install <source>` then confirm the skill is discovered |
| Claude Code | `.claude-plugin/plugin.json`; add `marketplace.json` for Git distribution | Add marketplace, install named plugin, start a new session |
| Codex | `.codex-plugin/plugin.json` | Install through a configured marketplace or plugin browser, start a new session |
| Cursor | Add only after verifying current official plugin format and installation flow | Record the official source and end-to-end test in the README |

For a pure Pi skill package, `pi.skills: ["skills"]` is enough. Add a Pi extension only when the package needs Pi-only runtime behavior such as a command, tool, hook, or lifecycle event.

### Claude Code Marketplace

A repository that distributes a Claude Code plugin from GitHub needs both files:

```text
.claude-plugin/plugin.json
.claude-plugin/marketplace.json
```

`marketplace.json` must point to the repository's plugin root. Users can then run:

```bash
claude plugin marketplace add owner/repository
claude plugin install plugin-name@marketplace-name
```

Do not document invented `@github:` installation syntax.

### Codex

Place the plugin manifest at `.codex-plugin/plugin.json`, not an arbitrary adapter directory. Document only the marketplace or plugin-browser flow actually tested against the current Codex version.

## Verification

Use three layers:

1. **Structure checks:** every skill has valid frontmatter; required manifests exist at the platform's discovery path; manifest JSON parses; referenced files exist.
2. **Package checks:** run the platform's package validation where available and inspect `npm pack --dry-run` when publishing npm packages.
3. **End-to-end checks:** install from the intended source in a clean environment, start a new session, and verify the skill is discovered or auto-triggers as expected.

A test that only proves an arbitrary JSON file exists does not verify a platform integration. Record the tested platform version, command, date, and result in the README support matrix.

## Common Mistakes

| Mistake | Correction |
|---|---|
| Putting manifests under `adapters/` | Use the platform's documented root directory. |
| Copying one platform's JSON schema to another | Verify each platform independently. |
| Adding a generic tool-name mapping | Keep core skill language outcome-oriented; adapters cannot rename a host's built-in tools. |
| Calling every platform supported | Mark unverified platforms as unsupported or experimental. |
| Checking only JSON syntax | Also validate paths, package contents, and an actual install. |
| Adding a Pi extension for a static skill | Use `pi.skills` alone unless Pi-only runtime behavior is necessary. |
