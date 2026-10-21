# shellcheck shell=bash
# Helpers shared by scripts/*.sh. Source it; don't run it.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# shellcheck disable=SC2034 # used by the scripts sourcing this
SCRIPTS="$ROOT/scripts"

die() { printf '%s: %s\n' "$(basename "$0")" "$*" >&2; exit 2; }
in_ci() { [ -n "${GITHUB_ACTIONS:-}" ]; }

# Prints the comment block at the top of the calling script.
usage() { sed -n '2,/^$/s/^# \{0,1\}//p' "$0"; }

cpu_count() { nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4; }

# Strips "./" and trailing "/" so "./packages/riverpod/" works as a package.
normalize() {
  local p="${1#./}"
  while [ "${p%/}" != "$p" ]; do p="${p%/}"; done
  printf '%s' "$p"
}

# Runs `flutter pub get` at the root unless it already ran since the last
# pubspec.yaml change. One resolution covers the whole pub workspace, which is
# why the scripts can pass --no-pub and run in parallel without racing on it.
ensure_deps() {
  [ "${SCRIPTS_DEPS_READY:-}" = 1 ] && return 0
  local stamp="$ROOT/.dart_tool/scripts_pub_get.stamp" log
  if [ -f "$stamp" ] && [ -z "$(cd "$ROOT" && find . \
       \( -name node_modules -o -name .dart_tool -o -name build -o -name .git \) -prune \
       -o -name pubspec.yaml -newer "$stamp" -print 2>/dev/null | head -n 1)" ]; then
    export SCRIPTS_DEPS_READY=1
    return 0
  fi
  echo "Running flutter pub get..." >&2
  log="$(cd "$ROOT" && flutter pub get 2>&1)" || { printf '%s\n' "$log" >&2; die "flutter pub get failed"; }
  mkdir -p "$ROOT/.dart_tool" && touch "$stamp"
  export SCRIPTS_DEPS_READY=1
}

# ensure_pub_global NAME ACTIVATE_ARGS...: activates a global tool if missing.
ensure_pub_global() {
  local name="$1" list
  shift
  list="$(dart pub global list 2>/dev/null || true)"
  grep -q "^$name " <<<"$list" && return 0
  dart pub global activate "$@" >/dev/null || die "could not activate $name"
}

# Prints the commit the current branch forked from REF, fetching REF first if
# it is a missing origin/* ref. Comparing against the fork point means commits
# that landed on REF since are not mistaken for changes of this branch.
# Shallow CI clones may not have it, in which case REF itself is the best
# guess.
fork_point() {
  if ! git -C "$ROOT" rev-parse --verify --quiet "$1" >/dev/null; then
    case "$1" in
      origin/*) git -C "$ROOT" fetch --no-tags origin "${1#origin/}:refs/remotes/$1" >&2 || exit 1 ;;
      *) die "ref '$1' does not exist" ;;
    esac
  fi
  git -C "$ROOT" merge-base "$1" HEAD 2>/dev/null || echo "$1"
}

# Generated Dart files: *.g.dart, *.freezed.dart, or a "GENERATED" header.
is_generated() {
  case "$1" in *.g.dart|*.freezed.dart) return 0 ;; esac
  head -n 5 "$1" 2>/dev/null | grep -q 'GENERATED'
}

# Example packages: examples/*, any package named example, and the other
# non-library projects (benchmarks, website, other_projects/*).
is_example() {
  case "$1" in
    examples/*|*/example|example|benchmarks|website|other_projects/*) return 0 ;;
  esac
  return 1
}

# Whether the file only holds directives (export, import, library, part),
# optionally annotated, like the barrel files that re-export lib/src.
is_directives_only() {
  awk '
    { sub(/\/\/.*/, ""); code = code " " $0 }
    END {
      n = split(code, statements, ";")
      for (k = 1; k <= n; k++) {
        st = statements[k]
        gsub(/^[ \t]+|[ \t]+$/, "", st)
        # Strips leading annotations, such as @Deprecated(...).
        while (match(st, /^@[A-Za-z_.]+(\([^)]*\))?[ \t]*/)) st = substr(st, RLENGTH + 1)
        if (st == "") continue
        if (st ~ /^part[ \t]+of[ \t]/) exit 1
        if (st !~ /^(export|import|library|part)([^A-Za-z0-9_$]|$)/) exit 1
      }
    }
  ' "$1"
}

# ---------------------------------------------------------------------------
# package_graph.yaml readers. The file is generated with a fixed layout (and
# scripts/graph.sh --check guarantees it is current), so line matching is safe.
# It also says how CI tests each package (`test`); see the file's header.
# ---------------------------------------------------------------------------
GRAPH="$ROOT/package_graph.yaml"
# shellcheck disable=SC2034 # used by graph.sh
GRAPH_TOOL="tools/package_graph/bin/package_graph.dart"

require_graph() {
  [ -f "$GRAPH" ] || die "package_graph.yaml is missing. Create it with: scripts/graph.sh"
}

# "<name> <path> <codegen> <test>" for every package.
graph_packages() {
  require_graph
  awk '
    /^[^ #]/            { in_packages = ($0 == "packages:"); next }
    !in_packages        { next }
    /^  [^ ]/           { name = substr($0, 3, length($0) - 3); next }
    /^    path: /       { path[name] = substr($0, 11); order[++n] = name }
    /^    codegen: /    { codegen[name] = substr($0, 14) }
    /^    test: /       { test[name] = substr($0, 11) }
    END {
      for (i = 1; i <= n; i++) {
        p = order[i]
        print p, path[p], codegen[p], test[p]
      }
    }
  ' "$GRAPH"
}

# One line per layer, with space-separated package names.
graph_layers() {
  sed -n '/^layers:$/,$ s/^  - \[\(.*\)\]$/\1/p' "$GRAPH" | sed 's/, */ /g'
}

ci_packages() { graph_packages | awk '{ print $2 }'; }
ci_tested_packages() { graph_packages | awk '$4 != "none" { print $2 }'; }
# none, chrome, flutter or dart.
test_runner() { graph_packages | awk -v p="$1" '$2 == p { print $4 }'; }

# Dies unless every argument is a known package path.
validate_packages() {
  local known p
  known="$(ci_packages)" || exit
  for p in "$@"; do
    # shellcheck disable=SC2001 # sed reads better than ${//} for a prefix
    grep -Fqx "$p" <<<"$known" || die "unknown package '$p'. Known packages:
$(sed "s/^/  /" <<<"$known")"
  done
}
