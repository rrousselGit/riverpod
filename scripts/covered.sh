#!/usr/bin/env bash
# Checks that the tests cover every changed line of a package's lib/ folder,
# using the coverage/lcov.info that `scripts/test.sh --coverage` left in it.
# Changes are taken from where the current branch forked from REF up to the
# working tree, untracked files included.
#
# A changed line fails the check when the coverage data lists it with no
# hits. Lines the data does not list (comments, declarations, blank lines) are
# not code that runs, and pass. A changed file missing from the data, which no
# test loaded, fails too.
#
# Exempt are example packages (see is_example), packages tested in a browser
# (no coverage is collected there), tests, generated files, and files with
# only directives (export/import/library/part).
#
# Usage: scripts/covered.sh [--base REF] PACKAGE...
#   --base REF  Ref to compare against (default: origin/master; fetched if
#               missing).
#   PACKAGE     Package paths, whose tests ran with --coverage.

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
[ -n "$paths" ] || die "no package given (see --help)"
# shellcheck disable=SC2086 # word splitting of the package list is intended
set -- $paths
validate_packages "$@"
cd "$ROOT" || exit 1

from="$(fork_point "$base")" || exit

# "<path>\t<line>" of every added or changed line of the package's lib/
# folder. Every line of an untracked file counts as added.
changed_lines() {
  {
    git diff -U0 --no-renames --no-color "$from" -- "$1/lib" | awk '
      /^\+\+\+ /  { path = substr($0, 5); sub(/^b\//, "", path); next }
      /^@@ /      {
        # @@ -a,b +start,count @@
        split($3, range, ",")
        start = substr(range[1], 2)
        count = (2 in range) ? range[2] : 1
        for (k = 0; k < count; k++) print path "\t" start + k
      }
    '
    git ls-files --others --exclude-standard -- "$1/lib" |
      while IFS= read -r path; do awk -v p="$path" '{ print p "\t" NR }' "$path"; done
  } | awk -F '\t' '$1 ~ /\.dart$/ && $1 !~ /_test\.dart$/'
}

status=0
for package in "$@"; do
  is_example "$package" && continue
  [ "$(test_runner "$package")" = chrome ] && continue
  lines="$(changed_lines "$package")" || die "could not list the changes since $base"
  [ -n "$lines" ] || continue

  # Drops generated and directives-only files, which need no coverage.
  kept=""
  while IFS= read -r path; do
    [ -f "$path" ] || continue
    is_generated "$path" && continue
    is_directives_only "$path" && continue
    kept="$kept$path
"
  done < <(cut -f 1 <<<"$lines" | sort -u)
  [ -n "$kept" ] || continue
  lines="$(awk -F '\t' 'NR == FNR { keep[$0] = 1; next } $1 in keep' <(printf '%s' "$kept") - <<<"$lines")"

  lcov="$package/coverage/lcov.info"
  if [ ! -f "$lcov" ]; then
    printf '%s has changes but no coverage data. Collect it with: scripts/test.sh --coverage %s\n\n' \
      "$package" "$package" >&2
    status=1
    continue
  fi

  # lcov paths are either absolute or relative to the package; both become
  # relative to the repo root. A file may be listed more than once (one per
  # isolate), so a line is covered if any listing hit it.
  # The report is told apart by name, as NR == FNR would also match the
  # changed lines if it were empty.
  report="$(awk -F '\t' -v root="$ROOT/" -v package="$package/" '
    FILENAME == ARGV[1] {
      if ($0 ~ /^SF:/) {
        file = substr($0, 4)
        if (index(file, root) == 1) file = substr(file, length(root) + 1)
        else file = package file
        loaded[file] = 1
      } else if ($0 ~ /^DA:/) {
        split(substr($0, 4), da, ",")
        listed[file "\t" da[1]] = 1
        if (da[2] > 0) hit[file "\t" da[1]] = 1
      }
      next
    }
    !($1 in loaded) { if (!($1 in unloaded)) { unloaded[$1] = 1; print "  " $1 " (no test loads it)" } next }
    ($0 in listed) && !($0 in hit) { uncovered[$1] = uncovered[$1] " " $2 }
    END {
      for (file in uncovered) {
        # Turns "3 4 5 9" into "3-5, 9".
        n = split(substr(uncovered[file], 2), l, " ")
        out = ""
        for (k = 1; k <= n; k = j + 1) {
          for (j = k; j < n && l[j + 1] == l[j] + 1; j++) {}
          out = out (out == "" ? "" : ", ") (j > k ? l[k] "-" l[j] : l[k])
        }
        print "  " file ":" out
      }
    }
  ' "$lcov" - <<<"$lines" | sort)"
  if [ -n "$report" ]; then
    printf 'These changed lines of %s are not covered by its tests (since %s):\n%s\n' \
      "$package" "$base" "$report" >&2
    printf 'Add tests that run them. Re-check with: scripts/test.sh --coverage %s && scripts/covered.sh --base %s %s\n\n' \
      "$package" "$base" "$package" >&2
    status=1
  fi
done
[ "$status" = 0 ] && echo "Every changed lib/ line is covered by tests."
exit "$status"
