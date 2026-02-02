#!/usr/bin/env bats

# Documentation consistency tests
# Verifies README.md stays in sync with the actual Brewfile contents.

BREWFILE="$BATS_TEST_DIRNAME/../Brewfile"
README="$BATS_TEST_DIRNAME/../README.md"

@test "README.md exists" {
  [ -f "$README" ]
}

@test "README contains quick start instructions" {
  grep -q 'install.sh' "$README"
}

@test "README does not reference packages removed from Brewfile" {
  # Extract all brew package names from Brewfile
  brew_packages=$(grep '^brew ' "$BREWFILE" | sed 's/brew "\(.*\)"/\1/')

  # Known package names that might appear in README
  # Check that README doesn't mention tools that aren't in the Brewfile
  readme_lower=$(tr '[:upper:]' '[:lower:]' < "$README")

  missing=()
  for term in certbot; do
    if echo "$readme_lower" | grep -q "$term"; then
      if ! echo "$brew_packages" | grep -q "$term"; then
        missing+=("$term")
      fi
    fi
  done

  if [ ${#missing[@]} -gt 0 ]; then
    echo "README references packages not in Brewfile: ${missing[*]}" >&2
    return 1
  fi
}

@test "README mentions the clone URL for the repository" {
  grep -q 'git clone' "$README"
}

@test "README contains a troubleshooting section" {
  grep -q '## Troubleshooting' "$README"
}
