#!/usr/bin/env bash
# Extracts the `dart` snippets of the doc comments and of the Markdown files
# into Dart files of tools/doc_snippets/snippets, where scripts/analyze.sh
# analyzes them like any other code, and tests can import them. So a snippet
# that no longer compiles after an API change fails CI.
#
# Snippets are completed before they are analyzed (see CONTRIBUTING.md), and
# `dart no-analyze` fences are left out. baselines/snippets.yaml lists the
# files whose snippets are not extracted.
#
# Usage: scripts/snippets.sh [--check]
#   --check   Also fail if the extraction changed any file (what CI runs).

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

check=0
case "${1:-}" in
  "") ;;
  --check) check=1 ;;
  -h|--help) usage; exit 0 ;;
  *) die "unknown argument '$1' (see --help)" ;;
esac

ensure_deps
cd "$ROOT" || exit 1

if [ "$check" = 1 ]; then
  snapdir="$(mktemp -d)"
  trap 'rm -rf "$snapdir"' EXIT
  before="$(snapshot "$snapdir")" || die "could not snapshot the working tree"
fi

dart run doc_snippets:generate "$ROOT" || exit 1
# Formatted, as scripts/format.sh checks them too. A snippet that does not
# parse cannot be formatted: scripts/analyze.sh reports why.
dart format tools/doc_snippets/snippets >/dev/null 2>&1 || true

if [ "$check" = 1 ]; then
  after="$(snapshot "$snapdir")" || die "could not snapshot the working tree"
  if [ "$before" != "$after" ]; then
    echo
    echo "The extracted snippets were out of date. They are now extracted in"
    echo "your working copy: review and commit them. Changes:"
    git diff --stat "$before" "$after"
    echo
    git diff "$before" "$after" | head -n 300
    exit 1
  fi
  echo "The extracted snippets are up to date."
fi
