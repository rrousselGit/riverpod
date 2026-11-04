#!/usr/bin/env bash
# Checks that every changed lib/**/x.dart comes with a change to its test:
# test/**/x_test.dart, at the same path relative to test/ as the file is
# relative to lib/ (lib/src/foo.dart -> test/src/foo_test.dart).
# Also checks, on the whole tree rather than the changes, that:
# - Every lib/**/x.dart has a test/**/x_test.dart. Exempt are example
#   packages (see is_example), generated files, files with only directives
#   (export/import/library/part, such as barrel files), and the files listed
#   in baselines/untested.txt: the files that had no test when this check was
#   added. That list may only shrink: an entry whose file now has a test, or
#   no longer exists, fails the check too.
# - The reverse holds for test/src: every test/src/**/x_test.dart has a
#   lib/src/**/x.dart.
# And, on the changes, that packages with a test/src folder get no new test
# outside of it, except the tests of lib/ files outside lib/src (public
# entry points), test/meta_test.dart and test/misc_test.dart.
#
# Lints are tested through fixtures instead (see fixtures_of): the test of
# riverpod_lint/lib/src/lints/x.dart may also be
# riverpod_lint_flutter_test/test/lints/x.dart, its goldens (x.*), or the
# files of a test/lints/x/ folder.
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
# The rule is a proxy for "the change is tested", so it can be wrong: when
# other tests already cover a change, an admin can merge despite it. The
# script says so, and asks not to write a test just to pass. The other checks
# cannot be bypassed.

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

from="$(fork_point "$base")" || exit

