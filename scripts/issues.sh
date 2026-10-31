#!/usr/bin/env bash
# Checks that every `// ignore` and TODO comment of the Dart files, and every
# TODO comment of the YAML files, links the GitHub issue that requires it, and
# that this issue is still open. Generated files, and the files that
# baselines/issues.yaml ignores or baselines, are exempt.
#
# The states of the issues are fetched in one request to the GitHub API,
# authenticated by GITHUB_TOKEN, GH_TOKEN or `gh auth token`. Locally, that
# part is skipped without a token.
#
# Usage: scripts/issues.sh

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

case "${1:-}" in
  "") ;;
  -h|--help) usage; exit 0 ;;
  *) die "unknown argument '$1' (see --help)" ;;
esac

ensure_deps
cd "$ROOT" || exit 1
exec dart run internal_lint:check_issues "$ROOT"
