#!/usr/bin/env bash
# scripts/check.sh — the single source of truth for Riverpod's CI checks.
#
# CI only calls this script, so running it locally gives the same verdict as
# CI. Independent work runs in parallel; failing tasks print their full log at
# the end, with the command to re-run just that task.
#
# Usage: scripts/check.sh [options] [step...]
#
# Steps (default: all of them). Whatever order they are given in, they run as:
#   generate    Run build_runner everywhere and fail if any file changed.
#   format      `dart format` check.
#   analyze     `flutter analyze` per package.
#   test        Tests per package (`flutter test` or `dart test`).
#   changelog   `semantic_changelog check` against --base.
# generate runs first, alone, since everything else reads generated code;
# format, analyze, test and changelog then share one parallel pool.
#
# Options:
#   -p, --package PATH  Only check this package (repeatable), e.g.
#                       -p packages/riverpod. Applies to generate, format,
#                       analyze and test.
#   -j, --jobs N        Max parallel tasks (default: number of CPUs; or set
#                       CHECK_JOBS). Lower it if analysis servers exhaust RAM.
#   --fix               format: rewrite files instead of failing.
#                       generate: keep regenerated files, don't fail.
#   --coverage          Collect coverage while testing (CI uses this).
#   --shard I/N         Only run the I-th of N slices of the per-package
#                       analyze/test tasks (used to split CI across machines).
#   --base REF          Changelog base ref (default: origin/master).
#   --no-pub-get        Skip the initial `flutter pub get`.
#   -h, --help          Show this help.
#
# Examples:
#   scripts/check.sh                                # everything, like CI
#   scripts/check.sh analyze test -p packages/riverpod
#   scripts/check.sh format generate --fix          # fix what can be fixed

# Tasks are dispatched indirectly via "task_$kind".
# shellcheck disable=SC2317
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/scripts/check.sh"
cd "$ROOT" || exit 1

# ---------------------------------------------------------------------------
# Packages checked by format/analyze/test. One per line:
#   <path> <format|noformat> <flutter|dart>
# The last column picks the test runner. Packages without a test/ folder are
# simply not tested. The riverpod_analyzer_utils*/riverpod_lint* packages were
# never format-checked by the old riverpod_lint.yml and always used `dart test`,
# so that is preserved here.
#
# Code generation is not limited to this list: `generate` runs in every
# package whose pubspec.yaml mentions build_runner.
# ---------------------------------------------------------------------------
PACKAGES="
packages/riverpod                                  format   dart
packages/riverpod_generator                        format   dart
packages/riverpod_lint_flutter_test                noformat dart
packages/riverpod_analyzer_utils_tests             noformat dart
packages/flutter_riverpod                          format   flutter
packages/hooks_riverpod                            format   flutter
packages/riverpod_generator/integration/build_yaml format   dart
packages/riverpod_annotation                       format   dart
packages/riverpod_analyzer_utils                   noformat dart
packages/riverpod_lint                             noformat dart
packages/riverpod/example                          format   dart
packages/flutter_riverpod/example                  format   flutter
packages/hooks_riverpod/example                    format   flutter
examples/counter                                   format   flutter
examples/marvel                                    format   flutter
examples/pub                                       format   flutter
examples/random_number                             format   flutter
examples/stackoverflow                             format   flutter
examples/todos                                     format   flutter
"
# (Listed roughly slowest-first, so the parallel pool starts long tasks early.)

# Code generation must run in this order before everything else: other
# packages' builders depend on these packages' generated code.
GENERATE_FIRST="packages/riverpod_analyzer_utils packages/riverpod"

# Settings. Exported so the parallel workers (this script re-invoked) see them.
FIX="${CHECK_FIX:-0}"
COVERAGE="${CHECK_COVERAGE:-0}"
BASE="${CHECK_BASE:-origin/master}"
LOG_DIR="${CHECK_LOG_DIR:-}"
JOBS="${CHECK_JOBS:-}"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
die() { printf 'check.sh: %s\n' "$*" >&2; exit 2; }
usage() { sed -n '2,/^$/s/^# \{0,1\}//p' "$SCRIPT"; }
in_ci() { [ -n "${GITHUB_ACTIONS:-}" ]; }

cpu_count() {
  nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4
}

# Strip "./" and trailing "/" so "-p ./packages/riverpod/" works.
normalize() {
  local p="${1#./}"
  while [ "${p%/}" != "$p" ]; do p="${p%/}"; done
  printf '%s' "$p"
}

table_paths() { printf '%s\n' "$PACKAGES" | awk 'NF { print $1 }'; }
table_field() { printf '%s\n' "$PACKAGES" | awk -v p="$1" -v f="$2" '$1 == p { print $f }'; }

