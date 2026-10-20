#!/usr/bin/env bash
# Runs package tests, in parallel. Flutter packages use `flutter test`, others
# `dart test` (or scripts/coverage.sh with --coverage).
#
# Usage: scripts/test.sh [--coverage] [-j N] [PACKAGE...]
#   --coverage  Collect coverage into each package's coverage/ folder.
#   -j N        Max packages tested at once (default: CPU count).
#   PACKAGE     Package paths (default: every CI package with tests).

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"
# shellcheck source=lib/pool.sh
. "$SCRIPTS/lib/pool.sh"

coverage=""
paths=""
while [ $# -gt 0 ]; do
  case "$1" in
    --coverage) coverage="--coverage"; shift ;;
    -j) [ $# -ge 2 ] || die "-j needs a number"; POOL_JOBS="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    -*) die "unknown option '$1' (see --help)" ;;
    *) paths="$paths $(normalize "$1")"; shift ;;
  esac
done
[ -z "$paths" ] && paths="$(ci_tested_packages | tr '\n' ' ')"
# shellcheck disable=SC2086 # word splitting of the package list is intended
set -- $paths
validate_packages "$@"
ensure_deps

if [ $# -eq 1 ]; then
  runner="$(test_runner "$1")"
  [ "$runner" != none ] || { echo "$1 has no tests."; exit 0; }
  cd "$ROOT/$1" || exit 1
  # Where tests live is set by `paths` in dart_test.yaml, which `dart test`
  # reads. `flutter test` only looks in test/, so it is given those paths.
  # shellcheck disable=SC2046 # word splitting of the paths is intended
  set -- $(sed -n 's/^paths: *\[\(.*\)\]$/\1/p' dart_test.yaml 2>/dev/null | tr ',' ' ')
  case "$runner:$coverage" in
    chrome:*)           exec flutter test --no-pub --platform chrome "$@" ;;
    flutter:*)          exec flutter test --no-pub $coverage "$@" ;;
    dart:--coverage)    exec "$SCRIPTS/coverage.sh" ;;
    *)                  exec dart test ;;
  esac
fi
# Activate once here, rather than racing from parallel coverage.sh runs.
[ -n "$coverage" ] && ensure_pub_global coverage coverage
pool_init
for p in "$@"; do pool_add "test $p" "scripts/test.sh ${coverage:+$coverage }$p"; done
pool_run
pool_report
