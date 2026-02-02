#!/usr/bin/env bats

# Install script unit tests
# Requires: bats-core (https://github.com/bats-core/bats-core)
# These tests validate script structure and logic without executing installs.

INSTALL_SCRIPT="$BATS_TEST_DIRNAME/../install.sh"

@test "install.sh exists and is readable" {
  [ -r "$INSTALL_SCRIPT" ]
}

@test "install.sh starts with a shebang" {
  head -1 "$INSTALL_SCRIPT" | grep -q '^#!/bin/bash'
}

@test "install.sh uses set -e for error handling" {
  grep -q '^set -e' "$INSTALL_SCRIPT"
}

@test "install.sh checks for Homebrew before installing" {
  grep -q 'command -v brew' "$INSTALL_SCRIPT"
}

@test "install.sh handles ARM64 architecture" {
  grep -q 'uname -m' "$INSTALL_SCRIPT"
  grep -q 'arm64' "$INSTALL_SCRIPT"
}

@test "install.sh references the Brewfile using dirname for portability" {
  grep -q 'dirname.*Brewfile' "$INSTALL_SCRIPT"
}

@test "install.sh runs brew update before bundle install" {
  update_line=$(grep -n 'brew update' "$INSTALL_SCRIPT" | head -1 | cut -d: -f1)
  bundle_line=$(grep -n 'brew bundle' "$INSTALL_SCRIPT" | head -1 | cut -d: -f1)
  [ "$update_line" -lt "$bundle_line" ]
}

@test "install.sh runs brew cleanup after installation" {
  bundle_line=$(grep -n 'brew bundle' "$INSTALL_SCRIPT" | head -1 | cut -d: -f1)
  cleanup_line=$(grep -n 'brew cleanup' "$INSTALL_SCRIPT" | head -1 | cut -d: -f1)
  [ "$bundle_line" -lt "$cleanup_line" ]
}

@test "install.sh does not contain hardcoded Brewfile paths" {
  # The Brewfile path should be derived dynamically, not hardcoded
  ! grep -q 'brew bundle install --file="/.*Brewfile"' "$INSTALL_SCRIPT"
  ! grep -q 'brew bundle install --file="~/.*Brewfile"' "$INSTALL_SCRIPT"
}
