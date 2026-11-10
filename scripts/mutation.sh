#!/usr/bin/env bash
# Mutation testing of packages/riverpod, with dart_mutant: each lib/ file is
# changed in one small place at a time (a mutant), and its own test, the
# test/**/x_test.dart of lib/**/x.dart, must then fail. Each file must have
# as many surviving mutants as baselines/mutation.yaml lists for it (none if
# unlisted), and survivors are reported with whether that test even runs
# their line.
#
# By default, only the mutants on the lines changed since REF are run, so
# that a change pays for the code it touches rather than for the size of its
# files, and none of them may survive: the baseline counts the survivors of
# whole files, which such a run does not see. Blank and `//` comment lines do
# not count as changed. dart_mutant has no option for this, so it is first
# run without running a test, to list the mutants of the changed files, and
# the others are then marked as done in its state (see
# tools/repo_checks/bin/scope_mutation.dart).
#
# With --whole-files, every mutant of the files changed since REF, or whose
# test changed, is run instead, and each file must have as many surviving
# mutants as baselines/mutation.yaml lists for it (none if unlisted). The
# daily run of --all checks every file that way. Generated and
# directives-only files, and files without a test, are skipped.
#
# packages/riverpod is in a pub workspace, which dart_mutant cannot copy, so
# it mutates the files IN PLACE, one mutant at a time: do not edit, commit or
# switch branches while it runs, nor run other checks. An interrupted run
# puts the files back; one that was killed is put back by the next run.
#
# A run can be divided over several machines: each runs its part with
# --shard, and one more puts the parts together with --merge and checks them.
#
# Usage: scripts/mutation.sh [--base REF | --all] [--whole-files]
#                            [--shard I/N | --merge DIR] [--update-baseline]
#   --base REF           Ref to compare against (default: origin/master;
#                        fetched if missing).
#   --all                Every mutant of every file.
#   --whole-files        Every mutant of the changed files, checked against
#                        the baseline.
#   --shard I/N          Only run part I of N of the mutants of each file,
#                        and write it to .dart_tool/mutation/part-I.json
#                        without checking it.
#   --merge DIR          Mutate nothing: put the parts DIR/part-*.json of a
#                        run with --shard together, and check them. Give it
#                        the same files as the parts (--base or --all, and
#                        --whole-files).
#   --update-baseline    Set the entries of the mutated files in
#                        baselines/mutation.yaml to their number of
#                        survivors, instead of checking them. Implies
#                        --whole-files.
#
# The report is left at packages/riverpod/.dart_tool/mutation/, as JSON and
# as a page for a browser.

set -uo pipefail
# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

package="packages/riverpod"
# A newer version may make other mutants of the same code, which would
# change what the baseline counts.
dart_mutant_version="0.2.1"

base="origin/master"
all=0
whole=0
update=""
shard=""
merge=""
while [ $# -gt 0 ]; do
  case "$1" in
    --base) [ $# -ge 2 ] || die "$1 needs a ref"; base="$2"; shift 2 ;;
    --all) all=1; shift ;;
    --whole-files) whole=1; shift ;;
    --shard) [ $# -ge 2 ] || die "$1 needs I/N"; shard="$2"; shift 2 ;;
    --merge) [ $# -ge 2 ] || die "$1 needs a folder"; merge="$2"; shift 2 ;;
    --update-baseline) update="--update-baseline"; whole=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument '$1' (see --help)" ;;
  esac
done
if [ -n "$shard" ]; then
  if ! [[ "$shard" =~ ^([1-9][0-9]*)/([1-9][0-9]*)$ ]] ||
     [ "${BASH_REMATCH[1]}" -gt "${BASH_REMATCH[2]}" ]; then
    die "--shard must look like 2/3"
  fi
  [ -z "$merge" ] || die "--shard and --merge exclude each other"
  [ -z "$update" ] || die "--update-baseline needs the whole run: give it to --merge"
fi
if [ -n "$merge" ]; then
  # Absolute, as the paths below are relative to the package. It may not
  # exist when there is nothing to mutate, so no part was written.
  case "$merge" in /*) ;; *) merge="$PWD/$merge" ;; esac
fi

cd "$ROOT/$package" || exit 1

# The lib/ file that test/**/x_test.dart tests, and the reverse.
test_of() { local t="test/${1#lib/}"; printf '%s' "${t%.dart}_test.dart"; }
lib_of() { local l="lib/${1#test/}"; printf '%s' "${l%_test.dart}.dart"; }

