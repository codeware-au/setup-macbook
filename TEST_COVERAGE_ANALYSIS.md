# Test Coverage Analysis

## Current State

**Test coverage: 0%** — The project has no tests, no testing framework, no CI/CD pipeline, and no linting configuration.

The codebase consists of 3 files:

| File | Lines | Testable | Description |
|------|-------|----------|-------------|
| `install.sh` | 25 | Yes | Main setup script with branching logic |
| `Brewfile` | 24 | Yes | Package manifest (validatable) |
| `README.md` | 29 | Yes | Documentation (consistency-checkable) |

## Bugs Found During Analysis

### 1. Duplicate `node` entry in Brewfile (line 4 and line 9)

`node` appears twice, which causes a warning from `brew bundle` and indicates a maintenance issue.

### 2. README lists `certbot` but it is not in Brewfile

The README (`README.md:7`) still mentions `certbot` in the CLI Tools list, but commit `c024593` removed it from the Brewfile. This is a documentation-code drift that a test could catch.

### 3. No `.gitignore` file

There is no `.gitignore` to prevent accidental commits of macOS artifacts (`.DS_Store`), editor configs, or other unwanted files.

## Proposed Test Areas

### Area 1: Shell Script Linting (Static Analysis)

**Tool**: [ShellCheck](https://www.shellcheck.net/)
**Priority**: High
**What it catches**:
- Quoting issues and word splitting bugs
- Unreachable code
- Deprecated syntax
- Common bash pitfalls

**Example issues in `install.sh`**:
- The `curl` piped into `bash -c` pattern could be flagged for safety
- Variable quoting could be audited

### Area 2: Brewfile Validation

**Tool**: Custom bash script or BATS test
**Priority**: High
**What it catches**:
- Duplicate package entries (like the `node` duplicate on lines 4 and 9)
- Syntax errors in the Brewfile format
- Empty or malformed lines

**Proposed checks**:
- No duplicate `brew` entries
- No duplicate `cask` entries
- No duplicate `mas` entries
- Every line matches expected format: `brew "..."`, `cask "..."`, `mas "...", id: ...`

### Area 3: Documentation Consistency

**Tool**: Custom bash script or BATS test
**Priority**: Medium
**What it catches**:
- Tools listed in README but missing from Brewfile (like `certbot`)
- Tools in Brewfile not mentioned in README
- Stale documentation after Brewfile changes

**Proposed checks**:
- Every brew/cask name in Brewfile has a corresponding mention in README
- README does not reference packages that have been removed

### Area 4: Install Script Unit Tests

**Tool**: [BATS (Bash Automated Testing System)](https://github.com/bats-core/bats-core)
**Priority**: Medium
**What it catches**:
- Logic errors in Homebrew detection
- ARM64 path configuration issues
- Brewfile path resolution bugs
- Behavior when `brew` is missing vs. present

**Proposed test cases**:
- Verify the script exits on error (`set -e` is present)
- Verify Homebrew install is skipped when `brew` is already available
- Verify ARM64 path setup is only triggered on `arm64` architecture
- Verify the Brewfile path resolves correctly regardless of working directory
- Verify `brew update`, `brew bundle install`, and `brew cleanup` are called in order

### Area 5: CI/CD Pipeline

**Tool**: GitHub Actions
**Priority**: High
**What it catches**:
- Regressions on every push/PR
- Ensures all the above checks run automatically

**Proposed workflow**:
1. Run ShellCheck on `install.sh`
2. Run Brewfile validation (duplicate check, syntax check)
3. Run documentation consistency checks
4. Run BATS unit tests (with mocked `brew` commands)

## Recommended Implementation Order

1. **Add ShellCheck linting** — Immediate value with zero custom code; just add a CI step
2. **Add Brewfile duplicate/syntax validation** — Catches the existing `node` duplicate bug
3. **Add GitHub Actions CI pipeline** — Automates checks on every PR
4. **Add documentation consistency tests** — Catches the existing `certbot` drift bug
5. **Add BATS unit tests for install.sh** — Highest effort but catches logic regressions

## Example Test Implementations

See the `tests/` directory for reference implementations:
- `tests/test_brewfile.bats` — Brewfile validation tests
- `tests/test_install.bats` — Install script unit tests
- `tests/test_docs.bats` — Documentation consistency tests
- `.github/workflows/ci.yml` — CI pipeline configuration