# Every package that uses build_runner, as generate.sh used to find them.
generator_paths() {
  find . -name pubspec.yaml \
    -not -path '*/node_modules/*' -not -path '*/.dart_tool/*' \
    -not -path '*/build/*' -print0 2>/dev/null |
    xargs -0 grep -l build_runner 2>/dev/null |
    sed -e 's#^\./##' -e 's#/pubspec\.yaml$##' | sort
}

# Apply the -p filter to a list of paths on stdin.
filter_selected() {
  local p
  while read -r p; do
    if [ -z "$PKG_FILTER" ] || [[ " $PKG_FILTER " == *" $p "* ]]; then
      echo "$p"
    fi
  done
}

# Apply --shard I/N to a list on stdin (round-robin, so slow packages spread).
filter_shard() {
  if [ -z "$SHARD" ]; then cat; return; fi
  awk -v i="${SHARD%/*}" -v n="${SHARD#*/}" '(NR - 1) % n == i - 1'
}

slug() { printf '%s__%s' "$1" "$2" | tr '/' '_'; }

# The tree a `git add -A` would produce right now, without touching the real
# index. Comparing it before and after generation detects modified, new and
# deleted files, while ignoring changes the working copy already had.
snapshot_tree() {
  local idx="$LOG_DIR/snapshot.index" real
  real="$(git rev-parse --git-path index)"
  if [ -f "$real" ]; then cp "$real" "$idx"; else rm -f "$idx"; fi
  GIT_INDEX_FILE="$idx" git add -A . && GIT_INDEX_FILE="$idx" git write-tree
}

pub_global_has() {
  local list
  list="$(dart pub global list 2>/dev/null)"
  grep -q "^$1 " <<<"$list"
}

# ---------------------------------------------------------------------------
# Tasks. Each one runs in its own process with cwd = repo root and its output
# captured to a log file. Exit status = pass/fail.
# ---------------------------------------------------------------------------
task_generate() {
  cd "$ROOT/$1" && dart run build_runner build --delete-conflicting-outputs
}

task_format() {
  # shellcheck disable=SC2046 # word splitting of the path list is intended
  set -- $(table_paths | filter_selected | while read -r q; do
    [ "$(table_field "$q" 2)" = format ] && echo "$q"; done)
  [ $# -eq 0 ] && { echo "No packages to format."; return 0; }
  if [ "$FIX" = 1 ]; then
    dart format "$@"
  else
    dart format --output=none --set-exit-if-changed "$@" || {
      echo
      echo "The files listed above are not formatted."
      echo "Fix with: scripts/check.sh format --fix"
      return 1
    }
  fi
}

task_analyze() {
  cd "$ROOT/$1" && flutter analyze --no-pub
}

task_test() {
  local runner
  runner="$(table_field "$1" 3)"
  cd "$ROOT/$1" || return 1
  case "$runner:$COVERAGE" in
    flutter:1) flutter test --no-pub --coverage ;;
    flutter:0) flutter test --no-pub ;;
    dart:1)    dart pub global run coverage:test_with_coverage ;;
    dart:0)    dart test ;;
    *)         echo "Unknown test runner '$runner' for $1"; return 1 ;;
  esac
}

