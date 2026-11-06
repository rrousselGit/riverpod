#!/usr/bin/env bash
# Regenerates package_graph.yaml (how workspace packages depend on each other)
# from the pubspec.yaml files, using tools/package_graph.
#
# Usage: scripts/graph.sh [--check]
#   --check   Don't write. Fail, with a diff, if the committed file is stale.

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

check=0
for arg in "$@"; do
  case "$arg" in
    --check) check=1 ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument '$arg' (see --help)" ;;
  esac
done

ensure_deps
cd "$ROOT" || exit 1
fresh="$(mktemp)"
trap 'rm -f "$fresh"' EXIT
dart run "$GRAPH_TOOL" --output "$fresh" || exit 1

if cmp -s "$fresh" "$GRAPH"; then
  echo "package_graph.yaml is up to date."
elif [ "$check" = 1 ]; then
  diff -u "$GRAPH" "$fresh"
  echo
  echo "package_graph.yaml is out of date with the pubspec.yaml files."
  echo "Fix with: scripts/graph.sh"
  exit 1
else
  cp "$fresh" "$GRAPH"
  echo "Updated package_graph.yaml."
fi
