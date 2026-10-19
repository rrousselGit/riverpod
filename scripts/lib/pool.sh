# shellcheck shell=bash
# A small parallel task runner with one log per task. Source it after
# common.sh.
#
#   pool_init               Start a pool (its own temp dir, in $POOL_DIR).
#   pool_add LABEL CMD      Queue CMD, run with bash from the repo root.
#   pool_run                Run the queue, $POOL_JOBS at a time. Fails if any
#                           task of this batch failed.
#   pool_inline LABEL CMD   Run CMD now in the foreground, streaming output,
#                           but still record it for pool_report.
#   pool_report             Print failed logs and how to re-run each failure.
#                           Deletes the logs when nothing failed.
#
# CMD doubles as the re-run hint, so queue commands a human could paste.

POOL_JOBS="${CHECK_JOBS:-$(cpu_count)}"

pool_slug() { printf '%s' "$1" | tr -c 'A-Za-z0-9._-' '_'; }

pool_init() {
  POOL_DIR="$(mktemp -d "${TMPDIR:-/tmp}/riverpod-scripts.XXXXXX")" || die "mktemp failed"
  : >"$POOL_DIR/tasks"
  : >"$POOL_DIR/queue"
  POOL_START=$(date +%s)
}

pool_add() { printf '%s\t%s\n' "$1" "$2" >>"$POOL_DIR/queue"; }

# Prints the "LABEL<tab>CMD" lines on stdin whose task failed.
pool_failed() {
  local line
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    [ "$(cat "$POOL_DIR/$(pool_slug "${line%%$'\t'*}").status" 2>/dev/null)" = 0 ] ||
      printf '%s\n' "$line"
  done
}

pool_run() {
  local queue
  queue="$(cat "$POOL_DIR/queue")"
  : >"$POOL_DIR/queue"
  [ -z "$queue" ] && return 0
  printf '%s\n' "$queue" >>"$POOL_DIR/tasks"
  printf '%s\n' "$queue" | tr '\n' '\0' |
    xargs -0 -n 1 -P "$POOL_JOBS" bash "$SCRIPTS/lib/pool_worker.sh" "$POOL_DIR"
  [ -z "$(pool_failed <<<"$queue")" ]
}

pool_inline() {
  local slug status
  slug="$(pool_slug "$1")"
  printf '%s\t%s\n' "$1" "$2" >>"$POOL_DIR/tasks"
  touch "$POOL_DIR/$slug.inline"
  (cd "$ROOT" && bash -c "$2") 2>&1 | tee "$POOL_DIR/$slug.log"
  status=${PIPESTATUS[0]}
  echo "$status" >"$POOL_DIR/$slug.status"
  return "$status"
}

pool_report() {
  local failed total nfailed label cmd slug secs
  secs=$(( $(date +%s) - POOL_START ))
  total="$(grep -c . "$POOL_DIR/tasks")"
  failed="$(pool_failed <"$POOL_DIR/tasks")"
  nfailed="$(grep -c . <<<"$failed")"
  echo
  if [ "$nfailed" = 0 ]; then
    if [ "$total" = 0 ]; then
      echo "Nothing to run for these options."
    else
      echo "All $total tasks passed in ${secs}s."
    fi
    rm -rf "$POOL_DIR"
    return 0
  fi
  while IFS=$'\t' read -r label cmd; do
    slug="$(pool_slug "$label")"
    # The annotation carries the end of the log: unlike the log itself, it can
    # be read without access to the repository's Actions.
    in_ci && printf '::error title=%s failed::%s\n' "$label" "$(
      { printf 'Re-run locally with: %s\n\n' "$cmd"; tail -n 40 "$POOL_DIR/$slug.log" 2>/dev/null; } |
        sed 's/%/%25/g; s/\r/%0D/g' | awk '{ printf "%s%%0A", $0 }'
    )"
    # Inline tasks already streamed their output.
    [ -f "$POOL_DIR/$slug.inline" ] && continue
    in_ci && echo "::group::Log: $label"
    echo "──── FAILED: $label ────"
    cat "$POOL_DIR/$slug.log"
    in_ci && echo "::endgroup::"
    echo
  done <<<"$failed"
  echo "$nfailed of $total tasks failed in ${secs}s. Re-run a failure with:"
  while IFS=$'\t' read -r label cmd; do
    printf '  %-48s %s\n' "$label" "$cmd"
  done <<<"$failed"
  echo "Logs: $POOL_DIR"
  return 1
}
