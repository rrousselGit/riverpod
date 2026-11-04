#!/usr/bin/env bash
# Prints the paths of the packages that the changes since a ref may affect:
# those holding a changed file, and every package that depends on them, in
# any way (see package_graph.yaml). A change outside every package, or to the
# analyzer plugins and the tools that check every package, affects them all;
# one to Markdown files or GitHub templates affects none.
# `scripts/check.sh --affected` checks only these packages, as CI does on pull
# requests.
#
# Usage: scripts/affected.sh [--base REF] [--skipped]
#   --base REF  Ref to compare against (default: origin/master; fetched if
#               missing). Changes are taken from where the current branch
#               forked from REF up to the working tree, untracked files
#               included.
#   --skipped   Print the other packages instead: those no change affects.

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

base="origin/master"
skipped=0
while [ $# -gt 0 ]; do
  case "$1" in
    --base) [ $# -ge 2 ] || die "$1 needs a ref"; base="$2"; shift 2 ;;
    --skipped) skipped=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument '$1' (see --help)" ;;
  esac
done

affected="$(affected_packages "$base")" || exit
if [ "$skipped" = 1 ]; then
  ci_packages | grep -Fxv -f <(printf '%s\n' "$affected")
else
  [ -z "$affected" ] || printf '%s\n' "$affected"
fi
exit 0
