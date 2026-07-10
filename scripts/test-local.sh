#!/usr/bin/env bash
set -u

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output="$(mktemp)"
trap 'rm -f "$output"' EXIT

if (
  cd "$repo_root"
  nix --extra-experimental-features 'nix-command flakes' develop -c just test
) >"$output" 2>&1; then
  exit 0
else
  status=$?
  cat "$output" >&2
  exit "$status"
fi
