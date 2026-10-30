#!/usr/bin/env bash
# Runs the tests that the current branch adds or changes against the lib/
# code of its base, and reports which of them pass there. A test added along
# with a fix should fail without the fix: one that passes may not test it.
#
# The tests run in a temporary git worktree of the fork point, with every
# change of the branch applied except those to the lib/ folders of packages.
# The lib/ folder of a package that only holds tests (riverpod_lint's tests,
# integration packages) counts as tests. Generated code is regenerated there,
# so tests of a code generator see the output of the base generator.
#
# Each test is then reported as:
# - Caught: a new test that fails, or does not compile, on the base. Changed
#   tests (same name as before) that fail on the base are caught too.
# - Not caught: a new test that passes on the base.
# Tests that passed before the branch changed their file, under the same
# name, are left out: they are the unchanged tests of a changed file. So is
# a changed test that still passes, as it cannot be told apart from those.
#
# Nothing is reported, and no test runs, when the branch changes no lib/ file
# or no test. The report never fails the script: it is meant for a comment.
#
# Usage: scripts/tests_on_base.sh [--base REF] [--output FILE]
#   --base REF     Ref to compare against (default: origin/master). Changes
#                  are taken from where the current branch forked from REF
#                  up to the working tree, untracked files included.
#   --output FILE  Write the Markdown report to FILE (default: stdout). FILE
#                  is left empty when there is nothing to report.

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

base="origin/master"
output=""
while [ $# -gt 0 ]; do
  case "$1" in
    --base)   [ $# -ge 2 ] || die "$1 needs a ref"; base="$2"; shift 2 ;;
    --output) [ $# -ge 2 ] || die "$1 needs a file"; output="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument '$1' (see --help)" ;;
  esac
done
command -v jq >/dev/null || die "jq is not on PATH"
[ -z "$output" ] || : >"$output" || die "could not write $output"
cd "$ROOT" || exit 1

from="$(fork_point "$base")" || exit

# "<status>\t<path>" of every changed file, untracked ones as added.
changes="$(
  git diff --name-status --no-renames "$from" -- &&
    git ls-files --others --exclude-standard | awk '{ print "A\t" $0 }'
)" || die "could not list the changes since $base"