# The lib/ files changed since $1, or whose test changed, untracked ones
# included.
changed_files() {
  local path
  {
    git diff --name-only --relative --no-renames "$1" -- lib test
    git ls-files --others --exclude-standard -- lib test
  } | while IFS= read -r path; do
    case "$path" in
      test/*_test.dart) lib_of "$path"; echo ;;
      lib/*.dart) echo "$path" ;;
    esac
  done | sort -u
}

# The diff of lib/ since $1, with no context, untracked files included.
changed_lines() {
  local path status
  git diff -U0 --no-color --no-ext-diff --no-renames --relative \
    --src-prefix=a/ --dst-prefix=b/ "$1" -- lib || return
  git ls-files --others --exclude-standard -- lib | while IFS= read -r path; do
    git diff --no-index -U0 --no-color --no-ext-diff \
      --src-prefix=a/ --dst-prefix=b/ /dev/null "$path"
    # 1 tells that they differ.
    status=$?
    [ "$status" -le 1 ] || exit "$status"
  done
}

# scope_mutation, with paths relative to the package.
scope() { (cd "$ROOT" && dart run repo_checks:scope_mutation "$@"); }

out=".dart_tool/mutation"
mkdir -p "$out"
# The changes whose lines are mutated, unless whole files are.
diff=""
if [ "$all" = 1 ]; then
  candidates="$(find lib -name '*.dart' | sort)"
else
  from="$(fork_point "$base")" || exit
  if [ "$whole" = 1 ]; then
    candidates="$(changed_files "$from")" || die "could not list the changes since $base"
  else
    diff="$PWD/$out/changed.diff"
    changed_lines "$from" >"$diff" || die "could not list the changes since $base"
    ensure_deps
    candidates="$(scope files "$diff")" || die "could not read the changes since $base"
  fi
fi

files=()
while IFS= read -r path; do
  [ -n "$path" ] && [ -f "$path" ] && [ -f "$(test_of "$path")" ] || continue
  is_generated "$path" && continue
  is_directives_only "$path" && continue
  files+=("$path")
done <<<"$candidates"

if [ ${#files[@]} -eq 0 ]; then
  if [ "$all" = 1 ]; then echo "$package has no file to mutate."
  elif [ -n "$diff" ]; then echo "No line of $package to mutate changed since $base."
  else echo "No file of $package to mutate changed since $base."; fi
  exit 0
fi

ensure_deps
dart pub global list 2>/dev/null | grep -qx "dart_mutant $dart_mutant_version" ||
  dart pub global activate dart_mutant "$dart_mutant_version" >/dev/null ||
  die "could not activate dart_mutant $dart_mutant_version"

# Runs dart_mutant on the files, with the options $@: on every mutant, or
# with $diff, on those on its lines.
mutate() {
  if [ -z "$diff" ]; then
    dart pub global run dart_mutant run --force "$@" "${files[@]}"
    return
  fi
  echo "Finding the mutants of ${#files[@]} file(s) on the lines changed since $base..."
  # The part of a mutant number that no file reaches: every mutant is
  # found and left Pending in the state, and no test is run.
  dart pub global run dart_mutant run --force --shard 1000000/1000000 \
    --report "$out/scope.json" "${files[@]}" >/dev/null
  case $? in 0|1) ;; *) die "dart_mutant failed" ;; esac
  scope mark "$diff" "$PWD/.dart_tool/dart_mutant/incremental.json" ||
    die "could not limit the mutants to the changed lines"
  # Without --force: the mutants marked as done are not run.
  dart pub global run dart_mutant run "$@" "${files[@]}"
}

if [ -n "$shard" ]; then
  part="$out/part-${shard%/*}.json"
  echo "Mutating part $shard of ${#files[@]} file(s) of $package in place; leave them alone until the run ends."
  mutate --shard "$shard" --report "$part"
  # 1 is a survivor, or a file that could not be tested: --merge judges.
  case $? in 0|1) ;; *) die "dart_mutant failed" ;; esac
  [ -f "$part" ] || die "dart_mutant wrote no report at $package/$part"
  echo "Part: $package/$part"
  exit 0
fi

ensure_pub_global coverage coverage

# Which lines each test runs of its file, to tell a survivor that its test
# never runs from one it does not check.
echo "Collecting the coverage of the tests of ${#files[@]} file(s)..."
for path in "${files[@]}"; do
  raw="$(mktemp -d "${TMPDIR:-/tmp}/riverpod-mutation.XXXXXX")" || die "mktemp failed"
  mkdir -p "$out/coverage/$(dirname "$path")"
  if ! log="$(dart test --coverage="$raw" "$(test_of "$path")" 2>&1)" ||
     ! dart pub global run coverage:format_coverage --lcov --in="$raw" \
       --out="$out/coverage/$path.info" --report-on=lib >/dev/null; then
    printf '%s\n' "$log" >&2
    rm -rf "${raw:?}"
    die "the tests of $path fail without a mutant"
  fi
  rm -rf "${raw:?}"
done

# So that a failed run never leaves the report of an older one to check.
rm -f "$out/mutation.json" "$out/mutation.html"
if [ -n "$merge" ]; then
  parts=("$merge"/part-*.json)
  [ -f "${parts[0]}" ] || die "no part-*.json in $merge"
  echo "Merging ${#parts[@]} part(s) from $merge..."
  dart pub global run dart_mutant merge "${parts[@]}" \
    --report "$out/mutation.json" --html "$out/mutation.html"
  # It fails without a report when the parts are not those of one run.
  case $? in 0|1) ;; *) die "dart_mutant merge failed" ;; esac
else
  echo "Mutating ${#files[@]} file(s) of $package in place; leave them alone until the run ends."
  mutate --report "$out/mutation.json" --html "$out/mutation.html"
  # 1 is a survivor, or a file that could not be tested: check_mutation judges.
  case $? in 0|1) ;; *) die "dart_mutant failed" ;; esac
fi
echo "Report: $package/$out/mutation.html"

scoped=()
[ -z "$diff" ] || scoped=(--changed-lines "$diff")
cd "$ROOT" || exit 1
# shellcheck disable=SC2086 # $update is empty or a flag
exec dart run repo_checks:check_mutation "$ROOT" "$package" \
  "$package/$out/mutation.json" "$package/$out/coverage" $update \
  ${scoped[@]+"${scoped[@]}"} "${files[@]}"
