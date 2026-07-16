# Cross-Agent Skills

Guidance and templates for repositories that keep reusable agent skills portable while adding only
verified platform-specific distribution metadata.

## Principle

`skills/` is the canonical source of instructions, scripts, and references. A platform manifest is
an optional integration boundary, not a copy of the skill. Do not claim a platform is supported
until its current discovery path and installation workflow have been tested.

## Current Support

| Platform | Status | Files | Installation or validation |
|---|---|---|---|
| Pi | Supported | `package.json` with `pi.skills` | `pi install git:github.com/goodmangll/cross-agent-skills` |
| Claude Code | Supported | `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` | `claude plugin marketplace add goodmangll/cross-agent-skills`, then `claude plugin install cross-agent-skills@cross-agent-skills` |
| Codex | Manifest included | `.codex-plugin/plugin.json` | Validate the current marketplace or plugin-browser flow before publishing a direct install command. |
| Cursor | Not configured | None | Add support only after verifying its current official plugin format and end-to-end installation flow. |

## Repository Layout

```text
skills/<skill-name>/SKILL.md     # Shared source of truth
.claude-plugin/                  # Claude Code discovery and marketplace metadata
.codex-plugin/                   # Codex discovery metadata
package.json                     # Pi package metadata
```

The repository intentionally has no generic `adapters/` directory. Claude Code and Codex discover
plugin manifests at documented root paths; an arbitrary JSON file elsewhere does not create a
working integration.

## Create A Repository

```bash
git clone https://github.com/goodmangll/cross-agent-skills.git
cd cross-agent-skills
./templates/init-repo.sh my-skills "My portable skills"
```

The generated project includes Pi, Claude Code, and Codex metadata. Its README labels Codex
installation as needing a current verification and does not generate Cursor metadata.

## Verification

```bash
npm test
./scripts/bump-version.sh --check
./templates/init-repo.sh /tmp/example-skills "Example"
cd /tmp/example-skills
npm test
```

Repository tests check skill frontmatter, manifest paths, JSON validity, marketplace references,
and documentation claims. Before release, perform an end-to-end installation in each supported
host and record the host version, command, and result in the support matrix.

## License

[MIT](LICENSE)
