#!/usr/bin/env bash
# Runs build_runner in every package that uses it, in dependency order: one
# layer of package_graph.yaml at a time, packages within a layer in parallel.
# Stops at the first failing layer, since later layers depend on it.
#
# Usage: scripts/generate.sh [--check] [-j N] [PACKAGE...]
#   --check   Also fail if generation changed any file (what CI runs).
#   -j N      Max parallel build_runner processes (default: CPU count).
#   PACKAGE   Only these package paths (still in dependency order).

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"
# shellcheck source=lib/packages.sh
. "$SCRIPTS/lib/packages.sh"
# shellcheck source=lib/pool.sh
. "$SCRIPTS/lib/pool.sh"

check=0
selected=""
while [ $# -gt 0 ]; do
  case "$1" in
    --check) check=1; shift ;;
    -j) [ $# -ge 2 ] || die "-j needs a number"; POOL_JOBS="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    -*) die "unknown option '$1' (see --help)" ;;
    *) selected="$selected $(normalize "$1")"; shift ;;
  esac
done
require_graph
# shellcheck disable=SC2086 # word splitting of the package list is intended
validate_packages $selected
ensure_deps
cd "$ROOT" || exit 1

# The layers, as "<path> ..." lines, keeping only codegen packages that were
# selected (or all of them when none were).
packages="$(graph_packages)"
layers="$(graph_layers | while read -r layer; do
  line=""
  for name in $layer; do
    read -r path codegen <<<"$(awk -v n="$name" '$1 == n { print $2, $3 }' <<<"$packages")"
    [ "$codegen" = true ] || continue
    [ -z "$selected" ] || [[ " $selected " == *" $path "* ]] || continue
    line="$line $path"
  done
  [ -n "$line" ] && echo "${line# }"
done)"
targets="$(tr ' ' '\n' <<<"$layers" | grep -c .)"

# The tree a `git add -A` would produce now, without touching the real index.
# Comparing it before and after catches modified, new and deleted files while
# ignoring changes the working copy already had.
snapshot() {
  local idx="$1/snapshot.index" real
  real="$(git rev-parse --git-path index)"
  if [ -f "$real" ]; then cp "$real" "$idx"; else rm -f "$idx"; fi
  GIT_INDEX_FILE="$idx" git add -A . && GIT_INDEX_FILE="$idx" git write-tree
}
if [ "$check" = 1 ]; then
  snapdir="$(mktemp -d)"
  trap 'rm -rf "$snapdir"' EXIT
  before="$(snapshot "$snapdir")" || die "could not snapshot the working tree"
fi

if [ "$targets" = 0 ]; then
  echo "Nothing to generate."
elif [ "$targets" = 1 ]; then
  # A single package: run build_runner directly.
  (cd "$ROOT/$layers" && dart run build_runner build --delete-conflicting-outputs) || exit 1
else
  pool_init
  total="$(grep -c . <<<"$layers")"
  number=0
  while read -r layer <&3; do
    number=$((number + 1))
    echo "layer $number/$total"
    for path in $layer; do pool_add "generate $path" "scripts/generate.sh $path"; done
    if ! pool_run; then
      echo "  (stopping: later layers depend on this one)"
      break
    fi
  done 3<<<"$layers"
  pool_report || exit 1
fi

if [ "$check" = 1 ]; then
  after="$(snapshot "$snapdir")" || die "could not snapshot the working tree"
  if [ "$before" != "$after" ]; then
    echo
    echo "Generated files were out of date. They are now regenerated in your"
    echo "working copy: review and commit them. Changes:"
    git diff --stat "$before" "$after"
    echo
    git diff "$before" "$after" | head -n 300
    exit 1
  fi
  echo "Generated code is up to date."
fi
