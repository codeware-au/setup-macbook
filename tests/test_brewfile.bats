#!/usr/bin/env bats

# Brewfile validation tests
# Requires: bats-core (https://github.com/bats-core/bats-core)

BREWFILE="$BATS_TEST_DIRNAME/../Brewfile"

@test "Brewfile exists" {
  [ -f "$BREWFILE" ]
}

@test "Brewfile is not empty" {
  [ -s "$BREWFILE" ]
}

@test "No duplicate brew entries" {
  duplicates=$(grep '^brew ' "$BREWFILE" | sort | uniq -d)
  if [ -n "$duplicates" ]; then
    echo "Duplicate brew entries found: $duplicates" >&2
    return 1
  fi
}

@test "No duplicate cask entries" {
  duplicates=$(grep '^cask ' "$BREWFILE" | sort | uniq -d)
  if [ -n "$duplicates" ]; then
    echo "Duplicate cask entries found: $duplicates" >&2
    return 1
  fi
}

@test "No duplicate mas entries" {
  duplicates=$(grep '^mas ' "$BREWFILE" | sort | uniq -d)
  if [ -n "$duplicates" ]; then
    echo "Duplicate mas entries found: $duplicates" >&2
    return 1
  fi
}

@test "All lines match valid Brewfile syntax" {
  while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    # Must match: brew "...", cask "...", mas "...", id: ..., or tap "..."
    if ! [[ "$line" =~ ^brew\ \".+\"$ ]] &&
       ! [[ "$line" =~ ^cask\ \".+\"$ ]] &&
       ! [[ "$line" =~ ^mas\ \".+\",\ id:\ [0-9]+$ ]] &&
       ! [[ "$line" =~ ^tap\ \".+\"$ ]]; then
      echo "Invalid Brewfile line: $line" >&2
      return 1
    fi
  done < "$BREWFILE"
}

@test "No trailing whitespace in Brewfile" {
  if grep -qP '\s+$' "$BREWFILE"; then
    echo "Trailing whitespace found" >&2
    return 1
  fi
}
