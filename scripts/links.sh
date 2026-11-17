#!/usr/bin/env bash
# Checks that the links of the Markdown and MDX files, and the URLs in the
# comments of the Dart files, are valid:
# - Paths are those of files of the repository or, in the docs of the
#   website, of its pages and static files. So are the URLs of riverpod.dev
#   and of the files of this repository on GitHub, which are checked against
#   the working copy.
# - What the components of the website link exists: the page and the heading
#   of <Link documentID="..." hash="..." />, the gist of <DartPad id="..." />.
# - #fragments are headings of the Markdown file they link.
# - Reference links, [text][label], are defined.
# - Other URLs exist: they are requested, and fail when their server answers
#   404 or 410, or when their host does not exist. Those that cannot be
#   verified, such as when a server is down or refuses scripts, are only
#   listed.
# Generated files, and what baselines/links.yaml ignores, are exempt.
#
# Usage: scripts/links.sh [--offline]
#   --offline   Do not request the URLs of other websites.

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

offline=""
case "${1:-}" in
  "") ;;
  --offline) offline="--offline" ;;
  -h|--help) usage; exit 0 ;;
  *) die "unknown argument '$1' (see --help)" ;;
esac

ensure_deps
cd "$ROOT" || exit 1
# shellcheck disable=SC2086 # empty when online
exec dart run repo_checks:check_links $offline "$ROOT"