# Prints the fixtures that test REL, a path relative to lib/ of the package
# at PATH, for lib/ files tested through fixtures rather than x_test.dart
# files: a file (whose goldens, <name>.*, count too) and a folder, ending with
# /, any file of which counts.
fixtures_of() {
  case "$1:$2" in
    packages/riverpod_lint:src/lints/*.dart)
      local name="${2#src/lints/}"
      name="${name%.dart}"
      echo "packages/riverpod_lint_flutter_test/test/lints/$name.dart"
      echo "packages/riverpod_lint_flutter_test/test/lints/$name/"
      ;;
  esac
}

# Prints the tests that may test REL, a path relative to lib/ of the package
# at PATH: <package>/test/<rel>_test.dart, then its fixtures.
tests_for() {
  echo "$1/test/${2%.dart}_test.dart"
  fixtures_of "$1" "$2"
}

# Prints the paths of stdin that are, or belong to, one of the TESTS (as
# printed by tests_for).
in_tests() {
  # Through the environment, as awk -v rejects newlines on macOS.
  TESTS="$1" awk '
    BEGIN { n = split(ENVIRON["TESTS"], t, "\n") }
    {
      for (k = 1; k <= n; k++) {
        if ($0 == t[k]) { print; next }
        # A fixture folder, or the goldens of a fixture file.
        prefix = t[k]
        if (prefix ~ /[.]dart$/ && prefix !~ /_test[.]dart$/) sub(/dart$/, "", prefix)
        else if (prefix !~ /\/$/) continue
        if (index($0, prefix) == 1) { print; next }
      }
    }
  '
}

# Joins TESTS (as printed by tests_for) with " or ".
or_list() { awk 'NR > 1 { printf " or " } { printf "%s", $0 }' <<<"$1"; }

# "<status>\t<path>" of every changed file, untracked ones as added.
changes="$(
  git diff --name-status --no-renames "$from" -- &&
    git ls-files --others --exclude-standard | awk '{ print "A\t" $0 }'
)" || die "could not list the changes since $base"

# Keeps the lines of stdin whose path is in the FOLDER folder (lib, test) of
# a PACKAGE given on the command line. Nested packages (such as
# packages/x/example) are their own packages, so the longest matching package
# path wins.
# Usage: in_selected FOLDER PACKAGE...
in_selected() {
  local folder="$1"
  shift
  awk -F '\t' -v folder="$folder" -v selected="$*" -v all="$(ci_packages | tr '\n' ' ')" '
    BEGIN {
      n = split(all, known, " ")
      split(selected, s, " "); for (k in s) want[s[k]] = 1
    }
    {
      owner = ""
      for (k = 1; k <= n; k++) {
        p = known[k]
        if (index($2, p "/" folder "/") == 1 && length(p) > length(owner)) owner = p
      }
      # Appends the package path, which locates the test of the file.
      if (owner != "" && (owner in want)) print $0 "\t" owner
    }
  '
}

lib_changes="$(printf '%s\n' "$changes" | in_selected lib "$@")"
changed_paths="$(printf '%s\n' "$changes" | cut -f 2)"
old_dir="$(mktemp -d)" || die "could not create a temporary folder"
trap 'rm -rf "$old_dir"' EXIT

# Files changed without their test. New files need one; modified files are
# compared with their previous version below, in one go.
missing=""
pairs=()
tests=""
while IFS=$'\t' read -r status path package; do
  [ -n "$path" ] || continue
  case "$status" in A|M|T) ;; *) continue ;; esac
  case "$path" in *_test.dart) continue ;; *.dart) ;; *) continue ;; esac
  [ -f "$path" ] || continue
  is_generated "$path" && continue
  # <package>/lib/<rel>.dart -> <package>/test/<rel>_test.dart, or fixtures
  rel="${path#"$package/lib/"}"
  candidates="$(tests_for "$package" "$rel")"
  [ -n "$(in_tests "$candidates" <<<"$changed_paths")" ] && continue
  test_file="$(or_list "$candidates")"
  if [ "$status" = A ]; then
    missing="$missing  $path -> $test_file
"
    continue
  fi
  old="$old_dir/${#pairs[@]}.dart"
  git show "$from:$path" >"$old" || die "could not read $path at $from"
  pairs+=("$old" "$path")
  tests="$tests$path	$test_file
"
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
    test_file="$(awk -F '\t' -v p="$path" '$1 == p { print $2 }' <<<"$tests")"
    missing="$missing  $path -> $test_file
"
  done <<<"$code_changed"
fi

# Tests in test/src without a file to test: <package>/test/src/<rel>_test.dart
# -> <package>/lib/src/<rel>.dart.
orphans=""
for package in "$@"; do
  [ -d "$package/test/src" ] || continue
  while IFS= read -r test_file; do
    rel="${test_file#"$package/test/"}"
    lib_file="$package/lib/${rel%_test.dart}.dart"
    [ -f "$lib_file" ] || orphans="$orphans  $test_file -> $lib_file
"
  done < <(find "$package/test/src" -name '*_test.dart' | sort)
done

# New tests outside test/src, in packages that mirror lib/src in test/src.
# Tests of lib/ files outside lib/src mirror those files instead, and
# meta_test.dart and misc_test.dart, which test no file in particular, may
# stay at the root of test/.
misplaced=""
while IFS=$'\t' read -r status path package; do
  [ "$status" = A ] || continue
  case "$path" in *_test.dart) ;; *) continue ;; esac
  [ -d "$package/test/src" ] || continue
  case "$path" in
    "$package/test/src/"*|"$package/test/meta_test.dart"|"$package/test/misc_test.dart") continue ;;
  esac
  rel="${path#"$package/test/"}"
  [ -f "$package/lib/${rel%_test.dart}.dart" ] || misplaced="$misplaced  $path
"
done < <(printf '%s\n' "$changes" | in_selected test "$@")

# lib/ files without a test at all, except those of baselines/untested.txt.
# Entries of that list that are now tested, or gone, are stale.
untested_list="baselines/untested.txt"
[ -f "$untested_list" ] || die "$untested_list is missing"
known_untested="$(grep -v '^#' "$untested_list" | grep .)"
untested=""
stale=""
for package in "$@"; do
  is_example "$package" && continue
  [ -d "$package/lib" ] || continue
  while IFS= read -r path; do
    is_generated "$path" && continue
    rel="${path#"$package/lib/"}"
    candidates="$(tests_for "$package" "$rel")"
    test_file="$(or_list "$candidates")"
    has_test=0
    while IFS= read -r candidate; do
      [ -e "$candidate" ] && has_test=1
    done <<<"$candidates"
    if [ "$has_test" = 1 ] || is_directives_only "$path"; then
      grep -Fqx "$path" <<<"$known_untested" && stale="$stale  $path
"
    else
      grep -Fqx "$path" <<<"$known_untested" || untested="$untested  $path -> $test_file
"
    fi
  done < <(find "$package/lib" -name '*.dart' ! -name '*_test.dart' -exec printf 'M\t%s\n' {} + |
    in_selected lib "$package" | cut -f 2 | sort)
  while IFS= read -r path; do
    [ -n "$path" ] && [ ! -f "$path" ] && stale="$stale  $path
"
  done < <(awk -v p="$package/lib/" 'index($0, p) == 1' <<<"$known_untested")
done

status=0
if [ -n "$missing" ]; then
  printf 'These lib/ files changed without a change to their test (since %s):\n%s' "$base" "$missing" >&2
  printf 'Add or update the test of each file, at the same path in test/ as in lib/. Comment-only changes are exempt.\n' >&2
  printf 'Only add a test that would catch a bug the existing tests miss. Do not write one just to pass this check: if other tests already cover the change (such as goldens), say so in the pull request, and an admin can merge it despite this failure.\n\n' >&2
  status=1
fi
# Unlike the rule above, the checks below cannot be bypassed.
others=0
if [ -n "$orphans" ]; then
  printf 'These test/src/ files have no matching lib/src/ file:\n%s' "$orphans" >&2
  printf 'Move each test next to the path of the file it tests, or out of test/src/.\n\n' >&2
  status=1
  others=1
fi
if [ -n "$misplaced" ]; then
  printf 'These new tests are outside test/src/ (since %s):\n%s' "$base" "$misplaced" >&2
  printf 'Move each test to the path in test/ of the lib/ file it tests (lib/src/x.dart -> test/src/x_test.dart).\n\n' >&2
  status=1
  others=1
fi
if [ -n "$untested" ]; then
  printf 'These lib/ files have no test:\n%s' "$untested" >&2
  printf 'Add a test for each file, at the same path in test/ as in lib/.\n\n' >&2
  status=1
  others=1
fi
if [ -n "$stale" ]; then
  printf 'These entries of %s are now tested, or no longer exist:\n%s' "$untested_list" "$stale" >&2
  printf 'Remove them from %s.\n\n' "$untested_list" >&2
  status=1
  others=1
fi
if [ -n "$missing" ] && [ "$others" = 1 ]; then
  printf 'Only the first issue can be bypassed by an admin. Fix the others.\n\n' >&2
fi
[ "$status" = 0 ] && echo "Every lib/ file has a test, updated with it, every test/src/ file has its lib/src/ file, and every new test outside test/src/ tests a lib/ file outside lib/src/, or is meta_test.dart or misc_test.dart."
exit "$status"
