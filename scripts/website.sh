#!/usr/bin/env bash
# Regenerates the files the website generates from the docs and examples, but
# commits: website/src/documents_meta.js (titles and outdated translations)
# and website/src/dartpad_examples.js (the examples embedded with DartPad).
# `npm start` and `npm run build` regenerate them too.
#
# Usage: scripts/website.sh [--check]
#   --check   Don't write. Fail if a committed file is stale.

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

check=""
for arg in "$@"; do
  case "$arg" in
    --check) check="--check" ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument '$arg' (see --help)" ;;
  esac
done

cd "$ROOT/website" || exit 1
[ -d node_modules ] || npm ci --no-audit --no-fund || exit 1
status=0
node meta_generator.js $check || status=1
node dartpad_generator.js $check || status=1
exit "$status"
