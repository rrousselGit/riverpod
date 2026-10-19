#!/usr/bin/env bash
# Runs `flutter analyze` on packages, in parallel.
#
# Usage: scripts/analyze.sh [-j N] [PACKAGE...]
#   -j N      Max parallel analyzers (default: CPU count; each uses a lot of
#             RAM, so lower it on small machines).
#   PACKAGE   Package paths (default: every package CI analyzes).

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"
# shellcheck source=lib/packages.sh
. "$SCRIPTS/lib/packages.sh"
# shellcheck source=lib/pool.sh
. "$SCRIPTS/lib/pool.sh"

paths=""
while [ $# -gt 0 ]; do
  case "$1" in
    -j) [ $# -ge 2 ] || die "-j needs a number"; POOL_JOBS="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    -*) die "unknown option '$1' (see --help)" ;;
    *) paths="$paths $(normalize "$1")"; shift ;;
  esac
done
[ -z "$paths" ] && paths="$(ci_packages | tr '\n' ' ')"
# shellcheck disable=SC2086 # word splitting of the package list is intended
set -- $paths
validate_packages "$@"
ensure_deps

if [ $# -eq 1 ]; then
  cd "$ROOT/$1" && exec flutter analyze --no-pub
fi
pool_init
for p in "$@"; do pool_add "analyze $p" "scripts/analyze.sh $p"; done
pool_run
pool_report