# Packages whose whole content is tests: their lib/ is test code.
is_test_package() {
  [ -n "$(tests_of "$1")" ] && return 0
  case "$1" in */integration/*) return 0 ;; esac
  return 1
}

# Appends to each "<status>\t<path>" line of stdin the package owning the
# path, and whether the path is "lib" (library code, reverted to the base),
# "test" (a *_test.dart of a tested package) or "other". Nested packages
# (such as packages/x/example) are their own packages, so the longest
# matching package path wins.
packages="$(graph_packages)" || exit
library_packages="$(awk '{ print $2 }' <<<"$packages" | while read -r p; do
  is_example "$p" || is_test_package "$p" || echo "$p"
done | tr '\n' ' ')"
classify() {
  # The package list goes through the environment, as BSD awk rejects
  # newlines in -v values.
  GRAPH_PACKAGES="$packages" awk -F '\t' -v OFS='\t' -v libs="$library_packages" '
    BEGIN {
      n = split(ENVIRON["GRAPH_PACKAGES"], lines, "\n")
      for (k = 1; k <= n; k++) { split(lines[k], f, " "); known[k] = f[2]; runner[f[2]] = f[4] }
      split(libs, l, " "); for (k in l) library[l[k]] = 1
    }
    {
      owner = ""
      for (k = 1; k <= n; k++) {
        p = known[k]
        if (index($2, p "/") == 1 && length(p) > length(owner)) owner = p
      }
      kind = "other"
      if (owner != "" && (owner in library) && index($2, owner "/lib/") == 1) kind = "lib"
      else if (owner != "" && runner[owner] != "none" && index($2, owner "/test/") == 1 &&
               $2 ~ /_test\.dart$/ && $1 != "D") kind = "test"
      print $1, $2, owner, kind
    }
  '
}
changes="$(printf '%s\n' "$changes" | grep . | classify)"

if ! awk -F '\t' '$4 == "lib" { found = 1 } END { exit !found }' <<<"$changes"; then
  echo "No lib/ file changed since $base: nothing to compare." >&2
  exit 0
fi
test_packages="$(awk -F '\t' '$4 == "test" { print $3 }' <<<"$changes" | sort -u)"
if [ -z "$test_packages" ]; then
  echo "No test changed since $base: nothing to compare." >&2
  exit 0
fi

# Resolved, as `flutter test` reports test paths with symlinks resolved
# (/var is /private/var on macOS).
tmp="$(cd "$(mktemp -d)" && pwd -P)" || die "could not create a temporary folder"
wt="$tmp/worktree"
cleanup() {
  git worktree remove --force "$wt" >/dev/null 2>&1
  rm -rf "$tmp"
}
trap cleanup EXIT
git worktree add --quiet --detach "$wt" "$from" || die "could not create a worktree of $from"

pub_get() {
  local log
  log="$(cd "$wt" && flutter pub get 2>&1)" || { printf '%s\n' "$log" >&2; die "flutter pub get failed in the base worktree"; }
}

# run_tests PACKAGE OUT FILE...: runs FILEs (relative to PACKAGE) in the
# worktree, and writes "<file>\t<test name>\t<pass|fail|skip>" lines to OUT.
# A file that fails to load (it does not compile, say) gets one line with an
# empty test name and "fail".
run_tests() {
  local package="$1" out="$2" preset="" events="$tmp/events.json"
  shift 2
  awk '/^presets:/ { p = 1; next } /^[^ #]/ { p = 0 } p && /^  check:/ { f = 1 } END { exit !f }' \
    "$wt/$package/dart_test.yaml" 2>/dev/null && preset="-P check"
  echo "Running $# test file(s) of $package on the base..." >&2
  # Failing tests are the point, so the exit code is ignored.
  # shellcheck disable=SC2086 # $preset is empty or a flag and its value
  (
    cd "$wt/$package" || exit 1
    case "$(test_runner "$package")" in
      chrome)  flutter test --no-pub --platform chrome --reporter json $preset "$@" ;;
      flutter) flutter test --no-pub --reporter json $preset "$@" ;;
      *)       dart test --reporter json $preset "$@" ;;
    esac
  ) 2>/dev/null | grep '^{' >"$events"
  jq -rs --arg root "$wt/$package/" '
    (map(select(.type == "suite") | { key: (.suite.id | tostring), value: (.suite.path | ltrimstr($root)) })
      | from_entries) as $suites
    | (map(select(.type == "testStart") | { key: (.test.id | tostring), value: .test }) | from_entries) as $tests
    | .[]
    | select(.type == "testDone" and (.hidden | not))
    | $tests[.testID | tostring] as $t
    | [ $suites[$t.suiteID | tostring],
        (if ($t.groupIDs | length) == 0 and ($t.name | startswith("loading ")) then "" else $t.name end),
        (if .skipped then "skip" elif .result == "success" then "pass" else "fail" end) ]
    | @tsv
  ' "$events" >"$out" || die "could not read the test results of $package"
}

# The tests of the changed test files as they were before the branch, which
# tells the new tests apart from the existing ones.
pub_get
: >"$tmp/before.tsv"
for package in $test_packages; do
  files="$(awk -F '\t' -v p="$package" '$1 == "M" && $3 == p && $4 == "test" { print substr($2, length(p) + 2) }' <<<"$changes")"
  [ -n "$files" ] || continue
  # shellcheck disable=SC2086 # test paths have no spaces
  run_tests "$package" "$tmp/out.tsv" $files
  awk -v p="$package/" '{ print p $0 }' "$tmp/out.tsv" >>"$tmp/before.tsv"
done

# Applies every change of the branch but those to lib/ code.
while IFS=$'\t' read -r status path _ kind; do
  [ "$kind" = lib ] && continue
  if [ "$status" = D ]; then
    rm -f "$wt/$path"
  else
    mkdir -p "$(dirname "$wt/$path")" && cp "$path" "$wt/$path" || die "could not copy $path"
  fi
done <<<"$changes"
pub_get
codegen="$(for package in $test_packages; do
  awk -v p="$package" '$2 == p && $3 == "true" { print p }' <<<"$packages"
done)"
if [ -n "$codegen" ]; then
  echo "Regenerating code of:" $codegen >&2
  # shellcheck disable=SC2086 # package paths have no spaces
  (cd "$wt" && scripts/generate.sh $codegen) >&2 || die "code generation failed in the base worktree"
fi

: >"$tmp/after.tsv"
for package in $test_packages; do
  files="$(awk -F '\t' -v p="$package" '$3 == p && $4 == "test" { print substr($2, length(p) + 2) }' <<<"$changes")"
  # shellcheck disable=SC2086 # test paths have no spaces
  run_tests "$package" "$tmp/out.tsv" $files
  # A file without a single result crashed the test runner.
  printf '%s\n' "$files" | awk -F '\t' -v OFS='\t' '
    FILENAME == ARGV[1] { seen[$1] = 1; next }
    !($1 in seen) { print $1, "", "fail" }
  ' "$tmp/out.tsv" - >"$tmp/crashed.tsv"
  cat "$tmp/out.tsv" "$tmp/crashed.tsv" | awk -v p="$package/" '{ print p $0 }' >>"$tmp/after.tsv"
done

# "<verdict>\t<file>\t<name>" of every reported test, where verdict is
# missed (passes on the base), caught or broken (the file does not load).
awk -F '\t' -v OFS='\t' '
  FILENAME == ARGV[1] { if ($3 == "pass") existed[$1 FS $2] = 1; next }
  $2 == "" { print "broken", $1, ""; next }
  $3 == "skip" { next }
  ($1 FS $2) in existed { if ($3 == "fail") print "caught", $1, $2; next }
  { print ($3 == "pass" ? "missed" : "caught"), $1, $2 }
' "$tmp/before.tsv" "$tmp/after.tsv" | sort -u >"$tmp/verdicts.tsv"

# Markdown list items of the tests with VERDICT.
items() {
  awk -F '\t' -v v="$1" '$1 == v {
    gsub(/`/, "\x27", $3)
    print "- `" $2 "`" ($3 == "" ? "" : ": `" $3 "`")
  }' "$tmp/verdicts.tsv"
}
count() { awk -F '\t' -v v="$1" '$1 == v { n++ } END { print n + 0 }' "$tmp/verdicts.tsv"; }
missed="$(count missed)"
caught="$(count caught)"
broken="$(count broken)"

report() {
  echo "<!-- tests-on-base -->"
  echo "### Tests without the \`lib/\` changes"
  echo
  echo "The tests this PR adds or changes ran against the \`lib/\` code of $(git rev-parse --short "$from"), with the rest of this PR. A test written for a fix should fail there."
  echo
  if [ "$missed" -gt 0 ]; then
    echo "**:warning: $missed new test(s) pass without the \`lib/\` changes,** so they may not test them:"
    echo
    items missed
  else
    echo ":white_check_mark: No new test passes without the \`lib/\` changes."
  fi
  if [ "$caught" -gt 0 ]; then
    echo
    echo "<details><summary>$caught test(s) fail without the <code>lib/</code> changes</summary>"
    echo
    items caught
    echo
    echo "</details>"
  fi
  if [ "$broken" -gt 0 ]; then
    echo
    echo "<details><summary>$broken test file(s) do not compile, or crash, without the <code>lib/</code> changes</summary>"
    echo
    items broken
    echo
    echo "</details>"
  fi
  echo
  echo "<sub>Reproduce with \`scripts/tests_on_base.sh\`. Changed tests that still pass are not listed, as they look the same as unchanged ones.</sub>"
}
if [ -n "$output" ]; then report >"$output"; else report; fi
