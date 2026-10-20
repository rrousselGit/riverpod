#!/usr/bin/env bash
# Runs package tests, in parallel. Flutter packages use `flutter test`, others
# `dart test` (or scripts/coverage.sh with --coverage).
# Tests are the *_test.dart files of test/, and those next to the code they
# test in lib/.
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
  cd "$ROOT/$1" || exit 1
  # Test runners only look in test/ by default, so the folders are explicit.
  dirs=()
  [ -d test ] && dirs+=(test)
  [ -n "$(find lib -name '*_test.dart' -print -quit 2>/dev/null)" ] && dirs+=(lib)
  [ ${#dirs[@]} -gt 0 ] || { echo "$1 has no tests."; exit 0; }
  case "$(test_runner "$1"):$coverage" in
    chrome:*)           exec flutter test --no-pub --platform chrome "${dirs[@]}" ;;
    flutter:*)          exec flutter test --no-pub $coverage "${dirs[@]}" ;;
    dart:--coverage)    exec "$SCRIPTS/coverage.sh" "${dirs[@]}" ;;
    *)                  exec dart test "${dirs[@]}" ;;
  esac
fi
# Activate once here, rather than racing from parallel coverage.sh runs.
[ -n "$coverage" ] && ensure_pub_global coverage coverage
pool_init
for p in "$@"; do pool_add "test $p" "scripts/test.sh ${coverage:+$coverage }$p"; done
pool_run
pool_report
