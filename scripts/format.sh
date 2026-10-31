#!/usr/bin/env bash
# Checks (or fixes) formatting with `dart format`.
#
# Usage: scripts/format.sh [--fix] [PACKAGE...]
#   --fix     Rewrite files instead of failing.
#   PACKAGE   Package paths (default: every package CI format-checks).

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

fix=0
paths=""
for arg in "$@"; do
  case "$arg" in
    --fix) fix=1 ;;
    -h|--help) usage; exit 0 ;;
    -*) die "unknown option '$arg' (see --help)" ;;
    *) paths="$paths $(normalize "$arg")" ;;
  esac
done
[ -z "$paths" ] && paths="$(ci_packages | tr '\n' ' ')"
# shellcheck disable=SC2086 # word splitting of the package list is intended
set -- $paths
validate_packages "$@"
ensure_deps
cd "$ROOT" || exit 1

if [ "$fix" = 1 ]; then
  dart format "$@"
else
  dart format --output=none --set-exit-if-changed "$@" || {
    echo
    echo "The files listed above are not formatted. Fix with: scripts/format.sh --fix"
    exit 1
  }
fi
