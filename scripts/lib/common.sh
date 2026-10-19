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
