# Skill Maintenance Guide

This guide explains how to maintain, update, and iterate on skills in the cross-agent-skills repository.

## Overview

Skills are the core content of this repository. They need regular maintenance to:
- Stay relevant and accurate
- Adapt to platform changes
- Improve based on user feedback
- Fix issues and bugs

## Skill Lifecycle

```
Creation → Testing → Release → Feedback → Update → Testing → Release
   ↑                                                           |
   └───────────────────────────────────────────────────────────┘
```

## 1. Skill Versioning

Each skill should be versioned independently to track changes.

### Adding Version to SKILL.md

```markdown
---
name: skill-name
description: Use when [triggering conditions]
version: 1.0.0
last_updated: 2026-07-16
---

# Skill Name
```

### Version Numbering

Follow semantic versioning:
- **Major (X.0.0)**: Breaking changes in skill behavior
- **Minor (0.X.0)**: New features, significant content changes
- **Patch (0.0.X)**: Bug fixes, minor improvements

## 2. Skill Update Process

### Step 1: Identify Need for Update

**Sources of update requests:**
- User feedback (GitHub issues, discussions)
- Platform changes (new APIs, deprecated features)
- Testing failures
- Community contributions
- Internal review

### Step 2: Create Update Branch

```bash
# Create branch for skill update
git checkout -b skill/update-skill-name

# Or for new skill
git checkout -b skill/add-new-skill-name
```

### Step 3: Make Changes

**When updating existing skills:**
1. Read current skill content
2. Identify what needs changing
3. Make minimal, focused changes
4. Update version and last_updated fields
5. Test the changes

**When adding new skills:**
1. Follow `writing-skills` guidelines
2. Use platform-agnostic language
3. Include clear triggering conditions
4. Add practical examples

### Step 4: Test Changes

**Testing requirements:**
1. **Structure test**: Verify SKILL.md format
2. **Content test**: Ensure no platform-specific code
3. **Behavior test**: Verify skill works as intended
4. **Cross-platform test**: Test on multiple platforms

```bash
# Run skill-specific tests
./scripts/run-tests.sh --cross

# Manual testing
pi -e .  # Test on Pi
# Test on other platforms
```

### Step 5: Document Changes

Update `RELEASE-NOTES.md` with:
```markdown
## v1.1.0 (2026-07-16)

### Skill: skill-name
- Changed: [what was changed]
- Added: [new features]
- Fixed: [bug fixes]
- Breaking: [breaking changes]
```

### Step 6: Create PR

**PR requirements:**
1. Fill out PR template completely
2. Include before/after comparison
3. Provide test results
4. Disclose AI agent (if used)
5. Link to related issues

## 3. Skill Testing Framework

### Automated Tests

**Structure validation:**
```javascript
// tests/skill-structure.test.js
test('Skill has required frontmatter', () => {
  const skill = readSkill('skill-name');
  assert(skill.includes('name:'));
  assert(skill.includes('description:'));
  assert(skill.includes('version:'));
});
```

**Content validation:**
```javascript
test('Skill has no platform-specific code', () => {
  const skill = readSkill('skill-name');
  const platformPatterns = [
    /\bpi\.(on|register)/,
    /\bclaude\b/i,
    /\bcodex\b/i
  ];
  
  for (const pattern of platformPatterns) {
    assert(!pattern.test(skill), `Platform-specific code found: ${pattern}`);
  }
});
```

### Manual Testing Checklist

- [ ] Skill loads correctly on Pi
- [ ] Skill loads correctly on Claude Code
- [ ] Skill loads correctly on Codex
- [ ] Skill loads correctly on Cursor
- [ ] Description triggers correctly
- [ ] Instructions are clear
- [ ] Examples work as expected
- [ ] No broken references

### Testing Scripts

**Create skill test script:**
```bash
#!/bin/bash
# tests/test-skill.sh

SKILL_NAME=$1
SKILL_DIR="skills/$SKILL_NAME"

# Check structure
echo "Testing skill: $SKILL_NAME"

# 1. Check SKILL.md exists
if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
  echo "❌ SKILL.md not found"
  exit 1
fi

# 2. Check frontmatter
if ! head -n 10 "$SKILL_DIR/SKILL.md" | grep -q "name:"; then
  echo "❌ Missing name field"
  exit 1
fi

# 3. Check for platform-specific code
if grep -qE '\bpi\.(on|register)|\bclaude\b|\bcodex\b' "$SKILL_DIR/SKILL.md"; then
  echo "⚠️  Platform-specific code detected"
fi

echo "✓ Skill structure OK"
```