task_changelog() {
  if ! git rev-parse --verify --quiet "$BASE" >/dev/null; then
    case "$BASE" in
      origin/*) git fetch --no-tags origin "${BASE#origin/}:refs/remotes/$BASE" || return 1 ;;
      *) echo "Base ref '$BASE' does not exist."; return 1 ;;
    esac
  fi
  dart pub global run semantic_changelog check "$BASE"
}

# Worker entry point: `check.sh __task <kind> <package>`.
run_task() {
  local kind="$1" pkg="$2" name log start status secs mark
  name="$(slug "$kind" "$pkg")"
  log="$LOG_DIR/$name.log"
  start=$(date +%s)
  ( "task_$kind" "$pkg" ) >"$log" 2>&1 </dev/null
  status=$?
  echo "$status" >"$LOG_DIR/$name.status"
  secs=$(( $(date +%s) - start ))
  if [ "$status" -eq 0 ]; then mark="ok  "; else mark="FAIL"; fi
  if [ "$pkg" = - ]; then
    printf '  %s %s (%ss)\n' "$mark" "$kind" "$secs"
  else
    printf '  %s %-9s %s (%ss)\n' "$mark" "$kind" "$pkg" "$secs"
  fi
  return 0  # keep xargs scheduling the remaining tasks
}

# Run "<kind> <package>" lines from stdin, up to $JOBS at a time.
run_pool() {
  local tasks
  tasks="$(cat)"
  [ -z "$tasks" ] && return 0
  printf '%s\n' "$tasks" >>"$LOG_DIR/tasks"
  printf '%s\n' "$tasks" | xargs -n 2 -P "$JOBS" "$SCRIPT" __task
}

# Prints the failed "<kind> <package>" lines among those given on stdin.
failed_tasks() {
  local kind pkg st
  while read -r kind pkg; do
    st="$(cat "$LOG_DIR/$(slug "$kind" "$pkg").status" 2>/dev/null || echo 1)"
    [ "$st" != 0 ] && echo "$kind $pkg"
  done
}

rerun_hint() {
  case "$1" in
    format|changelog) echo "scripts/check.sh $1" ;;
    *) echo "scripts/check.sh $1 -p $2" ;;
  esac
}

# ---------------------------------------------------------------------------
# Steps
# ---------------------------------------------------------------------------
step_generate() {
  local before after p first rest selected
  echo "==> generate"
  before="$(snapshot_tree)" || die "could not snapshot the working tree"

  # Ordered stages first, then everything else in parallel.
  selected="$(generator_paths | filter_selected)"
  for first in $GENERATE_FIRST; do
    grep -qx "$first" <<<"$selected" || continue
    echo "generate $first" | run_pool
    if [ -n "$(echo "generate $first" | failed_tasks)" ]; then
      echo "  (stopping: later generators depend on $first)"
      return 1
    fi
  done
  rest="$(printf '%s\n' "$selected" | while read -r p; do
    [[ " $GENERATE_FIRST " == *" $p "* ]] || echo "generate $p"; done)"
  printf '%s\n' "$rest" | sed '/^$/d' | run_pool
  [ -n "$(sed -n '/^generate /p' "$LOG_DIR/tasks" | failed_tasks)" ] && return 1

  after="$(snapshot_tree)" || die "could not snapshot the working tree"
  if [ "$before" = "$after" ]; then
    echo "  Generated code is up to date."
    return 0
  fi
  echo
  echo "Code generation changed these files:"
  git diff --stat "$before" "$after" | sed 's/^/  /'
  if [ "$FIX" = 1 ]; then
    echo "(kept, because of --fix)"
    return 0
  fi
  local name
  name="$(slug generate stale)"
  {
    echo "Generated files were out of date. They have now been regenerated"
    echo "in your working copy: review and commit them."
    echo
    git diff "$before" "$after"
  } >"$LOG_DIR/$name.log"
  echo 1 >"$LOG_DIR/$name.status"
  echo "generate stale" >>"$LOG_DIR/tasks"
  return 1
}

step_pool() {
  local p tasks=""
  echo "==> ${POOL_STEPS# }"
  if [[ " $POOL_STEPS " == *" test "* ]]; then
    # Drop packages without tests before sharding, so shards stay balanced.
    for p in $(table_paths | filter_selected | while read -r q; do
                 [ -d "$q/test" ] && echo "$q"; done | filter_shard); do
      tasks="$tasks
test $p"
    done
  fi
  if [[ " $POOL_STEPS " == *" analyze "* ]]; then
    for p in $(table_paths | filter_selected | filter_shard); do
      tasks="$tasks
analyze $p"
    done
  fi
  [[ " $POOL_STEPS " == *" format "* ]] && tasks="$tasks
format -"
  [[ " $POOL_STEPS " == *" changelog "* ]] && tasks="$tasks
changelog -"
  printf '%s\n' "$tasks" | sed '/^$/d' | run_pool
}

report() {
  local failed kind pkg log total nfailed
  total="$(sed '/^$/d' "$LOG_DIR/tasks" 2>/dev/null | wc -l | tr -d ' ')"
  failed="$(failed_tasks <"$LOG_DIR/tasks" 2>/dev/null)"
  nfailed="$(grep -c . <<<"$failed")"
  echo
  if [ "$nfailed" = 0 ]; then
    echo "All $total tasks passed in $(( $(date +%s) - START ))s."
    return 0
  fi
  while read -r kind pkg; do
    [ -z "$kind" ] && continue
    log="$LOG_DIR/$(slug "$kind" "$pkg").log"
    if [ "$pkg" = - ]; then pkg=""; else pkg=" $pkg"; fi
    if in_ci; then
      echo "::error title=$kind$pkg failed::Re-run locally with: $(rerun_hint "$kind" "${pkg# }")"
      echo "::group::Log: $kind$pkg"
    fi
    echo "──── FAILED: $kind$pkg ────"
    cat "$log"
    in_ci && echo "::endgroup::"
    echo
  done <<<"$failed"
  echo "$nfailed of $total tasks failed in $(( $(date +%s) - START ))s:"
  while read -r kind pkg; do
    [ -z "$kind" ] && continue
    [ "$kind" = generate ] && [ "$pkg" = stale ] && {
      echo "  generate: committed files are stale  → scripts/check.sh generate"; continue; }
    [ "$pkg" = - ] && pkg=""
    printf '  %-9s %-50s → %s\n' "$kind" "$pkg" "$(rerun_hint "$kind" "$pkg")"
  done <<<"$failed"
  echo "Logs: $LOG_DIR"
  return 1
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
if [ "${1:-}" = __task ]; then
  shift
  PKG_FILTER="${CHECK_PKG_FILTER:-}"
  run_task "$@"
  exit 0
fi

STEPS=""
PKG_FILTER=""
SHARD=""
PUB_GET=1
while [ $# -gt 0 ]; do
  case "$1" in
    -p|--package) [ $# -ge 2 ] || die "$1 needs a path"
                  PKG_FILTER="$PKG_FILTER $(normalize "$2")"; shift 2 ;;
    -j|--jobs)    [ $# -ge 2 ] || die "$1 needs a number"; JOBS="$2"; shift 2 ;;
    --fix)        FIX=1; shift ;;
    --coverage)   COVERAGE=1; shift ;;
    --shard)      [ $# -ge 2 ] || die "$1 needs I/N"; SHARD="$2"; shift 2 ;;
    --base)       [ $# -ge 2 ] || die "$1 needs a ref"; BASE="$2"; shift 2 ;;
    --no-pub-get) PUB_GET=0; shift ;;
    -h|--help)    usage; exit 0 ;;
    all)          STEPS="$STEPS generate format analyze test changelog"; shift ;;
    generate|format|analyze|test|changelog) STEPS="$STEPS $1"; shift ;;
    *)            die "unknown argument '$1' (see --help)" ;;
  esac
done
[ -z "$STEPS" ] && STEPS="generate format analyze test changelog"
has_step() { [[ " $STEPS " == *" $1 "* ]]; }

[ -z "$JOBS" ] && JOBS="$(cpu_count)"
[[ "$JOBS" =~ ^[1-9][0-9]*$ ]] || die "--jobs must be a positive number"
if [ -n "$SHARD" ]; then
  if ! [[ "$SHARD" =~ ^([1-9][0-9]*)/([1-9][0-9]*)$ ]] ||
     [ "${BASH_REMATCH[1]}" -gt "${BASH_REMATCH[2]}" ]; then
    die "--shard must look like 2/3"
  fi
fi

# Reject unknown packages early, listing the valid ones.
KNOWN="$( { table_paths; generator_paths; } | sort -u)"
for p in $PKG_FILTER; do
  grep -qx "$p" <<<"$KNOWN" || die "unknown package '$p'. Known packages:
$(printf '%s\n' "$KNOWN" | sed 's/^/  /')"
done

command -v flutter >/dev/null || die "flutter is not on PATH (this repo uses the SDK pinned in .fvmrc)"
command -v dart >/dev/null || die "dart is not on PATH"

if [ -z "$LOG_DIR" ]; then
  LOG_DIR="$(mktemp -d "${TMPDIR:-/tmp}/riverpod-check.XXXXXX")" || die "mktemp failed"
fi
: >"$LOG_DIR/tasks"
export CHECK_FIX="$FIX" CHECK_COVERAGE="$COVERAGE" CHECK_BASE="$BASE" \
       CHECK_LOG_DIR="$LOG_DIR" CHECK_PKG_FILTER="$PKG_FILTER"
START=$(date +%s)

echo "check.sh: steps:${STEPS}${PKG_FILTER:+ | packages:$PKG_FILTER}${SHARD:+ | shard $SHARD} | $JOBS jobs"

# Bootstrap. One `pub get` at the root resolves the whole pub workspace; tasks
# then pass --no-pub so parallel runs never race on dependency resolution.
if [ "$PUB_GET" = 1 ] && { has_step generate || has_step format || has_step analyze || has_step test; }; then
  echo "==> flutter pub get"
  flutter pub get >"$LOG_DIR/pub_get.log" 2>&1 || {
    cat "$LOG_DIR/pub_get.log"; die "flutter pub get failed"; }
fi
# Global tools are activated once, up front, never concurrently by workers.
if has_step test && [ "$COVERAGE" = 1 ] && ! pub_global_has coverage; then
  dart pub global activate coverage >/dev/null || die "could not activate coverage"
fi
if has_step changelog && ! pub_global_has semantic_changelog; then
  dart pub global activate -s git https://github.com/rrousselGit/semantic_changelog \
    >/dev/null || die "could not activate semantic_changelog"
fi

# generate runs alone first: every other step reads the generated code.
gen_ok=1
if has_step generate; then
  step_generate || gen_ok=0
fi

POOL_STEPS=""
for s in format analyze test changelog; do has_step "$s" && POOL_STEPS="$POOL_STEPS $s"; done
if [ -n "$POOL_STEPS" ]; then
  step_pool
fi

report
status=$?
[ "$gen_ok" = 0 ] && status=1
exit "$status"
