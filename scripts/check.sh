#!/usr/bin/env bash
# Runs every check CI runs, by calling the smaller scripts in this folder.
# CI only calls this, so a local pass means a CI pass.
#
# Usage: scripts/check.sh [options] [step...]
#
# Steps (default: all). Whatever order they are given in, they run as:
#   graph       scripts/graph.sh --check       package_graph.yaml is current
#   generate    scripts/generate.sh --check    generated code is current
#   format      scripts/format.sh
#   analyze     scripts/analyze.sh, per package
#   test        scripts/test.sh, per package
#   changelog   scripts/changelog.sh
# graph and generate run first, one after the other, since the rest reads
# their output. format, analyze, test and changelog then share one parallel
# pool. Each failure is listed with the exact command that re-runs it.
#
# Options:
#   -p, --package PATH  Only this package (repeatable). Applies to generate,
#                       format, analyze and test.
#   -j, --jobs N        Max parallel tasks (default: CPU count; or CHECK_JOBS).
#   --fix               graph, generate, format: fix instead of failing.
#   --coverage          Collect test coverage (CI uses this).
#   --shard I/N         Only the I-th of N slices of the analyze/test tasks
#                       (used to split CI across machines).
#   --base REF          Changelog base ref (default: origin/master).
#   -h, --help          Show this help.
#
# Examples:
#   scripts/check.sh                                 # everything, like CI
#   scripts/check.sh analyze test -p packages/riverpod
#   scripts/check.sh graph generate format --fix     # fix what can be fixed

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"
# shellcheck source=lib/packages.sh
. "$SCRIPTS/lib/packages.sh"
# shellcheck source=lib/pool.sh
. "$SCRIPTS/lib/pool.sh"

steps=""
selected=""
fix=0
coverage=""
shard=""
base="origin/master"
while [ $# -gt 0 ]; do
  case "$1" in
    -p|--package) [ $# -ge 2 ] || die "$1 needs a path"
                  selected="$selected $(normalize "$2")"; shift 2 ;;
    -j|--jobs)    [ $# -ge 2 ] || die "$1 needs a number"; POOL_JOBS="$2"; shift 2 ;;
    --fix)        fix=1; shift ;;
    --coverage)   coverage="--coverage"; shift ;;
    --shard)      [ $# -ge 2 ] || die "$1 needs I/N"; shard="$2"; shift 2 ;;
    --base)       [ $# -ge 2 ] || die "$1 needs a ref"; base="$2"; shift 2 ;;
    -h|--help)    usage; exit 0 ;;
    all)          steps="$steps graph generate format analyze test changelog"; shift ;;
    graph|generate|format|analyze|test|changelog) steps="$steps $1"; shift ;;
    *)            die "unknown argument '$1' (see --help)" ;;
  esac
done
[ -z "$steps" ] && steps="graph generate format analyze test changelog"
has_step() { [[ " $steps " == *" $1 "* ]]; }

[[ "$POOL_JOBS" =~ ^[1-9][0-9]*$ ]] || die "--jobs must be a positive number"
if [ -n "$shard" ]; then
  if ! [[ "$shard" =~ ^([1-9][0-9]*)/([1-9][0-9]*)$ ]] ||
     [ "${BASH_REMATCH[1]}" -gt "${BASH_REMATCH[2]}" ]; then
    die "--shard must look like 2/3"
  fi
fi
# shellcheck disable=SC2086 # word splitting of the package list is intended
validate_packages $selected
command -v flutter >/dev/null || die "flutter is not on PATH (this repo pins its SDK in .fvmrc)"

# Keeps the lines of stdin that match -p (all of them without -p).
only_selected() {
  local p
  while read -r p; do
    [ -z "$selected" ] || [[ " $selected " == *" $p "* ]] && echo "$p"
  done
}
# Keeps the I-th of every N lines of stdin for --shard I/N.
only_shard() {
  if [ -z "$shard" ]; then cat; return; fi
  awk -v i="${shard%/*}" -v n="${shard#*/}" '(NR - 1) % n == i - 1'
}
flag() { [ "$fix" = 1 ] && echo "$1" || echo "$2"; }

echo "check.sh:${steps}${selected:+ | packages:$selected}${shard:+ | shard $shard} | $POOL_JOBS jobs"
pool_init

# One `pub get` up front (and global tools activated once), so the parallel
# scripts below never race on them.
if has_step graph || has_step generate || has_step format || has_step analyze || has_step test; then
  ensure_deps
fi
if has_step test && [ -n "$coverage" ]; then ensure_pub_global coverage coverage; fi

if has_step graph; then
  echo "==> graph"
  pool_inline "graph" "scripts/graph.sh $(flag "" --check)"
fi
if has_step generate; then
  echo "==> generate"
  pool_inline "generate" "scripts/generate.sh $(flag "" --check) -j $POOL_JOBS$selected"
fi

pool_steps=""
for s in format analyze test changelog; do has_step "$s" && pool_steps="$pool_steps $s"; done
if [ -n "$pool_steps" ]; then
  echo "==>$pool_steps"
  # Queued slowest-first: tests, then analysis, then the quick checks.
  if has_step test; then
    for p in $(ci_tested_packages | only_selected | only_shard); do
      pool_add "test $p" "scripts/test.sh ${coverage:+$coverage }$p"
    done
  fi
  if has_step analyze; then
    for p in $(ci_packages | only_selected | only_shard); do
      pool_add "analyze $p" "scripts/analyze.sh $p"
    done
  fi
  if has_step format; then
    # Without -p, format.sh's default list is exactly what CI formats.
    formatted=""
    [ -n "$selected" ] && formatted="$(ci_formatted_packages | only_selected | tr '\n' ' ')"
    if [ -z "$selected" ] || [ -n "$formatted" ]; then
      pool_add "format" "$(echo "scripts/format.sh $(flag --fix "") $formatted" | tr -s ' ' | sed 's/ $//')"
    fi
  fi
  has_step changelog && pool_add "changelog" "scripts/changelog.sh $base"
  pool_run
fi

pool_report