## 4. Skill Documentation

### Required Documentation

Each skill should have:

1. **SKILL.md**: Main skill document
2. **README section**: Brief description in repo README
3. **Examples**: Practical usage examples
4. **Changelog**: Version history in RELEASE-NOTES.md

### Documentation Updates

When updating skills, also update:
- Repository README.md (if adding new skill)
- RELEASE-NOTES.md (always)
- CONTRIBUTING.md (if changing contribution process)

## 5. Skill Review Process

### Review Checklist

**For skill updates:**
- [ ] Changes are minimal and focused
- [ ] Version number updated
- [ ] last_updated field updated
- [ ] RELEASE-NOTES.md updated
- [ ] No platform-specific code introduced
- [ ] Examples still work
- [ ] Tests pass

**For new skills:**
- [ ] Follows writing-skills guidelines
- [ ] Has clear triggering conditions
- [ ] Uses platform-agnostic language
- [ ] Includes practical examples
- [ ] Tested on multiple platforms
- [ ] Documentation complete

### Review Criteria

**Accept if:**
- Changes improve skill quality
- No breaking changes without good reason
- Tests pass
- Documentation is clear

**Reject if:**
- Changes introduce platform-specific code
- Breaking changes without migration guide
- Poor documentation
- Untested changes

## 6. Skill Deprecation

### When to Deprecate

- Skill is no longer relevant
- Better alternative exists
- Platform no longer supports it
- Maintenance burden too high

### Deprecation Process

1. **Mark as deprecated** in SKILL.md:
   ```markdown
   ---
   name: old-skill
   deprecated: true
   replacement: new-skill
   ---
   ```

2. **Update README** to note deprecation

3. **Add to RELEASE-NOTES.md**:
   ```markdown
   ### Deprecated
   - `old-skill`: Replaced by `new-skill`
   ```

4. **Keep for backward compatibility** for one major version

5. **Remove** in next major version

## 7. Skill Metrics

### Track Usage

- GitHub stars on repository
- Installation count (npm, git)
- Issue reports
- Community contributions

### Quality Metrics

- Test coverage
- Platform compatibility
- User feedback score
- Documentation completeness

## 8. Automation

### GitHub Actions for Skill Maintenance

```yaml
# .github/workflows/skill-check.yml
name: Skill Quality Check

on:
  pull_request:
    paths:
      - 'skills/**'

jobs:
  skill-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Check skill structure
        run: |
          for skill in skills/*/SKILL.md; do
            echo "Checking $skill"
            head -n 10 "$skill" | grep -q "name:" || exit 1
            head -n 10 "$skill" | grep -q "description:" || exit 1
          done
      
      - name: Check for platform-specific code
        run: |
          grep -rE '\bpi\.(on|register)|\bclaude\b|\bcodex\b' skills/ && exit 1 || true
```

### Scheduled Maintenance

**Monthly:**
- Review open issues
- Check for outdated skills
- Update dependencies

**Quarterly:**
- Audit all skills
- Update documentation
- Review contribution guidelines

**Yearly:**
- Major version review
- Deprecation decisions
- Architecture review

## 9. Best Practices

### Skill Updates

1. **One change at a time**: Don't bundle multiple unrelated changes
2. **Backward compatible**: Avoid breaking changes when possible
3. **Test thoroughly**: Verify on all platforms
4. **Document clearly**: Explain what changed and why
5. **Get review**: Have someone else check your changes

### Communication

1. **Use issues**: Track problems and feature requests
2. **Use discussions**: Brainstorm solutions
3. **Use PRs**: Review all changes
4. **Use releases**: Communicate changes to users

### Quality

1. **Follow standards**: Agent Skills standard
2. **Be consistent**: Same format across all skills
3. **Be clear**: Simple, understandable language
4. **Be practical**: Real-world examples

## 10. Tools and Resources

### Useful Commands

```bash
# Check all skills
find skills/ -name "SKILL.md" -exec echo {} \;

# Validate frontmatter
for f in skills/*/SKILL.md; do
  head -n 10 "$f" | grep -q "name:" && echo "✓ $f" || echo "✗ $f"
done

# Find platform-specific code
grep -rE '\bpi\.(on|register)|\bclaude\b|\bcodex\b' skills/

# Count lines per skill
wc -l skills/*/SKILL.md
```

### External Resources

- [Agent Skills Standard](https://agentskills.io)
- [Writing Skills Guide](https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md)
- [Superpowers Examples](https://github.com/obra/superpowers/tree/main/skills)