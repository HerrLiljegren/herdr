#!/usr/bin/env bash
set -u

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output="$(mktemp)"
trap 'rm -f "$output"' EXIT

cd "$repo_root"
build_id="$(git rev-parse --short HEAD)"
git diff --quiet && git diff --cached --quiet || build_id="${build_id}-dirty"

if nix --extra-experimental-features 'nix-command flakes' develop -c \
  env HERDR_BUILD_CHANNEL=local HERDR_BUILD_ID="$build_id" just build \
  >"$output" 2>&1; then
  exit 0
else
  status=$?
  cat "$output" >&2
  exit "$status"
fi
