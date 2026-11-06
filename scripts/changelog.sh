#!/usr/bin/env bash
# Checks that changed packages have a CHANGELOG.md entry in the expected
# `## Unreleased fix/major/minor` form, using semantic_changelog.
#
# Usage: scripts/changelog.sh [BASE]
#   BASE   Ref to compare against (default: origin/master; fetched if missing).

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

case "${1:-}" in -h|--help) usage; exit 0 ;; esac
base="${1:-origin/master}"
cd "$ROOT" || exit 1

if ! git rev-parse --verify --quiet "$base" >/dev/null; then
  case "$base" in
    origin/*) git fetch --no-tags origin "${base#origin/}:refs/remotes/$base" || exit 1 ;;
    *) die "ref '$base' does not exist" ;;
  esac
fi
ensure_pub_global semantic_changelog -s git https://github.com/rrousselGit/semantic_changelog
dart pub global run semantic_changelog check "$base"
