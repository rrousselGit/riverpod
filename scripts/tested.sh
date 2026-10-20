#!/usr/bin/env bash
# Checks that every changed lib/**/x.dart comes with a change to its test,
# the lib/**/x_test.dart next to it.
#
# Usage: scripts/tested.sh [--base REF] [PACKAGE...]
#   --base REF  Ref to compare against (default: origin/master; fetched if
#               missing). Changes are taken from where the current branch
#               forked from REF up to the working tree, untracked files
#               included.
#   PACKAGE     Package paths (default: every workspace package).
#
# Exempt from the rule:
# - Changes that only touch comments or whitespace (docs, formatting), as
#   told by tools/code_changes, which compares unresolved ASTs.
# - Deleted files, tests themselves (*_test.dart), and generated files
#   (*.g.dart, *.freezed.dart, or a "GENERATED" header).
# Only files in a package's lib/ folder are considered.
#
# Also checks that every package with tests in lib/ lists lib in the `paths`
# of its dart_test.yaml, without which `dart test` would not run them.

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

base="origin/master"
paths=""
while [ $# -gt 0 ]; do
  case "$1" in
    --base) [ $# -ge 2 ] || die "$1 needs a ref"; base="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    -*) die "unknown option '$1' (see --help)" ;;
    *) paths="$paths $(normalize "$1")"; shift ;;
  esac
done
[ -z "$paths" ] && paths="$(ci_packages | tr '\n' ' ')"
# shellcheck disable=SC2086 # word splitting of the package list is intended
set -- $paths
validate_packages "$@"
cd "$ROOT" || exit 1

if ! git rev-parse --verify --quiet "$base" >/dev/null; then
  case "$base" in
    origin/*) git fetch --no-tags origin "${base#origin/}:refs/remotes/$base" || exit 1 ;;
    *) die "ref '$base' does not exist" ;;
  esac
fi
# Compare against the fork point, so commits that landed on the base since
# are not mistaken for changes of this branch. Shallow CI clones may not have
# it, in which case the base itself is the best guess.
from="$(git merge-base "$base" HEAD 2>/dev/null)" || from="$base"

# "<status>\t<path>" of every changed file, untracked ones as added.
changes="$(
  git diff --name-status --no-renames "$from" -- &&
    git ls-files --others --exclude-standard | awk '{ print "A\t" $0 }'
)" || die "could not list the changes since $base"

# Keeps the lines of stdin whose path is in the lib/ folder of a package
# given on the command line. Nested packages (such as packages/x/example)
# are their own packages, so the longest matching package path wins.
in_selected_lib() {
  awk -F '\t' -v selected="$*" -v all="$(ci_packages | tr '\n' ' ')" '
    BEGIN {
      n = split(all, known, " ")
      split(selected, s, " "); for (k in s) want[s[k]] = 1
    }
    {
      owner = ""
      for (k = 1; k <= n; k++) {
        p = known[k]
        if (index($2, p "/lib/") == 1 && length(p) > length(owner)) owner = p
      }
      if (owner != "" && (owner in want)) print
    }
  '
}

is_generated() {
  case "$1" in *.g.dart|*.freezed.dart) return 0 ;; esac
  head -n 5 "$1" 2>/dev/null | grep -q 'GENERATED'
}

lib_changes="$(printf '%s\n' "$changes" | in_selected_lib "$@")"
changed_paths="$(printf '%s\n' "$lib_changes" | cut -f 2)"
old_dir="$(mktemp -d)" || die "could not create a temporary folder"
trap 'rm -rf "$old_dir"' EXIT

# Files changed without their test. New files need one; modified files are
# compared with their previous version below, in one go.
missing=""
pairs=()
while IFS=$'\t' read -r status path; do
  [ -n "$path" ] || continue
  case "$status" in A|M|T) ;; *) continue ;; esac
  case "$path" in *_test.dart) continue ;; *.dart) ;; *) continue ;; esac
  [ -f "$path" ] || continue
  is_generated "$path" && continue
  test_file="${path%.dart}_test.dart"
  grep -Fqx "$test_file" <<<"$changed_paths" && continue
  if [ "$status" = A ]; then
    missing="$missing  $path -> $test_file
"
    continue
  fi
  old="$old_dir/${#pairs[@]}.dart"
  git show "$from:$path" >"$old" || die "could not read $path at $from"
  pairs+=("$old" "$path")
done <<<"$lib_changes"

# Changes that only touch comments or whitespace are exempt. code_changes
# compares the unresolved ASTs of both versions and prints the files whose
# code changed.
if [ ${#pairs[@]} -gt 0 ]; then
  ensure_deps
  code_changed="$(dart run tools/code_changes/bin/code_changes.dart "${pairs[@]}")" ||
    die "tools/code_changes failed"
  while read -r path; do
    [ -n "$path" ] || continue
    missing="$missing  $path -> ${path%.dart}_test.dart
"
  done <<<"$code_changed"
fi

# Tests in lib/ only run if dart_test.yaml says to look there: without it,
# `dart test` would silently skip them.
unconfigured=""
for p in "$@"; do
  [ -n "$(find "$p/lib" -name '*_test.dart' -print -quit 2>/dev/null)" ] || continue
  [[ " $(test_paths "$p") " == *" lib "* ]] && continue
  unconfigured="$unconfigured  $p/dart_test.yaml
"
done

status=0
if [ -n "$missing" ]; then
  printf 'These lib/ files changed without a change to their test (since %s):\n%s' "$base" "$missing" >&2
  printf 'Add or update the test next to each file. Comment-only changes are exempt.\n\n' >&2
  status=1
fi
if [ -n "$unconfigured" ]; then
  printf 'These packages have tests in lib/, but their dart_test.yaml does not list lib in `paths`:\n%s' "$unconfigured" >&2
  printf 'Add `paths: [test, lib]` to it (or `paths: [lib]` without a test/ folder).\n' >&2
  status=1
fi
[ "$status" = 0 ] && echo "Every changed lib/ file has its test updated, and lib/ tests are configured."
exit "$status"
