# shellcheck shell=bash
# Which packages CI checks, and readers for package_graph.yaml.
# Source it after common.sh.

# ---------------------------------------------------------------------------
# Packages CI analyzes and tests. One per line:
#   <path> <format|noformat> <flutter|dart>
# The last column picks the test runner. Packages without a test/ folder are
# not tested. The riverpod_analyzer_utils*/riverpod_lint* packages were never
# format-checked and always used `dart test` in the old CI; that is preserved.
# Code generation is not limited to this list: it covers every package marked
# `codegen: true` in package_graph.yaml.
# ---------------------------------------------------------------------------
PACKAGES="
packages/riverpod                                  format   dart
packages/riverpod_generator                        format   dart
packages/riverpod_lint_flutter_test                noformat dart
packages/riverpod_analyzer_utils_tests             noformat dart
packages/flutter_riverpod                          format   flutter
packages/hooks_riverpod                            format   flutter
packages/riverpod_generator/integration/build_yaml format   dart
packages/riverpod_annotation                       format   dart
packages/riverpod_analyzer_utils                   noformat dart
packages/riverpod_lint                             noformat dart
packages/riverpod/example                          format   dart
packages/flutter_riverpod/example                  format   flutter
packages/hooks_riverpod/example                    format   flutter
examples/counter                                   format   flutter
examples/marvel                                    format   flutter
examples/pub                                       format   flutter
examples/random_number                             format   flutter
examples/stackoverflow                             format   flutter
examples/todos                                     format   flutter
"
# (Listed roughly slowest-first, so parallel runs start long tasks early.)

ci_packages() { awk 'NF { print $1 }' <<<"$PACKAGES"; }
ci_formatted_packages() { awk '$2 == "format" { print $1 }' <<<"$PACKAGES"; }
ci_tested_packages() {
  local p
  for p in $(ci_packages); do [ -d "$ROOT/$p/test" ] && echo "$p"; done
}
test_runner() { awk -v p="$1" '$1 == p { print $3 }' <<<"$PACKAGES"; }

# ---------------------------------------------------------------------------
# package_graph.yaml readers. The file is generated with a fixed layout (and
# scripts/graph.sh --check guarantees it is current), so line matching is safe.
# ---------------------------------------------------------------------------
GRAPH="$ROOT/package_graph.yaml"
# shellcheck disable=SC2034 # used by graph.sh
GRAPH_TOOL="tools/package_graph/bin/package_graph.dart"

require_graph() {
  [ -f "$GRAPH" ] || die "package_graph.yaml is missing. Create it with: scripts/graph.sh"
}

# "<name> <path> <codegen>" for every package.
graph_packages() {
  awk '
    /^[^ #]/            { in_packages = ($0 == "packages:"); next }
    !in_packages        { next }
    /^  [^ ]/           { name = substr($0, 3, length($0) - 3); next }
    /^    path: /       { path[name] = substr($0, 11) }
    /^    codegen: /    { codegen[name] = substr($0, 14); order[++n] = name }
    END { for (i = 1; i <= n; i++) print order[i], path[order[i]], codegen[order[i]] }
  ' "$GRAPH"
}

# One line per layer, with space-separated package names.
graph_layers() {
  sed -n '/^layers:$/,$ s/^  - \[\(.*\)\]$/\1/p' "$GRAPH" | sed 's/, */ /g'
}

graph_paths() { graph_packages | awk '{ print $2 }'; }

# Dies unless every argument is a known package path.
validate_packages() {
  local known p
  known="$( { ci_packages; [ -f "$GRAPH" ] && graph_paths; } | sort -u)"
  for p in "$@"; do
    # shellcheck disable=SC2001 # sed reads better than ${//} for a prefix
    grep -qx "$p" <<<"$known" || die "unknown package '$p'. Known packages:
$(sed "s/^/  /" <<<"$known")"
  done
}
