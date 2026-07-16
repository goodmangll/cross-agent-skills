#!/usr/bin/env bash
#
# run-tests.sh — Run all tests for cross-agent-skills
#
# Usage:
#   run-tests.sh              Run all tests
#   run-tests.sh --pi         Run only Pi tests
#   run-tests.sh --claude     Run only Claude tests
#   run-tests.sh --codex      Run only Codex tests
#   run-tests.sh --cursor     Run only Cursor tests
#   run-tests.sh --cross      Run only cross-platform tests
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

# Run tests
run_tests() {
  local test_type="$1"
  local test_dir="$REPO_ROOT/tests/$test_type"
  
  if [[ ! -d "$test_dir" ]]; then
    log_warn "No tests found for $test_type"
    return 0
  fi
  
  log_info "Running $test_type tests..."
  
  # Find test files
  local test_files=()
  while IFS= read -r -d '' file; do
    test_files+=("$file")
  done < <(find "$test_dir" -name "test-*.mjs" -o -name "test-*.js" -print0)
  
  if [[ ${#test_files[@]} -eq 0 ]]; then
    log_warn "No test files found in $test_dir"
    return 0
  fi
  
  # Run each test file
  for test_file in "${test_files[@]}"; do
    log_info "Running $(basename "$test_file")..."
    if node --test "$test_file"; then
      log_info "✓ $(basename "$test_file") passed"
    else
      log_error "✗ $(basename "$test_file") failed"
      return 1
    fi
  done
  
  return 0
}

# Main
main() {
  local run_all=true
  local platforms=()
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --pi)
        platforms=("pi")
        run_all=false
        shift
        ;;
      --claude)
        platforms=("claude")
        run_all=false
        shift
        ;;
      --codex)
        platforms=("codex")
        run_all=false
        shift
        ;;
      --cursor)
        platforms=("cursor")
        run_all=false
        shift
        ;;
      --cross)
        platforms=("cross-platform-test.js")
        run_all=false
        shift
        ;;
      --help|-h)
        echo "Usage: $0 [--pi|--claude|--codex|--cursor|--cross]"
        echo ""
        echo "Options:"
        echo "  --pi      Run only Pi tests"
        echo "  --claude  Run only Claude tests"
        echo "  --codex   Run only Codex tests"
        echo "  --cursor  Run only Cursor tests"
        echo "  --cross   Run only cross-platform tests"
        echo "  (no args) Run all tests"
        exit 0
        ;;
      *)
        log_error "Unknown option: $1"
        exit 1
        ;;
    esac
  done
  
  # Run tests
  if [[ "$run_all" == true ]]; then
    log_info "Running all tests..."
    echo ""
    
    # Run cross-platform tests first
    log_info "Running cross-platform compatibility tests..."
    if node --test "$REPO_ROOT/tests/cross-platform-test.js"; then
      log_info "✓ Cross-platform tests passed"
    else
      log_error "✗ Cross-platform tests failed"
      exit 1
    fi
    echo ""
    
    # Run platform-specific tests
    for platform in pi claude codex cursor; do
      run_tests "$platform" || exit 1
      echo ""
    done
    
    log_info "All tests passed! ✓"
  else
    # Run specific platform tests
    for platform in "${platforms[@]}"; do
      if [[ "$platform" == "cross-platform-test.js" ]]; then
        log_info "Running cross-platform compatibility tests..."
        if node --test "$REPO_ROOT/tests/$platform"; then
          log_info "✓ Cross-platform tests passed"
        else
          log_error "✗ Cross-platform tests failed"
          exit 1
        fi
      else
        run_tests "$platform" || exit 1
      fi
    done
  fi
}

main "$@"