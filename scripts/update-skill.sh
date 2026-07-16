#!/usr/bin/env bash
#
# update-skill.sh — Update a skill with version bump and testing
#
# Usage:
#   update-skill.sh <skill-name> <update-type> <description>
#
# Examples:
#   update-skill.sh cross-agent-skills patch "Fix broken link"
#   update-skill.sh cross-agent-skills minor "Add new examples"
#   update-skill.sh cross-agent-skills major "Change skill behavior"
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

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
validate_inputs() {
  local skill_name="$1"
  local update_type="$2"
  local description="$3"
  
  # Check skill exists
  if [[ ! -d "$REPO_ROOT/skills/$skill_name" ]]; then
    log_error "Skill '$skill_name' not found in skills/ directory"
    exit 1
  fi
  
  # Check SKILL.md exists
  if [[ ! -f "$REPO_ROOT/skills/$skill_name/SKILL.md" ]]; then
    log_error "SKILL.md not found for skill '$skill_name'"
    exit 1
  fi
  
  # Validate update type
  if [[ ! "$update_type" =~ ^(patch|minor|major)$ ]]; then
    log_error "Update type must be 'patch', 'minor', or 'major'"
    exit 1
  fi
  
  # Check description
  if [[ -z "$description" ]]; then
    log_error "Description is required"
    exit 1
  fi
}

# Get current version
get_current_version() {
  local skill_file="$1"
  grep -oP 'version:\s*\K[0-9]+\.[0-9]+\.[0-9]+' "$skill_file" || echo "0.0.0"
}

# Calculate new version
calculate_new_version() {
  local current_version="$1"
  local update_type="$2"
  
  IFS='.' read -r major minor patch <<< "$current_version"
  
  case "$update_type" in
    major)
      echo "$((major + 1)).0.0"
      ;;
    minor)
      echo "$major.$((minor + 1)).0"
      ;;
    patch)
      echo "$major.$minor.$((patch + 1))"
      ;;
  esac
}

# Update skill version
update_skill_version() {
  local skill_file="$1"
  local new_version="$2"
  local today
  today=$(date +%Y-%m-%d)
  
  # Update version
  sed -i '' "s/version: [0-9]\+\.[0-9]\+\.[0-9]\+/version: $new_version/" "$skill_file"
  
  # Update last_updated
  if grep -q "last_updated:" "$skill_file"; then
    sed -i '' "s/last_updated: [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}/last_updated: $today/" "$skill_file"
  else
    # Add last_updated after version line
    sed -i '' "/version: $new_version/a\\
last_updated: $today" "$skill_file"
  fi
  
  log_info "Updated skill version to $new_version"
}

# Test skill
test_skill() {
  local skill_name="$1"
  
  log_info "Testing skill: $skill_name"
  
  # Run structure tests
  if ! "$REPO_ROOT/scripts/run-tests.sh" --cross; then
    log_error "Cross-platform tests failed"
    return 1
  fi
  
  # Check for platform-specific code
  if grep -qE '\bpi\.(on|register)|\bclaude\b|\bcodex\b' "$REPO_ROOT/skills/$skill_name/SKILL.md"; then
    log_warn "Platform-specific code detected in skill"
  fi
  
  log_info "Skill tests passed"
}

# Update release notes
update_release_notes() {
  local skill_name="$1"
  local update_type="$2"
  local description="$3"
  local version="$4"
  local today
  today=$(date +%Y-%m-%d)
  
  local release_file="$REPO_ROOT/RELEASE-NOTES.md"
  
  # Check if version already exists
  if grep -q "## v$version" "$release_file"; then
    log_info "Version $version already in release notes"
    return 0
  fi
  
  # Add new version section
  local temp_file
  temp_file=$(mktemp)
  
  # Read existing content
  cat "$release_file" > "$temp_file"
  
  # Find insertion point (after first # heading)
  local insertion_line
  insertion_line=$(grep -n "^# " "$temp_file" | head -1 | cut -d: -f1)
  
  if [[ -z "$insertion_line" ]]; then
    # Append to end
    echo "" >> "$temp_file"
    echo "## v$version ($today)" >> "$temp_file"
    echo "" >> "$temp_file"
    echo "### Skill: $skill_name" >> "$temp_file"
    echo "" >> "$temp_file"
    echo "- **$update_type**: $description" >> "$temp_file"
  else
    # Insert after heading
    sed -i '' "${insertion_line}a\\
\\
## v$version ($today)\\
\\
### Skill: $skill_name\\
\\
- **$update_type**: $description" "$temp_file"
  fi
  
  # Replace original file
  mv "$temp_file" "$release_file"
  
  log_info "Updated RELEASE-NOTES.md"
}

# Create git branch
create_branch() {
  local skill_name="$1"
  local update_type="$2"
  
  local branch_name="skill/update-${skill_name}"
  
  # Check if branch exists
  if git -C "$REPO_ROOT" show-ref --verify --quiet "refs/heads/$branch_name"; then
    log_warn "Branch $branch_name already exists"
    git -C "$REPO_ROOT" checkout "$branch_name"
  else
    git -C "$REPO_ROOT" checkout -b "$branch_name"
    log_info "Created branch: $branch_name"
  fi
}

# Commit changes
commit_changes() {
  local skill_name="$1"
  local update_type="$2"
  local description="$3"
  local version="$4"
  
  cd "$REPO_ROOT"
  
  # Add changes
  git add "skills/$skill_name/SKILL.md"
  git add RELEASE-NOTES.md
  
  # Commit
  git commit -m "skill($skill_name): $update_type v$version

- $description
- Updated version to $version
- Updated release notes"
  
  log_info "Committed changes"
}

# Main function
main() {
  if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <skill-name> <update-type> <description>"
    echo ""
    echo "Update types:"
    echo "  patch   - Bug fixes, minor improvements"
    echo "  minor   - New features, significant changes"
    echo "  major   - Breaking changes"
    echo ""
    echo "Examples:"
    echo "  $0 cross-agent-skills patch 'Fix broken link'"
    echo "  $0 cross-agent-skills minor 'Add new examples'"
    echo "  $0 cross-agent-skills major 'Change skill behavior'"
    exit 1
  fi
  
  local skill_name="$1"
  local update_type="$2"
  local description="$3"
  
  # Validate inputs
  validate_inputs "$skill_name" "$update_type" "$description"
  
  # Get current version
  local skill_file="$REPO_ROOT/skills/$skill_name/SKILL.md"
  local current_version
  current_version=$(get_current_version "$skill_file")
  
  log_info "Current version: $current_version"
  
  # Calculate new version
  local new_version
  new_version=$(calculate_new_version "$current_version" "$update_type")
  
  log_info "New version: $new_version"
  
  # Create branch
  create_branch "$skill_name" "$update_type"
  
  # Update skill version
  update_skill_version "$skill_file" "$new_version"
  
  # Test skill
  if ! test_skill "$skill_name"; then
    log_error "Skill tests failed. Please fix issues before committing."
    git -C "$REPO_ROOT" checkout -
    exit 1
  fi
  
  # Update release notes
  update_release_notes "$skill_name" "$update_type" "$description" "$new_version"
  
  # Commit changes
  commit_changes "$skill_name" "$update_type" "$description" "$new_version"
  
  log_info "Skill updated successfully!"
  log_info "Next steps:"
  log_info "  1. Review changes: git diff"
  log_info "  2. Push branch: git push -u origin skill/update-$skill_name"
  log_info "  3. Create PR: gh pr create"
}

main "$@"