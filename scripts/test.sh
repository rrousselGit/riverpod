#!/usr/bin/env bash
# Runs package tests, in parallel. Flutter packages use `flutter test`, others
# `dart test` (or scripts/coverage.sh with --coverage).
#
# Usage: scripts/test.sh [--coverage] [-j N] [PACKAGE...]
#   --coverage  Collect coverage into each package's coverage/ folder.
#   -j N        Max packages tested at once (default: CPU count).
#   PACKAGE     Package paths (default: every CI package with a test/ folder).

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
  cd "$ROOT/$1" || exit 1
  [ -d test ] || { echo "$1 has no tests."; exit 0; }
  # A package that holds the tests of another reports that other's coverage.
  of="$(tests_of "$1")"
  # Tests that a plain `dart test` skips, such as slow ones, run here through
  # the package's `check` preset, if its dart_test.yaml defines one.
  preset=""
  awk '/^presets:/ { p = 1; next } /^[^ #]/ { p = 0 } p && /^  check:/ { f = 1 } END { exit !f }' \
    dart_test.yaml 2>/dev/null && preset="-P check"
  # shellcheck disable=SC2086 # $preset is empty or a flag and its value
  case "$(test_runner "$1"):$coverage" in
    chrome:*)           exec flutter test --no-pub --platform chrome $preset ;;
    flutter:--coverage) exec flutter test --no-pub --coverage ${of:+"--coverage-package=^$of\$"} $preset ;;
    flutter:*)          exec flutter test --no-pub $preset ;;
    dart:--coverage)    exec "$SCRIPTS/coverage.sh" ${of:+"--scope-output=$of"} ${preset:+-- $preset} ;;
    *)                  exec dart test $preset ;;
  esac
fi
# Activate once here, rather than racing from parallel coverage.sh runs.
[ -n "$coverage" ] && ensure_pub_global coverage coverage
pool_init
for p in "$@"; do pool_add "test $p" "scripts/test.sh ${coverage:+$coverage }$p"; done
pool_run
pool_report
